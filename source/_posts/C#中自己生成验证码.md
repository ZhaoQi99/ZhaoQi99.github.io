---
title: 'C#中自己生成验证码'
categories: 'C#'
tags:
  - 'C#'
  - .NET
date: '2018-06-19 02:41:13'
abbrlink: 1000607951
---
## 前言
最近写C#课程设计时，登录验证处需用到验证码，于是参照网上博客，自己封装了一个验证码类，和网上其他博客相比，有以下优点:
* 去除了0,o,O与1,l等容易混淆的字符
* 使用方便，仅需三行代码
* 内置有返回MD5加密后的字符串的方法，便于前端调用
<!--more-->

## 函数说明
### 公有方法
* SecurityCode(int length);//构造函数
* SecurityCode(int length, int width, int height);//构造函数
* void UpdateVerifyCode();//刷新验证码
* Bitmap getImage();//返回验证码图片
* string MD5Encrypt();//返回经MD5加密过的验证码字符串
* bool Check(string text);//返回校验结果(不区分大小写)

### 私有方法
* void CreateVerificationText(int length);//随机生成验证码字符串
* void CreateImage();//生成验证码图片
* Color RandColor();//生成随机颜色
* Point RandPoint();//生成随机点

## 使用示例
```csharp
SecurityCode Code=new SecurityCode(4);
code.UpdateVerifyCode();
picturebox.Image=code.getImage();
```
## 效果图
![验证码](/images/securitycode.jpg)

## 源代码
```csharp
class SecurityCode
{
        private Random rand = new Random();//生成随机数
        private string VerificationText = string.Empty;//验证码字符串
        private Bitmap map;//验证码的位图
        private int length;//验证码的字符个数
        private int width;//验证码图片的宽度
        private int height;//验证码图片的高度

        public SecurityCode(int length, int width, int height)
        {
            this.length = length;
            this.width = width;
            this.height = height;
        }

        public SecurityCode(int length)
        {
            this.length = length;
            this.width = (length + 1) * 25;
            this.height = 40;
        }

        //随机生成验证码字符串
        private void CreateVerificationText(int length)
        {
            VerificationText = string.Empty;
            string dictionary = "ABCDEFGHIJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";//去除O,o,0 ,l,1
            for (int i = 0; i < length; i++)
            {
                int index = rand.Next(0, dictionary.Length);
                VerificationText += dictionary[index].ToString();
            }
        }

        //刷新验证码
        public void UpdateVerifyCode()
        {
            CreateVerificationText(length);
            CreateImage();
            //Console.WriteLine(MD5Encrypt(VerificationText));//Only for test
        }
        //生成验证码图片
        private void CreateImage()
        {
            map = new Bitmap(width, height);
            Graphics g = Graphics.FromImage(map);
            Pen pen = new Pen(Color.Black);
            string[] font = { "Verdana", "Microsoft Sans Serif", "Consolas", "Arial", "宋体" };
            Font f = new Font("Arial", 20, FontStyle.Bold);
            g.Clear(Color.White);
            SolidBrush brush = new SolidBrush(Color.White);

            //绘制干扰线条
            pen.Width = 0.1F;
            for (int i = 0; i < 15; i++)
            {
                pen.Color = RandColor();
                g.DrawLine(pen, RandPoint(), RandPoint());
            }
            //绘制干扰点
            for (int i = 0; i < 80; i++)
            {
                Point p = RandPoint();
                map.SetPixel(p.X, p.Y, RandColor());
            }
            //绘制字符串
            SizeF  StringSizeF = g.MeasureString(VerificationText, f);
            PointF StartPoint = new Point(0, (height - (int)StringSizeF.Height) / 2);
            for (int i = 0; i < length; i++)
            {
                brush.Color = RandColor();
                int index = rand.Next(5);
                f = new Font(font[index], 20, FontStyle.Bold);
                StartPoint.X += 5;
                g.DrawString(VerificationText[i].ToString(), f, brush, StartPoint);
                SizeF CharSizeF = g.MeasureString(VerificationText[i].ToString(), f);
                StartPoint.X += CharSizeF.Width;
            }
            g.Dispose();

        }
        //生成随机颜色
        private Color RandColor()
        {
            Color c = Color.FromArgb(rand.Next(1, 256), rand.Next(1, 255), rand.Next(1, 255));
            return c;
        }
        //生成随机点
        private Point RandPoint()
        {
            int x = rand.Next(0, map.Width);
            int y = rand.Next(0, map.Height);
            return new Point(x, y);
        }
        //返回验证码图片
        public Bitmap getImage()
        {
            return map;
        }
        //返回经MD5加密过的验证码字符串
        public string MD5Encrypt()
        {
            return Tool.MD5Encrypt(VerificationText);
        }
        //返回校验结果
        public bool Check(string text)
        {
            return text.ToUpper().Equals(VerificationText.ToUpper());//不区分大小写
        }
}
```