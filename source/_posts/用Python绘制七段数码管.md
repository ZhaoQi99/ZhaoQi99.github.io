---
title: 用Python绘制七段数码管
date: 2017-12-05 20:19:25
categories: Python
tags:
     - Python
---
## 题目：
数码管是一种价格便宜、使用简单的发光电子器件，广泛应用在价格较低的电子类产品中，其中，七段数码管最为常用。七段数码管
（seven-segment indicator）由7 段数码管拼接而成，每段有亮或不亮两种情况，改进型的七段数码管还包括一个小数点位置，如图1 所示。
![](/images/20171205201558358.jpg)

　　　　　　　　　　　　　　　　　　　　　　　　　　图 1：七段数码管的结构图
七段数码管能形成27=128 种不同状态，其中部分状态能够显示易于人们理解的数字或字母含义，因此被广泛使用。图2 给出了十六进制中16 个字符的七段数码管表示。
![](/images/20171205201607868.jpg)
　　　　　　　　　　　　　　　　　　　　　　　　　　图 2：十六进制中16 个字符的七段数码管表示
请采用turtle 库并使用函数封装绘制七段数码管，显示当前系统日期和时间。该问题的IPO 描述如下：输入：当前日期的数字形式处理：根据每个数字绘制七段数码管表示输出：绘制当前日期的七段数码管表示程序的预期运行效果如图3 和图4 所示，与两个效果中任何一个相似均可。
![](/images/20171205201613806.jpg)
![](/images/20171205201625796.jpg)
## 源码：
```Python
'''
Created on Dec 5, 2017

@author: QiZhao
'''
import turtle,datetime  

def drawGap():#画数码管间隔
    turtle.penup()
    turtle.fd(5)
    
def drawline(flag):#画单条数码管
    drawGap()
    turtle.pendown()
    if(flag==False):
        turtle.penup()
    turtle.fd(40)
    drawGap()
    turtle.right(90)
    
def drawdight(dight):#根据数字绘制对应数字的数码管
    if dight in [2,3,4,5,6,8,9]:
        drawline(True)
    else:
        drawline(False)
    if dight in [0,1,3,4,5,6,7,8,9]:
        drawline(True)
    else:
        drawline(False)
    if dight in [0,2,3,5,6,8]:
        drawline(True)
    else:
        drawline(False)
    if dight in [0,2,6,8]:
        drawline(True)
    else:
        drawline(False)
    turtle.left(90)
    if dight in [0,4,5,6,8,9]:
        drawline(True)
    else:
        drawline(False)
    if dight in [0,2,3,5,6,7,8,9]:
        drawline(True)
    else:
        drawline(False)
    if dight in [0,1,2,3,4,7,8,9]:
        drawline(True)
    else:
        drawline(False)
    turtle.setheading(0)
    turtle.fd(25)

def drawdata(data):#根据日期画出对应数字
    turtle.color("red")
    for i in data:
        if i=='+':
            turtle.write('年',font=("宋体", 24, "normal"))
            turtle.color("green")
            turtle.fd(30)
        elif i=='-':
            turtle.write('月',font=("宋体", 24, "normal"))
            turtle.color("blue")
            turtle.fd(30)
        elif i=='*':
            turtle.write('日',font=("宋体", 24, "normal"))
        else:
            drawdight(eval(i))
            
def main():
    turtle.setup(800,500)
    turtle.penup()
    turtle.fd(-350)
    turtle.pendown()
    turtle.hideturtle()
    turtle.pensize(6)
    turtle.speed(9)
    drawdata(datetime.datetime.now().strftime('%Y+%m-%d*'))
    a=input()
main()
```
## 效果图
![](/images/20171205202005054.jpg)