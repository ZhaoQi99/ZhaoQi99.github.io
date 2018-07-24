---
title: 'C#中使用SmtpClient发送邮件'
categories: 'C#'
tags:
  - 'C#'
  - .NET
date: '2018-06-19 02:41:13'
abbrlink: 3123403799
---
最近写C#课程设计时需要用C#来发送邮件，但是网上搜的代码经过测试均不能使用，调试了很久也没能成功。最后索性自己对着官方文档撸了一个，期间踩了很多坑，故在此做一总结。

## 准备工作
* 命名空间导入:`using System.Net.Mail;`
* 在邮箱设置中开通smtp服务，并获取授权码。

## 源代码
```csharp
string mailfrom, password, fromwho, host, mailto, subject, body;
mailfrom = "xxx@qq.com";//发件人
int port = 25;//端口号一般为25
password = "**********";//邮箱密码
host = "smtp.xxx.com";//主机地址
fromwho = "xxx";//发件人的签名
mailto = "xxx@qq.com";//收件人(多个收件人之间以英文逗号间隔)
subject = "test";//邮件主题
body = "xxxxx";//邮件正文

SmtpClient smtp;
smtp = new SmtpClient(host, port);
smtp.UseDefaultCredentials = false;
smtp.EnableSsl = true;//是否使用SSL加密连接
smtp.DeliveryMethod = SmtpDeliveryMethod.Network;//指定邮件发送方式
smtp.Credentials = new System.Net.NetworkCredential(mailfrom, password); //设置用于验证发件人身份的凭证

string[] address = mailto.Split(',');//收件人地址列表
MailMessage msg = new MailMessage();//邮件信息
msg.From = new MailAddress(mailfrom, fromwho, Encoding.UTF8);
msg.Subject = subject;//邮件标题
msg.SubjectEncoding = Encoding.UTF8;
msg.Body = body;//邮件正文
msg.BodyEncoding = Encoding.UTF8;
for (int i = 0; i < address.Length; i++)
    msg.To.Add(address[i]);

msg.Priority = MailPriority.Normal;//邮件优先级(High,Low,Normal)
try
{
    smtp.Send(msg);
	Console.WriteLine("发送成功!");
}
catch (Exception e)
{
    Console.WriteLine(e.Message);
}
msg.Dispose();
```

## 注意
* 代码中所使用的密码不是邮箱密码，应在邮箱设置中获取smtp服务授权码。
* 使用163邮箱时只能使用25端口(465/994不可用),EnableSsl属性设置为false/true
* 使用QQ邮箱发送时只能使用25端口(465/587不可用),且EnableSsl属性必须设置为true
* 代码使用QQ邮箱、163邮箱实测有效，其他邮箱尚不清楚

## 总结
无论是QQ邮箱还是163邮箱，使用SSL端口发送时均出现异常：操作超时，查了好久，发现是因为:System.Net.Mail只支持显式SSL(Explicit SSL)，但是不支持隐式SSL(Implicit SSL)，QQ邮箱使用的应该是Implicit SSL。此问题似乎可以用`System.Web.Mail`或`Cdosys.dll`解决，但是还没有试过。
关于QQ邮箱使用25端口发送时，必须使用设置SSL为true的原因:服务器从不受保护的25端口响应请求，然后将连接抛到受保护的465端口.
**显式SSL**通过25端口连接 - > StartTLS（开始加密）- >验证 - >发送数据
**隐式SSL**StartSSL（开始加密） - > 连接 - > 验证 - >发送数据
## 参考博客
[C#发送邮件三种方法，Localhost，SMTP，SSL-SMTP](https://blog.csdn.net/andrewniu/article/details/52594318)
[System.Net.Mail with SSL to authenticate against port 465](https://blogs.msdn.microsoft.com/webdav_101/2008/06/02/system-net-mail-with-ssl-to-authenticate-against-port-465/)
[You cannot use System.Net.Mail.SmtpClient to send an e-mail message with Implicit SSL](https://support.microsoft.com/en-us/help/950260/you-cannot-use-system-net-mail-smtpclient-to-send-an-e-mail-message-wi)