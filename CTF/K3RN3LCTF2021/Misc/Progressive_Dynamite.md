# Progressive Dynamite

Find the minimal sum of numbers on a path from the top left corner to the bottom right corner. You can only go right or down in each move.

https://ctf.k3rn3l4rmy.com/kernelctf-distribution-challs/Progressive-Dynamite/challenge.txt

---

题目给了一个包含负整数的网格,要求我们找到一条从网格左上角元素到右下角元素的路径,使得路径上的数字总和最小.

参照[Leetcode-最小路径和](https://leetcode-cn.com/problems/minimum-path-sum/solution/zui-xiao-lu-jing-he-by-leetcode-solution/),是一道典型的动态规划题,代码如下:

```python
from Crypto.Util.number import *
from challenge import grid

rows, columns = len(grid), len(grid[0])
dp = [[0] * columns for _ in range(rows)]
dp[0][0] = grid[0][0]
for i in range(1, rows):
    dp[i][0] = dp[i - 1][0] + grid[i][0]
for j in range(1, columns):
    dp[0][j] = dp[0][j - 1] + grid[0][j]
for i in range(1, rows):
    for j in range(1, columns):
        dp[i][j] = min(dp[i - 1][j], dp[i][j - 1]) + grid[i][j]
print(dp[rows - 1][columns - 1])
print(long_to_bytes(dp[-1][-1]))
```

**flag:**`flag{dyn4m1c_pr0gramm1ng_pr0!}`