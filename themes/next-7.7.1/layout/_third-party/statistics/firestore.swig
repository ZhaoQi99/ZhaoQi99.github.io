{%- if theme.firestore.enable %}
  <script{{ pjax }}>
    (function() {
      const firestore = {
        projectId: {{ theme.firestore.projectId | json | safe }},
        collection: {{ theme.firestore.collection | json | safe }}
      };
      const database = `projects/${firestore.projectId}/databases/(default)`;
      const documents = `${database}/documents`;
      const api = `https://firestore.googleapis.com/v1/${documents}`;

      const fetchFirestore = async (path, options) => {
        const response = await fetch(`${api}${path}`, options);
        if (response.status === 404 && !options) return null;
        if (!response.ok) {
          const body = await response.json();
          const error = new Error(body.error?.message ?? `Firestore request failed with status ${response.status}`);
          error.code = body.error?.status;
          throw error;
        }
        return response.json();
      };

      // Encode the full article path as one Firestore document ID.
      const documentId = url => encodeURIComponent(url);
      const documentName = url => `${documents}/${firestore.collection}/${documentId(url)}`;
      const getValue = value => Number(value?.integerValue ?? value?.doubleValue ?? 0);
      const getArticleUrl = element => decodeURI(element.getAttribute('id'));

      const getCount = async (url, increaseCount, title) => {
        if (increaseCount) {
          const commit = exists => fetchFirestore(':commit', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              writes: [{
                update: {
                  name: documentName(url),
                  fields: { title: { stringValue: title } }
                },
                updateMask: {
                  fieldPaths: ['title']
                },
                currentDocument: { exists }
              }, {
                transform: {
                  document: documentName(url),
                  fieldTransforms: [{
                    fieldPath: 'count',
                    increment: {
                      integerValue: '1'
                    }
                  }, {
                    fieldPath: 'update_dt',
                    setToServerValue: 'REQUEST_TIME'
                  }, ...(!exists ? [{
                    fieldPath: 'create_dt',
                    setToServerValue: 'REQUEST_TIME'
                  }] : [])]
                }
              }]
            })
          });
          let data;
          try {
            data = await commit(true);
          } catch (error) {
            const missing = error.code === 'PERMISSION_DENIED'
              || error.code === 'NOT_FOUND' && /document/i.test(error.message)
              || error.code === 'FAILED_PRECONDITION' && /document.*(?:does not exist|not found)/i.test(error.message);
            if (!missing) throw error;
            try {
              data = await commit(false);
            } catch (createError) {
              // Another visitor may have created the document in the meantime.
              const exists = createError.code === 'ALREADY_EXISTS'
                || createError.code === 'FAILED_PRECONDITION' && /document.*already exists/i.test(createError.message);
              if (!exists) throw createError;
              data = await commit(true);
            }
          }
          return getValue(data.writeResults[1].transformResults[0]);
        }

        const collection = encodeURIComponent(firestore.collection);
        const document = await fetchFirestore(`/${collection}/${encodeURIComponent(documentId(url))}`);
        return getValue(document?.fields?.count);
      };

      const getCounts = async urls => {
        if (urls.length === 0) return [];
        const data = await fetchFirestore(':batchGet', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            documents: urls.map(documentName),
            mask: {
              fieldPaths: ['count']
            }
          })
        });
        const counts = new Map(data.map(result => {
          const document = result.found;
          return [document?.name ?? result.missing, getValue(document?.fields?.count)];
        }));
        return urls.map(url => counts.get(documentName(url)) ?? 0);
      };

      (async () => {
        try {
          if (CONFIG.page.isPost) {
            const element = document.querySelector('.firestore_visitors');
            if (!element) return;
            const url = getArticleUrl(element);
            const title = element.getAttribute('data-flag-title');
            const visitedKey = `firestore:${url}`;
            const increaseCount = CONFIG.hostname === location.hostname && !localStorage.getItem(visitedKey);
            const count = await getCount(url, increaseCount, title);
            if (increaseCount) {
              // Mark as visited only after a successful commit.
              localStorage.setItem(visitedKey, true);
            }
            document.querySelector('.firestore_visitors .firestore-visitors-count').innerText = count;
          } else if (CONFIG.page.isHome) {
            const metas = [...document.querySelectorAll('.firestore_visitors')];
            const counts = await getCounts(metas.map(getArticleUrl));
            counts.forEach((val, idx) => {
              metas[idx].querySelector('.firestore-visitors-count').innerText = val;
            });
          }
        } catch (error) {
          console.warn('Failed to load Firestore visitor count:', error);
        }
      })();
    })();
  </script>
{%- endif %}
