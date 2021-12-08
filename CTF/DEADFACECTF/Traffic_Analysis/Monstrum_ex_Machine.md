# Monster from the Machine
*Our person on the "inside" of Ghost Town was able to plant a packet sniffing device on Luciafer's computer. Based on our initial analysis, we know that she was attempting to hack a computer in Lytton Labs, and we have some idea of what she was doing, but we need a more in-depth analysis. This is where YOU come in.*

*We need YOU to help us analyze the packet capture. Look for relevant data to the potential attempted hack.*

*To gather some information on the victim, investigate the victim's computer activity. The "victim" was using a search engine to look up a name. Provide the name with standard capitalization: `flag{Jerry Seinfeld}`.*

*[Download file](https://tinyurl.com/35a45kc3)*

*SHA1: 6c0caf366dae3e03bcbd7338de0030812536894c*

---

使用[Wireshark](https://www.wireshark.org/download.html)打开`pcap-challenge-final.pcapng`文件,按照`HTTP`过滤

![Monstrum ex Machine](../../CTF/DEADFACECTF/Traffic_Analysis/images/monstrum_ex_machine-00.png)
右键,点击"跟踪流"->"HTTP流"
![Monstrum ex Machine](../../CTF/DEADFACECTF/Traffic_Analysis/images/monstrum_ex_machine.png)

**flag:**`flag{Charles Geschickter}`