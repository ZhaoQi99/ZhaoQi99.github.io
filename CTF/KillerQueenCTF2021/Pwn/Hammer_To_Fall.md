# Hammer To Fall

*Dynamically sized integers huh (wrap the proper input in a flag wrapper kqctf{number})*

---

源文件:

```python
import numpy as np

a = np.array([0], dtype=int)
val = int(input("This hammer hits so hard it creates negative matter\n"))
if val == -1:
	exit()
a[0] = val
a[0] = (a[0] * 7) + 1
print(a[0])
if a[0] == -1:
	print("flag!")
```
`NumPy`中的int使用的是C中的long,参照[NumPy文档](https://numpy.org/doc/stable/reference/arrays.scalars.html#numpy.int_),最大值为9223372036854775807

```python
>>> 9223372036854775807 // 7 * 2
2635249153387078802
```

**flag:**`kqctf{2635249153387078802}`

