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

      const documentName = title => `${documents}/${firestore.collection}/${title}`;
      const getValue = value => Number(value?.integerValue ?? value?.doubleValue ?? 0);

      const getCount = async (title, increaseCount) => {
        if (increaseCount) {
          const data = await fetchFirestore(':commit', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              writes: [{
                transform: {
                  document: documentName(title),
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
        const document = await fetchFirestore(`/${collection}/${encodeURIComponent(title)}`);
        return getValue(document?.fields?.count);
      };

      const getCounts = async titles => {
        if (titles.length === 0) return [];
        const data = await fetchFirestore(':batchGet', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            documents: titles.map(documentName),
            mask: {
              fieldPaths: ['count']
            }
          })
        });
        const counts = new Map(data.map(result => {
          const document = result.found;
          return [document?.name ?? result.missing, getValue(document?.fields?.count)];
        }));
        return titles.map(title => counts.get(documentName(title)) ?? 0);
      };

      (async () => {
        try {
          if (CONFIG.page.isPost) {
            const title = document.querySelector('.post-title').textContent.trim();
            let increaseCount = CONFIG.hostname === location.hostname;
            if (localStorage.getItem(title)) {
              increaseCount = false;
            } else {
              // Mark as visited.
              localStorage.setItem(title, true);
            }
            const count = await getCount(title, increaseCount);
            document.querySelector('.firestore-visitors-count').innerText = count;
          } else if (CONFIG.page.isHome) {
            const titles = [...document.querySelectorAll('.post-title')].map(element => element.textContent.trim());
            const counts = await getCounts(titles);
            const metas = document.querySelectorAll('.firestore-visitors-count');
            counts.forEach((val, idx) => {
              metas[idx].innerText = val;
            });
          }
        } catch (error) {
          console.warn('Failed to load Firestore visitor count:', error);
        }
      })();
    })();
  </script>
{%- endif %}
