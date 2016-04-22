# XRKLinePlot-master
使用iOS绘图系统绘制的K线图，K线图采用颜色渐变，显示日期的数据走势。

![](https://github.com/hanzhuzi/XRKLinePlot-master/blob/master/XRKLinePlot-master/Snaps/Simulator%20Screen%20Shot%202016年4月22日%20下午4.30.03.png)
![](https://github.com/hanzhuzi/XRKLinePlot-master/blob/master/XRKLinePlot-master/Snaps/Simulator%20Screen%20Shot%202016年4月22日%20下午4.30.25.png)
![](https://github.com/hanzhuzi/XRKLinePlot-master/blob/master/XRKLinePlot-master/Snaps/Simulator%20Screen%20Shot%202016年4月22日%20下午4.30.34.png)

####使用
```Objective-C
    
    XRKLinePlotView * plotView = [[XRKLinePlotView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    plotView.maxNum = 500.0;
    plotView.minNum = 0.0;
    plotView.dataArray = _dataArray;
    [self.view addSubview:plotView];

```
