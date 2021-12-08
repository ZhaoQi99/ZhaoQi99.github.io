# layers

*Check out my brand new docker repo https://hub.docker.com/r/qxxxb/layers*

---

查看镜像历史,发现曾经存在一个`flag.png`,但是被删除了

```shell
[root@VM-8-4-centos ~] docker history qxxxb/layers
IMAGE          CREATED       CREATED BY                                      SIZE      COMMENT
0c01a25ae5b7   5 days ago    /bin/sh -c echo "Sorry, the flag has been de…   36B
<missing>      5 days ago    /bin/sh -c rm flag.png                          0B
<missing>      5 days ago    /bin/sh -c #(nop) COPY multi:6b3bd56201fda03…   599kB
<missing>      8 weeks ago   /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
<missing>      8 weeks ago   /bin/sh -c #(nop) ADD file:aad4290d27580cc1a…   5.6MB
```
使用`docker save`将镜像保存成tar包并解压,然后再解压每一层文件夹中中的`layer.tar`找到`flag.png`
```shell
[root@VM-8-4-centos ~] docker save qxxxb/layers -o a.tar
[root@VM-8-4-centos ~]# tar xvf a.tar
0c01a25ae5b745b06c68c7b870b848f327227e06feca8f121c105d3cc423ebc9.json
7c029681dc775f74b57cccd272523fd31a20f89cc2db9b514981fcbfb467b5c8/
7c029681dc775f74b57cccd272523fd31a20f89cc2db9b514981fcbfb467b5c8/VERSION
7c029681dc775f74b57cccd272523fd31a20f89cc2db9b514981fcbfb467b5c8/json
7c029681dc775f74b57cccd272523fd31a20f89cc2db9b514981fcbfb467b5c8/layer.tar
8771987229b6efdf7a40855b92529d9287e96ead2f6668d84f6a07809818db52/
8771987229b6efdf7a40855b92529d9287e96ead2f6668d84f6a07809818db52/VERSION
8771987229b6efdf7a40855b92529d9287e96ead2f6668d84f6a07809818db52/json
8771987229b6efdf7a40855b92529d9287e96ead2f6668d84f6a07809818db52/layer.tar
c37364b4cf72fc0eb131ee6d62795ef9cf3641340dd0aa8da6849b4c9cd5c41f/
c37364b4cf72fc0eb131ee6d62795ef9cf3641340dd0aa8da6849b4c9cd5c41f/VERSION
c37364b4cf72fc0eb131ee6d62795ef9cf3641340dd0aa8da6849b4c9cd5c41f/json
c37364b4cf72fc0eb131ee6d62795ef9cf3641340dd0aa8da6849b4c9cd5c41f/layer.tar
c6dd22d66071385f6a0d7242a2f2a895073c8ab84871b56390a3449038a49727/
c6dd22d66071385f6a0d7242a2f2a895073c8ab84871b56390a3449038a49727/VERSION
c6dd22d66071385f6a0d7242a2f2a895073c8ab84871b56390a3449038a49727/json
c6dd22d66071385f6a0d7242a2f2a895073c8ab84871b56390a3449038a49727/layer.tar
manifest.json
repositories
[root@VM-8-4-centos ~]# tar xvf 7c029681dc775f74b57cccd272523fd31a20f89cc2db9b514981fcbfb467b5c8/layer.tar
Dockerfile
flag.png
```

![flag](../../CTF/BuckeyeCTF2021/Misc/images/flag.png)

**flag:**`buckeye{D0CK3R_H4S_L4Y3RS}`