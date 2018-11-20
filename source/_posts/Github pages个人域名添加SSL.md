---
title: Github pages个人域名添加SSL
categories: Hexo
tags:
  - Hexo
  - Github
abbrlink: 18543
date: 2018-04-10 11:08:11
---
## 前言
寒假的时候用Hexo+Github pages搭建了属于自己的博客，前不久才绑定了个人域名。作为一名有强迫症的程序猿，肯定还要给自己加一个绿色的小锁头。
在网上看别人的博客，大部分是用的[CloudFlare](https://www.cloudflare.com/)提供的免费https服务，也有采用的阿里云提供的一年免费证书，我选择的是后者。
## 准备
- 个人域名:[https://赵旗.top/](https://zhaoqi99.github.io/)
- Github pages
- 阿里云购买的SSL证书

## 添加SSL证书
1. 进入阿里云控制台，依次点击安全(云盾)->CA证书服务，然后点击右上角的购买证书。
![](/images/20180410134416.jpg)
2. 依次选择品牌为`Symantec`，保护类型为`一个域名`，证书类型此时会多出一个选项`免费型DV SSL`点击选择,然后点击立即购买，支付0.00元。
![](/images/20180410134752.jpg)
![](/images/20180410113516.jpg)
<div class="note danger no-icon"><p>注意:免费的SSL证书有效期只有一年，过期之后就需要重新申请了。
</p></div>
3. 支付成功后，点击进入证书控制台，然后点击`补全`，填写相关信息，提交申请。
![](/images/20180410140626.jpg)
![](/images/20180410113758.jpg)
<div class="note warning"><p>
域名验证类型选项记得勾选:证书绑定的域名在【阿里云的云解析】产品中，授权系统自动添加一条记录以完成域名授权验证。
</p></div>
4. 等待20分钟左右，即可收到签发成功的通知了，也可以在证书控制台中实时看到审核进度。
5. 在浏览器中输入https://域名/ ，可以看到地址栏前面有一个小绿锁，很惊喜有没有~
![](/images/20180410140910.jpg)

## http强制跳转https
按照上述步骤添加了SSL证书后，发现如果在地址栏中输入的是https://域名/ 就会有绿锁头，如果输入的是http://域名/ ，则还是http,并不会自动跳转至https。怎样让访客点击http://域名/ 时能强制跳转到https呢？
在Google上看了好多的博客都没能找到解决方案，突然发现Github上有一个`Enforce HTTPS`选项，抱着试一试的心态，最后竟然成功了。
1. 登录Github，进入自己的Github.io项目中，点击`Setting`，往下拉，可以看到有个选项叫`Enforce HTTPS`,点击勾选。
![](/images/20180410115944.jpg)
2. 打开浏览器，在地址中输入自己的http://域名/ ，已经可以自动跳转到https下了，大功告成。
