

## 利用Coridc开方

在双曲coridc算法下，可以进行开方运算，但有定义域要求：输入范围在[0.1069,9.3573]之间

如果利用定点运算：

整数部分：3位

小数部分：29位

无法缩放，因为有下限0.1069



可以用“浮点”的思路进行移位缩放:

例如65536，左移，使其第一个非零位“顶格”。

1：左移31位

2：左移30位

4：左移29位





参考：

[Chisel实践——利用CORDIC算法计算平方根 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/336572351)

[【硬件算法笔记22】CORDIC算法 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/359610075)

[CORDIC算法详解(四)-CORDIC 算法之双曲系统及其数学应用_cordic双曲函数-CSDN博客](https://blog.csdn.net/Pieces_thinking/article/details/83545806)