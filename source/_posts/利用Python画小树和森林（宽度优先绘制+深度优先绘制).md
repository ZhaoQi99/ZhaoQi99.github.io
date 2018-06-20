---
title: 利用Python画小树和森林（宽度优先绘制+深度优先绘制)
categories: Python
tags:
  - Python
abbrlink: 15900
date: 2017-12-02 20:57:17
---
在中M上看嵩天老师的[《Python语言程序设计》](http://www.icourse163.org/learn/BIT-268001)时,视频中给出了宽度优先绘制法的代码,仅提了一下还有另外一种画法(深度优先绘制法).联系到最近学的数据结构，摸索出了另一种画法。

## 源码：
```Python
'''
Created on Dec 2, 2017

@author: QiZhao
'''
# drawtree.py
 
from turtle import Turtle
 
def tree(plist, l, a, f):
    #宽度优先绘制法
    """ plist is list of pens
    l is length of branch
    a is half of the angle between 2 branches
    f is factor by which branch is shortened
    from level to level."""
    if l > 5:
        lst = []
        for p in plist:
            p.forward(l)#Move the turtle forward by the specified distance, in the direction the turtle is headed.
            q = p.clone()#Create and return a clone of the turtle with same position, heading and turtle properties.
            p.left(a) #Turn turtle left by angle units
            q.right(a)# turn turtle right by angle units, nits are by default degrees, but can be set via the degrees() and radians() functions.
            lst.append(p)
            lst.append(q)
        tree(lst, l*f, a, f)
        
def tree2(p,l,a,f):
    #深度优先绘制法
    if l>5:
        p.forward(l)
        q=p.clone()
        p.left(a)
        q.right(a)
        tree2(p, l*f, a, f)
        tree2(q, l*f, a, f)

def maketree(x,y):     
    p = Turtle()
    p.color("blue")
    p.pensize(5)
    p.setundobuffer(None)
    p.hideturtle() 
    #Make the turtle invisible. It’s a good idea to do this while you’re in the middle of doing some complex drawing,
    #because hiding the turtle speeds up the drawing observably.
    #p.speed(9)
    p.getscreen().tracer(1,0)#Return the TurtleScreen object the turtle is drawing on.
    #TurtleScreen methods can then be called for that object.
    p.left(90)# Turn turtle left by angle units. direction
 
    p.penup() #Pull the pen up – no drawing when moving.
    p.goto(x,y)#Move turtle to an absolute position. If the pen is down, draw line. Do not change the turtle’s orientation.
    p.pendown()# Pull the pen down – drawing when moving. 
    #这三条语句是一个组合相当于先把笔收起来再移动到指定位置，再把笔放下开始画.否则turtle一移动就会自动的把线画出来
 
    tree([p], 100, 65, 0.6375)
    
    p.penup() 
    p.setheading(90)#Set the orientation of the turtle to to_angle.
    p.goto(x,y)
    p.down()
    p.color("green")
    
    tree2(p, 100, 65, 0.6375) 
    
def main():
    maketree(-200, -200)
    maketree(0, 0)
    maketree(200,-200)
    
main()
```
## 效果图
![](/images/20171202204712994.jpg)