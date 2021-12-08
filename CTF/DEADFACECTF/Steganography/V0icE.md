# V0icE

*A friend of mine sent me an audio file which supposes to tell me the time of our night out meeting, but I can't comprehend the voice in the audio file. Can you help me figure it out? I want to hang out with my friends.*

*[Download file](https://tinyurl.com/2sa56kbk)*

*SHA1:3173700e9ba2f062a18707b375fac61049310413*

---

用[Sonic Visualiser](https://www.sonicvisualiser.org/download.html)打开`midnight.wav`,点击`Layer`->`Add Spectrogram`->`midnight.wav: All Channels Mixed`

![V0icE](../../CTF/DEADFACECTF/Steganography/images/V0icE_01.png)

放大后即可看到隐藏在频谱图的flag

![V0icE](../../CTF/DEADFACECTF/Steganography/images/V0icE_02.png)



**flag:**`flag{1257}`