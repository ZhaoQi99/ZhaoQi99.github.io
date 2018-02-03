---
title: 第四周编程题_实现一个表达MP3的媒体类型
date: 2017-08-23 00:22:19
categories: 面向对象程序设计_Java语言_翁恺
tags:
     - Java
---
## 题目：
本周我们介绍了以继承方式实现的媒体资料库，在课程代码实现的基础上，请实现一个表达MP3的媒体类型，能和CD、DVD一样存放进这个Database。请提交这个MP3类的代码。如果你认为为了能存放MP3，需要修改Item和Database，也请一并提交Item和Database的代码。
## 代码：
```Java
package 面向对象程序设计_Java语言_翁恺;

import java.util.ArrayList;

class Item
{
	private String title;
	private int playTime;
	private boolean gotIt = false;
	private String comment;

	public Item(String title, int playTime, boolean gotIt, String comment)
	{
		this.title = title;
		this.playTime = playTime;
		this.gotIt = gotIt;
		this.comment = comment;
	}
	
	public void print()
	{
		System.out.print("title:"+title+";"+"playTime:"+playTime+";"+"gotIt:"+gotIt+";"+"comment:"+comment+";");
	}
}

class Mp3 extends Item
{
	private String artist;
	private int numofTracks;
	
	public Mp3(String title, int playTime, boolean gotIt, String comment,String artist,int numofTracks)
	{
		super(title, playTime, gotIt, comment);
		this.artist=artist;
		this.numofTracks=numofTracks;
	}

	@Override
	public void print()
	{
		System.out.print("Mp3:{");
		super.print();
		System.out.println("artist:"+artist+";"+"numofTracks:"+numofTracks+"}");
	}
	
}

public class Database
{
	private ArrayList<Item> list=new ArrayList<Item>();
	
	public void add(Item item)
	{
		list.add(item);
	}
	
	public void list()
	{
		for(Item item:list)
			item.print();
	}
	
	public static void main(String[] args)
	{
		Database db=new Database();
		db.add(new Mp3("A", 60, true, "good", "John", 20));
		db.add(new Mp3("B", 80, true, "vrey good", "Tom", 10));
		db.list();
	}

}
```
## 运行结果：
![](/images/20170823002504047.jpg)