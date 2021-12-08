# A Warning

*Luciafer is being watched! Someone on the inside of Lytton Labs can see what she is doing and is sending her a message.*

*One of them says: "Stay away from Lytton Labs... you have been warned."*

*To find the flag, find the message. You'll know it when you see it. Submit the flag as `flag{flag-goes-here}`.*

*Use the PCAP from LYTTON LABS 01 - Monstrum ex Machina.*

---

使用[Wireshark](https://www.wireshark.org/download.html)打开`pcap-challenge-final.pcapng`文件,搜索“warning”,找到一个请求`da-warning-message.jpg`的HTTP请求

![A-Warning](../../CTF/DEADFACECTF/Traffic_Analysis/images/A-Warning.png)

找到该请求对应响应的数据包(16050),对着"JPEG File Interchange Format"右键,选择"显示分组字节",即可看到flag

![image-20211106204519981](../../CTF/DEADFACECTF/Traffic_Analysis/images/A-Warning-02.png)

![image-20211106205413070](../../CTF/DEADFACECTF/Traffic_Analysis/images/A-Warning-03.png)

**flag:**`flag{angels-fear-to-tread}`
