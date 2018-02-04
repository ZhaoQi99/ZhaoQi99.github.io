---
title: 第六周编程题_GPS数据处理
date: 2017-10-16 18:59:45
categories: 零基础学Java语言_翁恺
tags:
     - Java
---
## 题目内容：
NMEA-0183协议是为了在不同的GPS（全球定位系统）导航设备中建立统一的BTCM（海事无线电技术委员会）标准，由美国国家海洋电子协会（NMEA-The National Marine Electronics Associa-tion）制定的一套通讯协议。GPS接收机根据NMEA-0183协议的标准规范，将位置、速度等信息通过串口传送到PC机、PDA等设备。

NMEA-0183协议是GPS接收机应当遵守的标准协议，也是目前GPS接收机上使用最广泛的协议，大多数常见的GPS接收机、GPS数据处理软件、导航软件都遵守或者至少兼容这个协议。

NMEA-0183协议定义的语句非常多，但是常用的或者说兼容性最广的语句只有$GPGGA、$GPGSA、$GPGSV、$GPRMC、$GPVTG、$GPGLL等。

其中$GPRMC语句的格式如下：

$GPRMC,024813.640,A,3158.4608,N,11848.3737,E,10.05,324.27,150706,,,A*50

这里整条语句是一个文本行，行中以逗号“,”隔开各个字段，每个字段的大小（长度）不一，这里的示例只是一种可能，并不能认为字段的大小就如上述例句一样。

字段0：$GPRMC，语句ID，表明该语句为Recommended Minimum Specific GPS/TRANSIT Data（RMC）推荐最小定位信息
字段1：UTC时间，hhmmss.sss格式
字段2：状态，A=定位，V=未定位
字段3：纬度ddmm.mmmm，度分格式（前导位数不足则补0）
字段4：纬度N（北纬）或S（南纬）
字段5：经度dddmm.mmmm，度分格式（前导位数不足则补0）
字段6：经度E（东经）或W（西经）
字段7：速度，节，Knots
字段8：方位角，度
字段9：UTC日期，DDMMYY格式
字段10：磁偏角，（000 - 180）度（前导位数不足则补0）
字段11：磁偏角方向，E=东W=西
字段16：校验值

这里，“*”为校验和识别符，其后面的两位数为校验和，代表了“$”和“*”之间所有字符（不包括这两个字符）的异或值的十六进制值。上面这条例句的校验和是十六进制的50，也就是十进制的80。

提示：^运算符的作用是异或。将$和*之间所有的字符做^运算(第一个字符和第二个字符异或，结果再和第三个字符异或，依此类推)之后的值对65536取余后的结果，应该和*后面的两个十六进制数字的值相等，否则的话说明这条语句在传输中发生了错误。注意这个十六进制值中是会出现A-F的大写字母的。另外，如果你需要的话，可以用Integer.parseInt(s)从String变量s中得到其所表达的整数数字；而Integer.parseInt(s, 16)从String变量s中得到其所表达的十六进制数字

现在，你的程序要读入一系列GPS输出，其中包含$GPRMC，也包含其他语句。在数据的最后，有一行单独的
END
表示数据的结束。

你的程序要从中找出$GPRMC语句，计算校验和，找出其中校验正确，并且字段2表示已定位的语句，从中计算出时间，换算成北京时间。一次数据中会包含多条$GPRMC语句，以最后一条语句得到的北京时间作为结果输出。

你的程序一定会读到一条有效的$GPRMC语句。

## 输入格式:
多条GPS语句，每条均以回车换行结束。最后一行是END三个大写字母。

## 输出格式：
6位数时间，表达为：
hh:mm:ss
其中，hh是两位数的小时，不足两位时前面补0；mm是两位数的分钟，不足两位时前面补0；ss是两位数的秒，不足两位时前面补0。

## 输入样例：
{% note default  no-icon%}
$GPRMC,024813.640,A,3158.4608,N,11848.3737,E,10.05,324.27,150706,,,A*50
END
{% endnote %}

## 输出样例：
{% note default  no-icon%}
10:48:13
{% endnote %}

**时间限制：500ms内存限制：32000kb**

## 代码：
```
package 零基础学Java语言_翁恺;

import java.util.Scanner;

public class Sixth_Week_2
{

	public static void main(String[] args)
	{
		// TODO Auto-generated method stub
		final int mod = 65536;
		Scanner in = new Scanner(System.in);
		String s = null;
		int hh = 0, mm = 0, ss = 0;
		int cnt = 0;
		char state = 0;
		String utc = null;
		int judge = 0;
		int judge_temp = 0;
		String temp = null;
		while (true)
		{
			s = in.nextLine();
			cnt = 0;
			if (s.equals("END"))			// 读入结束
				break;
			temp = s.substring(0, 6);
			if (temp.equals("$GPRMC"))			// 判断是否为$GPRMC
			{
				utc = s.substring(7, 13);
				temp = null;
				for (int i = 0; i < s.length(); i++)				// 获取字段2（定位）
				{
					if (s.charAt(i) == ',')
						cnt++;
					if (cnt == 2)
					{
						state = s.charAt(i + 1);
						cnt = 0;
						break;
					}
				}
				if (state == 'A')				// 判断是否定位
				{
					for (int i = 0; i < s.length(); i++)					// 获取字段16(校验值）
					{
						if (s.charAt(i) == ',')
							cnt++;
						if (cnt == 12)
						{
							temp = s.substring(i + 3, s.length());
							judge = Integer.parseInt(temp, 16);
							temp = null;
							break;
						}
					}
					judge_temp = (int)s.charAt(1) ^ (int)s.charAt(2);// 计算校验值
					for (int i = 3; s.charAt(i) != '*'; i++)
					{
						if (s.charAt(i) == ',')
							continue;
						else
							judge_temp = judge_temp ^ (int)s.charAt(i)%mod;
					}
					if (judge == judge_temp)					// 判断校验值是否相等
					{
						// utc时间转换bjt时间
						ss = (utc.charAt(5) - '0') + (utc.charAt(4) - '0') * 10;
						mm = (utc.charAt(3) - '0') + (utc.charAt(2) - '0') * 10;
						hh = (utc.charAt(1) - '0') + (utc.charAt(0) - '0') * 10 + 8;
						hh = hh % 24;
					}
				}
			}
		}
		System.out.printf("%02d:%02d:%02d", hh, mm, ss);
		in.close();
	}

}
```
## 做法:
先判断前6个字符是否为“$GPRMC"，然后判断字段2(定位)是否为A，然后将字段16(校验值)用Integer.parseInt(str,16)方法转换为十进制，对'$'和‘*’之间的所有字符作^运算，并与校验值进行比较，再将UTC时间转换为BJT时间，并输出。
注意：对字符进行^运算时，要先使用强制类型转换为int型；
　　　输出时间时，不足两位的前面要补0；
　　　UTC时间转换为BJT时间时对跨日的处理。