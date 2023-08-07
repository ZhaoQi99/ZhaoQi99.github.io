# NPC

*A friend handed me this map and told me that it will lead me to the flag. 
It is confusing me and I don't know how to read it, can you help me out?*

*[Attachment](https://storage.googleapis.com/gctf-2023-attachments-project/9a8f5d47fab0a460f9826c4f13aa1dff2809140e68325fb21edab674ee5ec2476b902d2797c41bd6d9311e3510c9366d739d9404e00aa9d4ffd6a0d88e5bf2ef.zip)*

---

使用Graphviz工具将`hint.dot`转换为图片,得到下图

```shell
dot -Tjpg  hint.dot -o hint.jpg
```

<img src="../../CTF/GoogleCTF2023/Misc/assets/hint.jpg" alt="hint.jpg" width="300">

分析代码:

* 从`USACONST.TXT`中随机选择N个单词生成密码,使用`passphrase.encrypt(secret, password)`对flag加密

* 对于`password`中的每个字母,创建一个带有唯一ID的节点,并添加到图中

* 按照`password`的顺序,对密码中相邻的两个字符创建一条边

* 向图中随机添加`int(len(password) ** 1.3)`条边

* 随机打乱图中节点和边的顺序

* 随机交换一些节点的起点和终点,由于`random() % 2`只有在`random`函数返回值为0时才为`False`,我们假定图中每条边的起点和终点都被交换了一遍

* 将节点和边的信息写入到`hint.dot`文件中

我是思路是:

1. 遍历words_list中的单词,从每个节点出发,使用DFS判断是否可以在图中找到,这样过滤后得到30个单词,即密码一定由该30个单词中的某几个单词组成

2. 枚举密码中所用的单词个数N

3. 使用组合数从这30个单词选择N个单词

4. 判断所选的N个单词组成的字符集和`hint.dot`中的字符集是否一致

5. 对N个单词进行全排列,并尝试解密 (*为了提高效率,这里还用到了多进程*)

当N=5时,得到password`standardwatersigngivenchosen`和`flag`.


<details>
<summary>代码</summary>

```python
import concurrent.futures
import itertools
import re
from collections import Counter

from pyrage import passphrase

from encrypt import get_word_list


class Node:
    def __init__(self, letter):
        self.letter = letter
        self.adjacent = []

    def __str__(self) -> str:
        return f"{self.letter} -> {[x.letter for x in self.adjacent]}"

    __repr__ = __str__

def build_nodes():
    pattern = r"\s+(\d+)\s+\[label=(\w+)\];"
    pattern2 = r"\s+(\d+)\s+--\s+(\d+);$"
    nodes = dict()
    with open("hint.dot", "r") as f:
        for line in f:
            if "label" in line
                match = re.match(pattern, line)
                node_id = match.group(1)
                letter = match.group(2)
                nodes[node_id] = Node(letter)
            elif "--" in line:
                match = re.match(pattern2, line)
                start = match.group(1)
                end = match.group(2)
                # nodes[start].adjacent.append(nodes[end])
                nodes[end].adjacent.append(nodes[start])
    return nodes

visited = set()

def dfs(node, index, word):
    if index == len(word):
        return True

    if node.letter != word[index]:
        return False

    visited.add(node)

    for adj in node.adjacent:
        if adj not in visited:
            if dfs(adj, index + 1, word):
                return True

    visited.remove(node)
    return False

def check(password):
    with open("secret.age", "rb") as f:
        enc = f.read()
    try:
        print("[FLAG] is ", passphrase.decrypt(enc, password))
        print("Password is ", password)
    except Exception as e:
        pass


def filter_words(nodes):
    ans = set()
    for word in get_word_list():
        visited.clear()
        for node in nodes.values():
            if dfs(node, 0, word):
                ans.add(word)
                break

    print("ans:", len(ans), ans)
    return ans


def main():
    nodes = build_nodes()

    letters = sorted([node.letter for node in nodes.values()])

    ans = filter_words(nodes)
    for num in range(1, len(ans) + 1):
        print(f"Num is {num}")
        for comb in itertools.combinations(ans, num):  # 组合
            if sorted("".join(comb)) == letters:
                passwords = [
                    "".join(perm) for perm in itertools.permutations(comb, len(comb))
                ]

                with concurrent.futures.ProcessPoolExecutor(max_workers=8) as executor:
                    executor.map(check, passwords)


if __name__ == "__main__":
    main()
```
</details>

**flag**: `CTF{S3vEn_bR1dg35_0f_K0eN1g5BeRg}`

参考:

* [concurrent.futures --- 启动并行任务 -- Python 3.11.4 文档](https://docs.python.org/zh-cn/3/library/concurrent.futures.html?#processpoolexecutor)
