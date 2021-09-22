# digits

*コンピュータは高速に正しく計算してくれますが、昔のコンピュータは今ほど正確に計算できないことがありました。現在もハードウェアの故障などが原因でとても低い確率でコンピュータは計算をミスするでしょう。 運が良いあなたならこの問題が解けるはずです。10 桁の好きな数字をクエリパラメータ q に入れて、神に祈りましょう。*
*[https://tsukuctf.sechack365.com/problems/digits](https://tsukuctf.sechack365.com/problems/digits)*

---

访问`problems/digits`:

```json
{
	"msg": "please input param 'q' (0000000000~9999999999).  example: /?q=1234567890"
}
```

题目给了源码：

```python
from typing import Optional
from fastapi import FastAPI
import random

app = FastAPI()
FLAG = "TsukuCTF{}"

@app.get("/")
def main(q: Optional[str] = None):
    print(q)
    if q == None:
        return {
            "msg": "please input param 'q' (0000000000~9999999999).  example: /?q=1234567890"
        }
    if len(q) != 10:
        return {"msg": "invalid query"}
    if "-" in q or "+" in q:
        return {"msg": "invalid query"}
    try:
        if not type(int(q)) is int:
            return {"msg": "invalid query"}
    except:
        return {"msg": "invalid query"}

    you_are_lucky = 0

    for _ in range(100):
        idx = random.randrange(4)
        if q[idx] < "0":
            you_are_lucky += 1
        if q[idx] > "9":
            you_are_lucky += 1

    if you_are_lucky > 0:
        return {"flag": FLAG}
    else:
        return {"msg": "Sorry... You're unlucky."}
```

要求找到查询参数q的值，满足:

* `q != None`
* `len(q) == 10`
* 不包含`-`和`+`
* 可以使用`int(q)`进行转换
* 至少包含一个0-9之外的字符

`python`中使用`int`进行强制类型转换时会忽略两侧的空格，提交`q=   4567890`即可


```json
{
	"flag": "TsukuCTF{you_are_lucky_Tsukushi}"
}
```

**flag:**`TsukuCTF{you_are_lucky_Tsukushi} `
