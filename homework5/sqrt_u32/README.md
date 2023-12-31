

## Hyperbolic Cordic 开方

参考文章：

[Chisel实践——利用CORDIC算法计算平方根 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/336572351)

[【硬件算法笔记22】CORDIC算法 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/359610075)

[CORDIC算法详解(四)-CORDIC 算法之双曲系统及其数学应用_cordic双曲函数-CSDN博客](https://blog.csdn.net/Pieces_thinking/article/details/83545806)

[Generalized Hyperbolic CORDIC and Its Logarithmic and Exponential Computation With Arbitrary Fixed Base | IEEE Journals & Magazine | IEEE Xplore](https://ieeexplore.ieee.org/document/8738918)



在Hyperbolic Cordic 的 Vector 模式下（详见参考文章），可以进行开方运算，但有定义域要求：输入范围在[0.1069,9.3573]之间。

### 定义域扩展

要计算32位整数开方，需要将输入映射到cordic算法要求的定义域中，由于原定义域左端不是0开始，无法直接线性映射到 [0,0xFFFF_FFFF] 的整数区间，可以通过移位对输入的整数数据进行缩放，缩放至cordic的定义域区间，计算完成后，再进行对应的缩放还原。

为了控制精度，缩放时需要使用使用定点格式的小数，整数部分3位，小数部分29位，这样表示的数据范围为[0,8]。

![定点化](doc\定点化.png)

假设整个开方模块的输入的定点数据为x，输出为y，当x的定点格式不在要求的定义域时，需要进行移位缩放。
$$
\begin{align}
input &=x\\
output &=y\\
x\_shiftted &= x * 2 ^n \in[0,8]\\
\end{align}
$$


输入到cordic中运算，其中Kh是Cordic迭代过程的累积系数，详见参考文章。
$$
cordic\_output &= 2K_h\sqrt{x * 2 ^n} =2K_h{2^{n/2}}*x,\:\:其中K_h\approx1.2075\\
$$


最后对cordic的输出的结果乘对应的系数进行还原：
$$
\begin{align}


y &= coridc\_output * K,\:\:\:\:其中K = 1/{(2^{n/2}*2K_h)}\\

\end{align}
$$



### 算法实现的一些Tips

1. 经过误差统计，在输入为1附近时，cordic的输出有一个相对较大的误差，因此考虑可用的定义域范围为[2,8]。
2. 可以注意到，对于不同的缩放n，会导致输出还原时要乘不同的系数K，这在硬件实现上是不友好的，我们可以考虑规定n以2进行步进。例如n = {1, -1, -3, -7, -9, ..., -29} 这样不论缩放了多少倍，最后还原时都只需要乘同一个K，在此基础上进行移位。

  基于以上，对输入数据的缩放划分为16组：

```verilog
always @(*) begin
        casex (x)
            32'b0000_0000_0000_0000_0000_0000_0000_00xx: begin x_sft = x << 30; sqrt_res = ox_k >> 59;  end  // * 2^ 1
            32'b0000_0000_0000_0000_0000_0000_0000_xxxx: begin x_sft = x << 28; sqrt_res = ox_k >> 58;  end  // * 2^-1
            32'b0000_0000_0000_0000_0000_0000_00xx_xxxx: begin x_sft = x << 26; sqrt_res = ox_k >> 57;  end  // * 2^-3
            32'b0000_0000_0000_0000_0000_0000_xxxx_xxxx: begin x_sft = x << 24; sqrt_res = ox_k >> 56;  end  // * 2^-5
            32'b0000_0000_0000_0000_0000_00xx_xxxx_xxxx: begin x_sft = x << 22; sqrt_res = ox_k >> 55;  end  // * 2^-7
            32'b0000_0000_0000_0000_0000_xxxx_xxxx_xxxx: begin x_sft = x << 20; sqrt_res = ox_k >> 54;  end  // * 2^-9
            32'b0000_0000_0000_0000_00xx_xxxx_xxxx_xxxx: begin x_sft = x << 18; sqrt_res = ox_k >> 53;  end  // * 2^-11
            32'b0000_0000_0000_0000_xxxx_xxxx_xxxx_xxxx: begin x_sft = x << 16; sqrt_res = ox_k >> 52;  end  // * 2^-13
            32'b0000_0000_0000_00xx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x << 14; sqrt_res = ox_k >> 51;  end  // * 2^-15
            32'b0000_0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x << 12; sqrt_res = ox_k >> 50;  end  // * 2^-17
            32'b0000_0000_00xx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x << 10; sqrt_res = ox_k >> 49;  end  // * 2^-19
            32'b0000_0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x <<  8; sqrt_res = ox_k >> 48;  end  // * 2^-21
            32'b0000_00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x <<  6; sqrt_res = ox_k >> 47;  end  // * 2^-23
            32'b0000_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x <<  4; sqrt_res = ox_k >> 46;  end  // * 2^-25
            32'b00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin x_sft = x <<  2; sqrt_res = ox_k >> 45;  end  // * 2^-27
            default:                                     begin x_sft = x;       sqrt_res = ox_k >> 44 ; end  // * 2^-29
        endcase
    end
```

<!--【注】：最开始尝试是n以4步进的，这时移位的情况只需划分为8组，更节省面积，但无法避开上述第一条：当输入为1附近时（定点数的高4位为0010），cordic输出的误差较大。因此使用n以2为步进，此时定义域进一步收缩至[4,8]。-->

### 算法流程



![cordic_sqrt_structure](doc\cordic_sqrt_structure.jpg)



### 误差分析 & TODO

由于Cordic是往复迭代的，误差在有正有负，无法严格实现题目要求的`y是平方后不超过x的最大非负整数`，误差在±1。

Hyperbolic Cordic输入为1时，输出有一个突变的较大的误差，这个误差的来源没有找到，应该是没有收敛，在一些文章中提到需要在迭代至2*k+1（k=1,2,3,...）次时，重复一次上次迭代，尝试过这种写法，结果误差更大。







