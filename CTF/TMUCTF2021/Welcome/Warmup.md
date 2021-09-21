# Warmup

*A fun visual cryptogr aphy tool will amaze your kids!*

---

题目中给出了两张灰度图`ciphered_message.png`和`secret.png`,先用`PIL`看一下图片中每个像素点的值,发现均为0或255.

```python
from PIL import Image
im = Image.open('ciphered_message.png')
print(list(im.getdata()))
```

使用`PIL`合并两张图片即可.

```Python
from PIL import Image

im = Image.open('ciphered_message.png')
im2 = Image.open('secret.png')
assert im.size == im2.size
size = im2.size
print(size)
print(im.mode)
data = [x for x in im.getdata()]
for index,x in enumerate(im2.getdata()):
    if x and data[index]:
        data[index] = 255
    else:
        data[index] = 0

im = Image.new('1',size)
im.putdata(data)
im.save('ans.png')
```

![TMUCTF](assets/ans.png)

**flag:**`TMUCTF{W3_h0p3_y0u_3nj0y_7h15_c0mp371710n_4nd_7h4nk_y0u!}`

