title: 人生苦短，我用Python
categories:
  - Python
tags:
  - Python
  - lambda
abbrlink: 2604890615
date: 2019-03-19 22:01:00
---
# 前言
前几日代写留学生作业时遇到了两道很有意思的Python编程题，在此做一记录，主要涉及到一些Python的高级特性:生成器、lambda表达式。
<!--more-->

# Question 1
## 题意
**原文:**
Consider the following function
{% codeblock lang:python %}
# listOfNumbers is a list of only numbers
#
def processList(listOfNumbers):
    result = []
    for i in listOfNumbers:
        if i<0 == 0:
            result.append(i*i)
        else:
            result.append((i*i)+1)
    return result
{% endcodeblock %}

First, study and test processList(listOfNumbers) to determine what it does Then rewrite its body so that it accomplishes the same task with a one-line list comprehension. Thus, the resulting function will have exactly two lines, the def line and a return line containing a list comprehension expression. 
**翻译:**
将给出的一个函数变成两行

## 分析
函数的功能是:遍历listofNumbers中的每一个元素，如果大于等于0，将其变成自己乘以自己，否则变为自己乘自己后再加一。
因此，我们可以用到Python中的三元表达式，下面这两种方式是等价的。
`value = true if condition else false`
与
{% codeblock lang:python %}
if condition:
    value = true
else:
    value = false
{% endcodeblock %}

## 参考答案
{% codeblock lang:python %}
def processList(listOfNumbers):
    return [i * i if i >= 0 else i * i + 1 for i in listOfNumbers]
{% endcodeblock %}

# Question 2
## 题意
**原文:**
Implement function processList2(inputList, specialItem, ignoreItems) that returns a new list that contains all the items of inputList (and in the original order) except 1) any that appear in the list ignoreItems, and 2) occurrences of specialItem (if specialItem is not in ignoreItems) should become the string "special" in the new list. Use a one-line list cluoomprehension to construct the new list. Thus, again, the function will have exactly two lines, the def line and a return line containing a list comprehension expression. For example,
{% note default no-icon %}
processList2([1,2,3,4], 4, [3])
[1, 2, 'special']
processList2([1,2,3,4,True,'dog'], 4, [3,5,4])
[1, 2, True, 'dog']
processList2([1,1,2,2], 1, [2])
['special', 'special']
{% endnote %}
**翻译:**
实现函数processList2(inputList, specialItem, ignoreItems)，对inputList中的元素进行处理，返回一个新列表，但需满足以下两个要求:
1. 不能是出现在ignoreItems中的元素
2. 对于与specialItem相同的元素(不能在ignoreItems中出现)，将其变成"special"。

## 分析
1. 首先将不在ignoreItems中的那些元素筛出来`[x for x in inputList if x not in ignoreItems]`或`list(filter(lambda x:False if x in ignoreItems else True,inputList))`。
2. 然后遍历上述列表中的元素，将specialItem变成"special",`["special" if x == specialItem else x for x in xxx]`

## 参考答案
{% codeblock lang:python %}
def processList2(inputList, specialItem, ignoreItems):
    ## two method
    return ["special" if x == specialItem else x for x in list(filter(lambda x:False if x in ignoreItems else True,inputList))]
    return["special" if x == specialItem else x for x in [x for x in inputList if x not in ignoreItems]]
{% endcodeblock %}

# 参考资料
* [filter() 函数](http://www.runoob.com/python3/python3-func-filter.html)
* [列表生成式](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001431779637539089fd627094a43a8a7c77e6102e3a811000)
