---
title: '使用c#中的HttpWebRequest实现12306余票查询'
categories: 'C#'
tags:
  - 'C#'
  - .NET
date: '2018-06-19 02:41:13'
abbrlink: 1797370495
---
## 准备工作
1. 下载用于解析JSON的类库(Newtonsoft.Json.dll)(下载地址:[Newtonsoft.Json.dll](https://archive.codeplex.com/?p=json))；
2. 在C#项目中添加对其的引用。
3. 在程序中导入命名空间:
```csharp
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Xml;
```
<!--more-->
## 思路
### API地址
在浏览器中打开12306主页，点击**余票查询**，并使用浏览器中的开发者工具，进行抓包。这里，我们查询的是2018.06.25的上海至长沙的车票信息。
![开发者工具抓包](/images/trainticket1.jpg)
此时浏览器发送请求的地址为：
`
https://kyfw.12306.cn/otn/leftTicket/query?leftTicketDTO.train_date=2018-06-25&leftTicketDTO.from_station=SHH&leftTicketDTO.to_station=CSQ&purpose_codes=ADULT
`
由此,我们不难分析出API地址为：
```csharp
string url="https://kyfw.12306.cn/otn/leftTicket/query?leftTicketDTO.train_date={0}&leftTicketDTO.from_station={1}&leftTicketDTO.to_station={2}&purpose_codes={3}";
url=string.Format(url,date,from,to,id);
```
其中，date代表出发日(格式为yyyy-MM-dd),from代表出发站的代码，to代表到达站的代码，id代表车票类型(成人为`ADULT`,学生为`OX00`);
### 车站代码
车站对应的代码可在此下载:[https://kyfw.12306.cn/otn/resources/js/framework/station_name.js?station_version=1.9055](https://kyfw.12306.cn/otn/resources/js/framework/station_name.js?station_version=1.9055)
我们可以使用正则表达式从中提取出关键信息，并保存在一个XML文档中，便于以后的使用。
```csharp
        public static void StationNameXml()
        {
            string nowpath = Environment.CurrentDirectory;
            if (Directory.Exists(nowpath+"/Data")==false)
                Directory.CreateDirectory(nowpath + "/Data");//创建新路径
            if (File.Exists(nowpath + "/Data/StationName.xml") == true)
                return;

			HttpWebRequest request;
     		HttpWebResponse response;

            string url=@"https://kyfw.12306.cn/otn/resources/js/framework/station_name.js?station_version=1.9055";

            request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "GET";
            request.Credentials = CredentialCache.DefaultCredentials;
            request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36";

            string str = string.Empty;
            try
            {
                response = (HttpWebResponse)request.GetResponse();
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    StreamReader sr = new StreamReader(response.GetResponseStream(), Encoding.GetEncoding("UTF-8"));
                    str = sr.ReadToEnd();
                    sr.Close();
                    response.Close();//关闭response响应流
                }
                else
                    throw new Exception();
            }
            catch(Exception e)
            {
				Console.WriteLine(e.Message);
            }

            string pattern = @"@\S{2,5}?[|](?<Name>\S{1,8}?)[|](?<Code>\S{3,5}?)[|]";
            Regex r = new Regex(pattern, RegexOptions.ExplicitCapture);

            XmlDocument xmldoc = new XmlDocument();
            XmlDeclaration xmldecl;

            xmldecl = xmldoc.CreateXmlDeclaration("1.0", "UTF-8", null);//加入XML的声明段落
            xmldoc.AppendChild(xmldecl);

            XmlElement root = xmldoc.CreateElement("", "Dict", "");//加入一个根元素
            xmldoc.AppendChild(root);

            MatchCollection mc = r.Matches(str);
            foreach (Match m in mc)
            {
                GroupCollection group = m.Groups;
                XmlNode node = xmldoc.CreateNode(XmlNodeType.Element, "Pair", null);

                XmlNode temp = xmldoc.CreateNode(XmlNodeType.Element, "Station", null);
                temp.InnerText = group["Name"].Value; 
                node.AppendChild(temp);

                XmlNode temp2 = xmldoc.CreateNode(XmlNodeType.Element, "Code", null);
                temp2.InnerText = group["Code"].Value;
                node.AppendChild(temp2);

                root.AppendChild(node);
            }
            xmldoc.Save(nowpath+"/Data/"+"StationName.xml");
        }
```
![车站代码](/images/trainticket2.jpg)
依据中文车站名获取对应车站代码的方法为:
```csharp
        private static string StationCode(string StationName)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(Environment.CurrentDirectory + "/Data/StationName.xml");
            XmlNodeList data = doc.DocumentElement.ChildNodes;
            foreach (XmlNode node in data)
            {
                XmlElement xe = (XmlElement)node;
                XmlNodeList xnl0 = xe.ChildNodes;
                string s = xnl0.Item(0).InnerText;
                if(s==StationName)
                {
                    return xnl0.Item(1).InnerText;
                }
            }
            return string.Empty;
        }
```
### 数据模型
为了存储查询结果，我们需要构建一个车票的数据模型，具体如下；
```csharp
   public class Ticket
    {
        #region 数据模型
        private string trainid=string.Empty;//车次
        private string fromstation = "--";//出发站
        private string totation = "--";//到达站
        private string ticketdate = string.Empty;//车票日期
        private string starttime = "--";//发车时间
        private string arrivetime = "--";//到达时间
        private string lastedtime = "--";//历时
        private string tzNum = "--";//特等座
        private string ydNum = "--";//一等座
        private string edNum = "--";//二等座
        private string grwNum = "--";//高级软卧
        private string rwNum = "--";//软卧
        private string dwNum = "--";//动卧
        private string ywNum = "--";//硬卧
        private string rzNum = "--";//软座
        private string yzNum = "--";//硬座
        private string wzNum = "--";//无座
        private string qtNum = "--";//其他
        private string identity = string.Empty;//车票类型(学生/成人)
        public string TrainId { get { return trainid; } set { trainid = value; } }
        public string FromStation { get { return fromstation; } set { fromstation = value; } }
        public string ToStation { get { return totation; } set { totation = value; } }
        public string TicketDate { get { return ticketdate; } set { ticketdate = value; } }
        public string StartTime { get { return starttime; } set { starttime = value; } }
        public string ArriveTime { get { return arrivetime; }set { arrivetime = value; } }
        public string LastedTime { get { return lastedtime; } set { lastedtime = value; } }
        public string TzNum { get { return tzNum; } set { tzNum = value; } }
        public string YdNum { get { return ydNum; } set { ydNum = value; } }
        public string EdNum { get { return edNum; } set { edNum = value; } }
        public string GrwNum { get { return grwNum; } set { grwNum = value; } }
        public string RwNum { get { return rwNum; } set { rwNum = value; } }
        public string DwNum { get { return dwNum; } set { dwNum = value; } }
        public string YwNum {get{ return ywNum; }set{ ywNum = value; } }
        public string RzNum {get{ return rzNum; }set{ rzNum = value; } }
        public string YzNum {get{ return yzNum; }set{ yzNum = value; } }
        public string WzNum {get{ return wzNum; }set{ wzNum = value; } }
        public string QtNum {get{ return qtNum; }set{ qtNum = value; } }
        public string Identity { get { return identity; }set { identity = value; } }
        #endregion
        public Ticket() { }

        public Dictionary<string, string> getMap()
        {
            Dictionary<string, string> result = new Dictionary<string, string>();
            result.Add("车次", trainid);
            result.Add("出发站", FromStation);
            result.Add("到达站", ToStation);
            result.Add("发车时间", StartTime);
            result.Add("到达时间", ArriveTime);
            result.Add("历时", LastedTime);
            result.Add("特等座", TzNum);
            result.Add("一等座", YdNum);
            result.Add("二等座", EdNum);
            result.Add("高级软卧", GrwNum);
            result.Add("软卧", RwNum);
            result.Add("动卧", DwNum);
            result.Add("硬卧", YwNum);
            result.Add("软座", RzNum);
            result.Add("硬座", YzNum);
            result.Add("无座", WzNum);
            result.Add("其他", QtNum);
            return result;
        }
	}
```
### 解析JSON
![JSON格式的字符串](/images/trainticket3.jpg)
返回的报文为一个JSON格式的字符串，里面包含有各类车票信息、发车时间以及历时，为了对其进行解析，我们需要下载一个用于解析JSON的类库(下载地址:[Newtonsoft.Json.dll](https://archive.codeplex.com/?p=json))
```csharp
       private static Ticket[] SpiderTicket(string date, string from, string to, string id)
        {
            HttpWebRequest request;
            HttpWebResponse response;

            string url = "https://kyfw.12306.cn/otn/leftTicket/query?leftTicketDTO.train_date={0}&leftTicketDTO.from_station={1}&leftTicketDTO.to_station={2}&purpose_codes={3}";
            url = string.Format(url, date, from, to, id);

            request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "GET";
            request.Credentials = CredentialCache.DefaultCredentials;
            request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36";

            string str = string.Empty;
            try
            {
                response = (HttpWebResponse)request.GetResponse();
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    StreamReader sr = new StreamReader(response.GetResponseStream(), Encoding.GetEncoding("UTF-8"));
                    str = sr.ReadToEnd();
                    sr.Close();
                    response.Close();//关闭response响应流
                }
                else
                    throw new Exception();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            Dictionary<string, string> map=new Dictionary<string, string>();//保存返回的JSON串中的车站代码与车站名之间的映
            ArrayList AllTicket = new ArrayList();//所有的车票信息

            JObject jo = (JObject)JsonConvert.DeserializeObject(str);
            JToken record = jo["data"]["map"];
            foreach (JProperty item in record)
            {
                map.Add(item.Name.ToString(), item.Value.ToString());
            }

            record = jo["data"]["result"];
            foreach (string s in record)
            {
                string[] result = s.Split('|');
                Ticket t = new Ticket();
                t.TrainId = result[3];
                t.FromStation = map[result[6]];
                t.ToStation = map[result[7]];
                t.StartTime = result[8];
                t.ArriveTime = result[9];
                t.LastedTime = result[10];
                t.TicketDate = result[13];
                t.DwNum = result[33] != "" ? result[33] : t.DwNum;
                t.TzNum = result[32] != "" ? result[32] : t.TzNum;
                t.YdNum = result[31] != "" ? result[31] : t.YdNum;
                t.EdNum = result[30] != "" ? result[30] : t.EdNum;
                t.YzNum = result[29] != "" ? result[29] : t.YzNum;
                t.YwNum = result[28] != "" ? result[28] : t.YwNum;
                t.WzNum = result[26] != "" ? result[26] : t.WzNum;
                t.RzNum = result[24] != "" ? result[24] : t.RzNum;
                t.RwNum = result[23] != "" ? result[23] : t.RwNum;
                t.GrwNum = result[21] != "" ? result[21] : t.GrwNum;
                AllTicket.Add(t);
            }
            Ticket[] All = new Ticket[AllTicket.Count];
            int flag = 0;
            foreach (object t in AllTicket)
            {
                All[flag++] = t as Ticket;
            }
            return All;
        }
```
## 效果图
![](/images/spiderticket.jpg)
![](/images/spiderticket2.jpg)
项目地址:[EasyLife](https://github.com/ZhaoQi99/EasyLife/tree/Course_Design/)

## 参考博客
[C#调用12306API做余票查询](https://blog.csdn.net/xiahn1a/article/details/42584507)(该参考博客中的方法已不可用)

## 完整代码
```csharp
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

namespace Ticket
{
    class Program
    {
        public static void StationNameXml()
        {
            string nowpath = Environment.CurrentDirectory;
            if (Directory.Exists(nowpath + "/Data") == false)
                Directory.CreateDirectory(nowpath + "/Data");//创建新路径
            if (File.Exists(nowpath + "/Data/StationName.xml") == true)
                return;

            HttpWebRequest request;
            HttpWebResponse response;

            string url = @"https://kyfw.12306.cn/otn/resources/js/framework/station_name.js?station_version=1.9055";

            request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "GET";
            request.Credentials = CredentialCache.DefaultCredentials;
            request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36";

            string str = string.Empty;
            try
            {
                response = (HttpWebResponse)request.GetResponse();
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    StreamReader sr = new StreamReader(response.GetResponseStream(), Encoding.GetEncoding("UTF-8"));
                    str = sr.ReadToEnd();
                    sr.Close();
                    response.Close();//关闭response响应流
                }
                else
                    throw new Exception();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            string pattern = @"@\S{2,5}?[|](?<Name>\S{1,8}?)[|](?<Code>\S{3,5}?)[|]";
            Regex r = new Regex(pattern, RegexOptions.ExplicitCapture);

            XmlDocument xmldoc = new XmlDocument();
            XmlDeclaration xmldecl;

            xmldecl = xmldoc.CreateXmlDeclaration("1.0", "UTF-8", null);//加入XML的声明段落
            xmldoc.AppendChild(xmldecl);

            XmlElement root = xmldoc.CreateElement("", "Dict", "");//加入一个根元素
            xmldoc.AppendChild(root);

            MatchCollection mc = r.Matches(str);
            foreach (Match m in mc)
            {
                GroupCollection group = m.Groups;
                XmlNode node = xmldoc.CreateNode(XmlNodeType.Element, "Pair", null);

                XmlNode temp = xmldoc.CreateNode(XmlNodeType.Element, "Station", null);
                temp.InnerText = group["Name"].Value;
                node.AppendChild(temp);

                XmlNode temp2 = xmldoc.CreateNode(XmlNodeType.Element, "Code", null);
                temp2.InnerText = group["Code"].Value;
                node.AppendChild(temp2);

                root.AppendChild(node);
            }
            xmldoc.Save(nowpath + "/Data/" + "StationName.xml");
        }
        private static string StationCode(string StationName)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(Environment.CurrentDirectory + "/Data/StationName.xml");
            XmlNodeList data = doc.DocumentElement.ChildNodes;
            foreach (XmlNode node in data)
            {
                XmlElement xe = (XmlElement)node;
                XmlNodeList xnl0 = xe.ChildNodes;
                string s = xnl0.Item(0).InnerText;
                if (s == StationName)
                {
                    return xnl0.Item(1).InnerText;
                }
            }
            return string.Empty;
        }


       private static Ticket[] SpiderTicket(string date, string from, string to, string id)
        {
            HttpWebRequest request;
            HttpWebResponse response;

            string url = "https://kyfw.12306.cn/otn/leftTicket/query?leftTicketDTO.train_date={0}&leftTicketDTO.from_station={1}&leftTicketDTO.to_station={2}&purpose_codes={3}";
            url = string.Format(url, date, from, to, id);

            request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "GET";
            request.Credentials = CredentialCache.DefaultCredentials;
            request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36";

            string str = string.Empty;
            try
            {
                response = (HttpWebResponse)request.GetResponse();
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    StreamReader sr = new StreamReader(response.GetResponseStream(), Encoding.GetEncoding("UTF-8"));
                    str = sr.ReadToEnd();
                    sr.Close();
                    response.Close();//关闭response响应流
                }
                else
                    throw new Exception();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            Dictionary<string, string> map=new Dictionary<string, string>();//保存返回的JSON串中的车站代码与车站名之间的映
            ArrayList AllTicket = new ArrayList();//所有的车票信息

            JObject jo = (JObject)JsonConvert.DeserializeObject(str);
            JToken record = jo["data"]["map"];
            foreach (JProperty item in record)
            {
                map.Add(item.Name.ToString(), item.Value.ToString());
            }

            record = jo["data"]["result"];
            foreach (string s in record)
            {
                string[] result = s.Split('|');
                Ticket t = new Ticket();
                t.TrainId = result[3];
                t.FromStation = map[result[6]];
                t.ToStation = map[result[7]];
                t.StartTime = result[8];
                t.ArriveTime = result[9];
                t.LastedTime = result[10];
                t.TicketDate = result[13];
                t.DwNum = result[33] != "" ? result[33] : t.DwNum;
                t.TzNum = result[32] != "" ? result[32] : t.TzNum;
                t.YdNum = result[31] != "" ? result[31] : t.YdNum;
                t.EdNum = result[30] != "" ? result[30] : t.EdNum;
                t.YzNum = result[29] != "" ? result[29] : t.YzNum;
                t.YwNum = result[28] != "" ? result[28] : t.YwNum;
                t.WzNum = result[26] != "" ? result[26] : t.WzNum;
                t.RzNum = result[24] != "" ? result[24] : t.RzNum;
                t.RwNum = result[23] != "" ? result[23] : t.RwNum;
                t.GrwNum = result[21] != "" ? result[21] : t.GrwNum;
                AllTicket.Add(t);
            }
            Ticket[] All = new Ticket[AllTicket.Count];
            int flag = 0;
            foreach (object t in AllTicket)
            {
                All[flag++] = t as Ticket;
            }
            return All;
        }
        static void Main(string[] args)
        {
            StationNameXml();
            string from = "上海";
            string to = "北京";
            Ticket[] All=new Ticket[50];
            All=SpiderTicket(DateTime.Now.ToString("yyyy-MM-dd"), StationCode(from), StationCode(to), "ADULT");
            for(int i=0;i<All.Length;i++)
            {
                Dictionary<string, string> map = new Dictionary<string, string>();
                map = All[i].getMap();
                foreach (object j in map.Keys)
                    Console.Write(j.ToString()+":"+map[j.ToString()].ToString()+" ");
                Console.WriteLine();
            }
            Console.Read();
        }
    }
}
```