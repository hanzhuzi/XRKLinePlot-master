//
//  XRKLinePlotView.h
//  XRKLinePlot-master
//
//  Created by xuran on 16/4/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 *  @brief 数据走势展示的折线图封装，支持颜色渐变，日期显示，数据节点展示。
 *
 *  @by    黯丶野火
 **/

#import <UIKit/UIKit.h>

@interface XRKLinePlotView : UIView
@property (nonatomic, assign) CGFloat maxNum; // K线y轴上的最大值
@property (nonatomic, assign) CGFloat minNum; // 最小值

// 数据源
@property (nonatomic, strong) NSArray * dataArray;
// 只显示走势的数据源
@property (nonatomic, strong) NSArray * notShowDataArray;

// 重新绘制
- (void)reloadLineViewWithDataArray:(NSArray *)daatArray;
// 重新绘制双折线图
- (void)reloadDoubleLineViewWithDataArray:(NSArray *)daatArray
                         notShowDataArray:(NSArray *)notDataArray;
@end
