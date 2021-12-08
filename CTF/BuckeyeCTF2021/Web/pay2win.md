# pay2win

*Kyle started an online magazine (The Daily Kyle) and published one of my articles on his site. Don't worry, the article literally contains the flag in plaintext, but if you want to read it you'll have to figure out how to bypass the paywall.*

*URL: https://pay2win.chall.pwnoh.io*

---

查看网页源代码,发现`plantFlag`函数,粘贴到Console中运行后,打印出`shwl_l1_twcd14}1ry4ht3neck_t3_bs{1c_hkh_tsh3he03gy_3l_hu`.

```javascript
const ciphertext = [
    234, 240, 234, 252, 214, 236, 140, 247, 173, 191, 158, 132, 56, 4, 32, 73, 235, 193, 233, 152,
    125, 19, 19, 237, 186, 131, 98, 52, 186, 143, 127, 43, 226, 233, 126, 15, 225, 171, 85, 55,
    173, 123, 21, 147, 97, 21, 237, 11, 254, 129, 2, 131, 101, 63, 149, 61,
];
const plaintext = ciphertext.map((x, i) => (i * i) % 256 ^ x ^ 0x99);

const flagElement = document.querySelector("#flag");
plaintext.map((x, i) => {
    const span = document.createElement("span");
    span.classList.add(`flag-char-${i}`);
    span.textContent = String.fromCharCode(x);
    flagElement.appendChild(span);
    return span;
});
```

查看`main.css`,发现`span`都被设置了`order`属性.

我们可以把`main.css`,`main.js`和网页源代码`a.html`下载到本地.然后注释掉`main.js`里弹窗和阻止滚动的代码.

打开`a.html`,发现本应该显示`flag`的地方有一个灰色的框.

编辑`a.html`,将 `<code id="flag"></code>`这一行代码移动至`<pre>`标签外面,即可看到`flag`.


![pay2win](../../CTF/BuckeyeCTF2021/Web/images/pay2win.jpg)



**flag:**`buckeye{h0ly_sh1t_wh4t_th3_h3ck_1s_th1s_w31rd_ch4ll3ng3}`



