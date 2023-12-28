# UCAS高等数字集成电路作业

课程作业目录：

```.
└── homework4
    ├── add_tc_16_16
    ├── mul_tc_16_16
    └── stop_watch
```

环境：vcs2018、verdi2018

工程目录结构示例：

```c
├── design								// 设计目录
│   ├── add_tc_16_16					// 子模块
│   │   ├── ips							// 调用的ip
│   │   └── rtl							// rtl代码
│   │       ├── add_tc_16_16.v
│   │       └── cla4.v
│   └── filelist
│       └── add_tc_16_16.lst
├── dv
│   ├── bin								// 辅助脚本
│   │   └── rand.pl	
│   ├── log								// 脚本log
│   ├── sim								// 仿真
│   │   ├── cmd.ucli					// ucli命令（用于dump波形文件或控制仿真）
│   │   └── makefile					// 仿真makefile
│   └── tb								// testbench
│       ├── add_tc_16_16_tb.v			
│       ├── filelist
│       │   └── tb.lst
│       └── inc							// 头文件
├── impl								// 物理实现
└── syn									// 综合
    ├── rundc.tcl						// 综合脚本（包含约束）
    └── run.sh
```

仿真命令：
```bash
cd dv/sim
make sim
make verdi
```

综合命令：

```bash
cd syn
./run.sh
```

清空综合结果：

```
rm -r `ls | grep -v "run*"`
```

一些可选参数：

```bash
make sim seed=0		//每次仿真覆盖上一次波形，若不指定seed，则每次仿真输出波形名称唯一，不覆盖
```

