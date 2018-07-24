---
title: '用C#爬虫爬取校园最新通知'
categories: 'C#'
tags:
  - 'C#'
  - 爬虫
date: '2018-06-20 17:55:22'
abbrlink: 976598171
---
## 前言
前几个月用Python写了一个爬虫，用于爬取校园最新通知。最近的C#课程设计中想实现同样的功能，于是按照之前Python代码的思路重构了一下。
[用Python实现校园通知更新提醒](https://zhaoqi99.github.io/45013.html)

## 思路
使用C#中的HttpWebRequest库去获取目标url(各个网站的’更多通知’页)的源代码，然后使用` System.Text.RegularExpressions;`进行正则匹配。
正则表达式应包含三个分组:日期、标题、链接；

## 准备工作
* 命名空间导入
```csharp
using System.Net;
using System.Collections;
using System.Text.RegularExpressions;
```

## 源代码
Spider基类:
```csharp
    public class Spider
    {
        private string url = string.Empty;//要爬取的网页的url
        public HttpWebRequest request;
        public HttpWebResponse response;
        public string encode = "UTF-8";//目标url的网页编码格式
        public string Method = string.Empty;
        public string Url
        {
            get { return url; }
            set
            {
                url = value;
            }
        }
        public string Encode
        {
            get { return encode; }
            set
            {
                if (value == "UTF-8" || value == "GBK")
                {
                    encode = value;
                }
                else
                {
                    //Todo:handle exception
                }
            }
        }

        public Spider(string url,string method)
        {
            this.url = url;
            this.Method = method;
            Create();
        }
        public Spider() { }

        public void Create()
        {
            request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = Method;
            request.Credentials = CredentialCache.DefaultCredentials;
            request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36";
        }
        //获取目标url的Html代码
        public string getHtml()
        {
            string reader = string.Empty;
            try
            {
                Create();
                response = (HttpWebResponse)request.GetResponse();
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    StreamReader sr = new StreamReader(response.GetResponseStream(), Encoding.GetEncoding(encode));
                    reader = sr.ReadToEnd();
                    sr.Close();
                    response.Close();//关闭response响应流
                }
                else
                    throw new Exception();
            }
            catch(Exception e)
            {
                Log.Write( e.Message, "Exception");
                MessageBox.Show(e.Message, "错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return reader;
        }

    }
```
SpiderNotice类:
```csharp
    public class SpiderNotice : Spider
    {
        private string url_main;//各个通知链接的公共部分
        private string department;//所属部门
        private string type;//通知类型
        private string pattern;//用于匹配的正则表达式规则
        private ArrayList all_notice = new ArrayList();//所有的通知
        public string parse = string.Empty;//日期的解析规则
        public SpiderNotice(string url, string pattern, string url_main, string department, string type) : base(url, "GET")
        {
            this.department = department;
            this.pattern = pattern;
            this.url_main = url_main;
            this.type = type;
            this.parse = "yyyy-MM-dd";
        }
        public void Get()
        {
            all_notice.Clear();
            Regex r = new Regex(pattern, RegexOptions.ExplicitCapture);
            try
            {

                string s = getHtml();
                if (s == null)
                    throw new ArgumentNullException("html");
                MatchCollection mc = r.Matches(s);
                foreach (Match m in mc)
                {
                    GroupCollection group = m.Groups;
                    DateTime date = DateTime.ParseExact(group["date"].Value, parse, System.Globalization.CultureInfo.InstalledUICulture);
                    string link = url_main + group["link"].Value;
                    Notice n = new Notice();
                    n.Title = group["title"].Value;
                    n.Link = link;
                    n.Date = date;
                    n.Department = department;
                    n.Type = type;
                    all_notice.Add(n);
                }
            }
            catch (Exception e)
            {
                BLL.Log.Write(e.Message, "Exception");
                MessageBox.Show(e.Message, "错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        public Notice index(int index)
        {
            if (index >= all_notice.Count)
                throw new IndexOutOfRangeException();
            else
                return all_notice[index] as Notice;
        }
        public Notice[] GetAll()
        {
            Notice[] All = new Notice[all_notice.Count];
            int flag = 0;
            foreach (object t in all_notice)
            {
                All[flag++] = t as Notice;
            }
            return All;
        }
        public int Count()
        {
            return all_notice.Count;
        }
    }
```
数据模型Notice类:
```csharp
    public class Notice
    {
        #region 数据模型
        private string title=string.Empty;
        private string link=string.Empty;
        private DateTime date=DateTime.Now;
        private string type=string.Empty;
        private string department=string.Empty;
        public string Title
        {
            get
            {
                return title;
            }
            set
            {
                title = value;
            }
        }
        public DateTime Date
        {
            get
            {
                return date;
            }
            set
            {
                date = value;
            }
        }
        public string Link
        {
            set
            {
                link = value;
            }
            get
            {
                return link;
            }
        }
        public string Type
        {
            get
            {
                return type;
            }
            set
            {
                type = value;
            }
        }
        public string Department
        {
            get
            {
                return department;
            }
            set
            {
                department = value;
            }
        }
        #endregion
        override public string ToString()
        {
            return string.Format("标题:{0}\n时间:{1}\n链接:{2}\n", title, date.ToString("yyyy-MM-dd"), link);

        }
    }
```

## 问题总结
* 从不同网站上爬取到的日期格式可能不同，为统一格式，可以使用｀DateTime.ParseExact(datastr, parse, System.Globalization.CultureInfo.InstalledUICulture);｀去解析用于表示日期的字符串，然后再转为统一日期格式的字符串。其中，datastr为表示日期的字符串，parse为解析规则。例:
```csharp
string parse="yyyy-M-D";
DateTime t=DateTime.ParseExact("2016-9-5", parse, System.Globalization.CultureInfo.InstalledUICulture);
string str=t.toString("yyyy-MM-dd");//2016-09-05
```
* 不用网页的网页编码格式可能不同，有的为GBK,有的问UTF-8;
* 用字符串去表达正则表达式的规则时，有两种方法:
	1. string s=@"\d+""";字符串前加@表示字符串按常量解析(注意:双引号用两个双引号来表示)
	2. string s="\\d+\"";使用转义符