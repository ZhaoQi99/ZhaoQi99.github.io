---
title: 01-复杂度2 Maximum Subsequence Sum（25 分）
date: 2017-09-01 21:12:05
categories: 数据结构_陈越、何钦铭
tags:
     - 数据结构
---
## Problem:
Given a sequence of KK integers {N1,N2,...,NK}. A continuous subsequence is defined to be {Ni,Ni+1,...,Nj} where 1≤i≤j≤K1≤i≤j≤K. The Maximum Subsequence is the continuous subsequence which has the largest sum of its elements. For example, given sequence { -2, 11, -4, 13, -5, -2 }, its maximum subsequence is { 11, -4, 13 } with the largest sum being 20.
Now you are supposed to find the largest sum, together with the first and the last numbers of the maximum subsequence.
## Input Specification:
Each input file contains one test case. Each case occupies two lines. The first line contains a positive integerK(≤10000). The second line contains K numbers, separated by a space.
## Output Specification:
For each test case, output in one line the largest sum, together with the first and the last numbers of the maximum subsequence. The numbers must be separated by one space, but there must be no extra space at the end of a line. In case that the maximum subsequence is not unique, output the one with the smallest indices i and j (as shown by the sample case). If all the K numbers are negative, then its maximum sum is defined to be 0, and you are supposed to output the first and the last numbers of the whole sequence.
output the first and the last numbers of the whole sequence.


## Sample Input:
> 10
> -10 1 2 3 4 -5 -23 3 7 -21
## Sample Output:
> 10 1 4

## 代码：
```C++
#include<bits/stdc++.h>

using namespace std;

typedef long long ll;

ll Start, End;
int a[1000006];
ll n;

int MaxSubseqSum2( int A[], int N )
{
    int ThisSum, MaxSum = -0xffff;
    int i, j;
    for( i = 0; i < N; i++ )   /* i是子列左端位置 */
    {
        ThisSum = 0;  /* ThisSum是从A[i]到A[j]的子列和 */
        for( j = i; j < N; j++ )   /* j是子列右端位置 */
        {
            ThisSum += A[j];        /*对于相同的i，不同的j，只要在j-1次循环的基础上累加1项即可*/
            if( ThisSum > MaxSum ) /* 如果刚得到的这个子列和更大 */
            {
                MaxSum = ThisSum;    /* 则更新结果 */
                Start = A[i];
                End = A[j];
            }
        } /* j循环结束 */
    } /* i循环结束 */
    return MaxSum;
}

void input()
{
    cin >> n;
    for(ll i = 0; i < n; i++)
    {
        cin >> a[i];
    }
}

void output()
{
    int temp = MaxSubseqSum2(a, n);
    if(temp < 0)
        cout << 0 << " " << a[0] << " " << a[n - 1] << endl;
    else
        cout << MaxSubseqSum2(a, n) << " " << Start << " " << End << endl;
}
int main()
{
    cin.sync_with_stdio(false);
    input();
    output();
    return 0;
}
```
两重循环遍历，算法复杂度为O（N^2）；
第一次提交有部分测试点没通过，其原因是对最大和小于0时的情况没处理好。