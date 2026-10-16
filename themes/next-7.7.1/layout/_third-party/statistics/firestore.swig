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
        if (response.status === 404) return null;
        if (!response.ok) throw new Error(`Firestore request failed with status ${response.status}`);
        return response.json();
      };

      // Encode the full article path as one Firestore document ID.
      const documentId = url => encodeURIComponent(url);
      const documentName = url => `${documents}/${firestore.collection}/${documentId(url)}`;
      const getValue = value => Number(value?.integerValue ?? value?.doubleValue ?? 0);
      const getArticleUrl = element => decodeURI(element.getAttribute('id'));

      const getCount = async (url, increaseCount) => {
        if (increaseCount) {
          const data = await fetchFirestore(':commit', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              writes: [{
                transform: {
                  document: documentName(url),
                  fieldTransforms: [{
                    fieldPath: 'count',
                    increment: {
                      integerValue: '1'
                    }
                  }]
                }
              }]
            })
          });
          return getValue(data.writeResults[0].transformResults[0]);
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
            const visitedKey = `firestore:${url}`;
            let increaseCount = CONFIG.hostname === location.hostname;
            if (localStorage.getItem(visitedKey)) {
              increaseCount = false;
            } else {
              // Mark as visited.
              localStorage.setItem(visitedKey, true);
            }
            const count = await getCount(url, increaseCount);
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
