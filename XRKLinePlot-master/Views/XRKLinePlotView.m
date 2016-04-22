//
//  XRKLinePlotView.m
//  XRKLinePlot-master
//
//  Created by xuran on 16/4/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#define TextFontWithSize(a) [UIFont systemFontOfSize:(a)]
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define rgb(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

// 颜色值宏定义
// 一周的颜色值
#define Week_dayColors        @[rgb(247,186,43),rgb(248,169,47),rgb(249,153,51),rgb(250,137,55),rgb(251,121,60),rgb(252,105,64),rgb(253,89,68)]

// 30天的颜色值
#define Month_dayColors       @[rgb(247,186,43),rgb(247,182,44),rgb(247,178,45),rgb(247,174,46),rgb(248,170,47),rgb(248,167,48),rgb(248,163,49),rgb(248,159,50),rgb(249,155,51),rgb(249,152,52),rgb(249,148,53),rgb(249,144,54),rgb(250,140,55),rgb(250,137,56),rgb(250,133,57),rgb(251,129,58),rgb(251,125,59),rgb(251,121,60),rgb(251,118,61),rgb(252,114,62),rgb(252,110,63),rgb(252,106,64),rgb(252,103,65),rgb(253,99,66),rgb(253,95,67),rgb(253,91,68),rgb(253,88,69),rgb(254,84,70),rgb(254,80,71),rgb(254,76,72)]

// 90天的颜色值
#define ThreeMonth_dayColors   @[rgb(247,186,43),rgb(247,184,43),rgb(247,183,43),rgb(247,182,44),rgb(247,180,44),rgb(247,179,44),rgb(247,178,45),rgb(247,177,45),rgb(247,175,45),rgb(247,174,46),rgb(247,173,46),rgb(247,172,46),rgb(248,170,47),rgb(248,169,47),rgb(248,168,47),rgb(248,167,48),rgb(248,165,48),rgb(248,164,48),rgb(248,163,49),rgb(248,162,49),rgb(248,160,49),rgb(248,159,50),rgb(248,158,50),rgb(249,157,50),rgb(249,155,51),rgb(249,154,51),rgb(249,153,51),rgb(249,152,52),rgb(249,150,52),rgb(249,149,52),rgb(249,148,53),rgb(249,147,53),rgb(249,145,53),rgb(249,144,54),rgb(250,143,54),rgb(250,142,54),rgb(250,140,55),rgb(250,139,55),rgb(250,138,55),rgb(250,137,56),rgb(250,135,56),rgb(250,134,56),rgb(250,133,57),rgb(250,132,57),rgb(250,130,57),rgb(251,129,58),rgb(251,128,58),rgb(251,126,58),rgb(251,125,59),rgb(251,124,59),rgb(251,123,59),rgb(251,121,60),rgb(251,120,60),rgb(251,119,60),rgb(251,118,61),rgb(251,116,61),rgb(251,115,61),rgb(252,114,62),rgb(252,113,62),rgb(252,111,62),rgb(252,110,63),rgb(252,109,63),rgb(252,108,63),rgb(252,106,64),rgb(252,105,64),rgb(252,104,64),rgb(252,103,65),rgb(252,101,65),rgb(253,100,65),rgb(253,99,66),rgb(253,98,66),rgb(253,96,66),rgb(253,95,67),rgb(253,94,67),rgb(253,93,67),rgb(253,91,68),rgb(253,90,68),rgb(253,89,68),rgb(253,88,69),rgb(254,86,69),rgb(254,85,69),rgb(254,84,70),rgb(254,83,70),rgb(254,81,70),rgb(254,80,71),rgb(254,79,71),rgb(254,78,71),rgb(254,76,72),rgb(254,75,72),rgb(254,74,72)]

#define KBottom_H       60.0
#define KTop_H          25.0
#define KCircle_Radius  3.0
#define KTextBorder     1.0
#define KPointBorder    5.0
#define KBorder         15.0

#import "XRKLinePlotView.h"
#import "XRKLinePlotModel.h"

CGFloat distanceBetweenPoint(CGPoint beginP, CGPoint endP) {
    
    CGFloat xDistance = beginP.x - endP.x;
    CGFloat yDistance = beginP.y - endP.y;
    
    return sqrt(xDistance * xDistance + yDistance * yDistance);
}

@interface XRKLinePlotView ()
@property (nonatomic, strong) NSMutableArray * pointsArray;
@property (nonatomic, strong) NSArray * colorsArray;
@end

@implementation XRKLinePlotView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _pointsArray = [NSMutableArray arrayWithCapacity:10];
        _minNum = 0;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _pointsArray = [NSMutableArray arrayWithCapacity:10];
        _minNum = 0;
    }
    
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
}

// 重新绘制双折线图
- (void)reloadDoubleLineViewWithDataArray:(NSArray *)daatArray
                         notShowDataArray:(NSArray *)notDataArray
{
    _dataArray = daatArray;
    _notShowDataArray = notDataArray;
    
    [self setNeedsDisplay];
}

// 重新绘制折线图
- (void)reloadLineViewWithDataArray:(NSArray *)daatArray
{
    _dataArray = daatArray;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (!_dataArray && _dataArray.count == 0) {
        return;
    }
    
    // 初始化
    // 计算每段的width
    CGFloat eachWidth = [UIScreen mainScreen].bounds.size.width / 7.0; // 一屏显示7天
    CGFloat startX = eachWidth * 0.5;
    CGFloat startY = self.frame.size.height - KBottom_H;
    CGFloat kLineHeight = startY - KTop_H;
    // 每段比例高度
    CGFloat eachHeight = 0.0;
    
    if (_maxNum == _minNum) {
        eachHeight = 0.0;
    }else {
        eachHeight = kLineHeight / (_maxNum - _minNum);
    }
    
    // 获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画y轴标注
    for (int i = 0; i < _dataArray.count; i++) {
        XRKLinePlotModel * model = _dataArray[i];
        NSString * text = model.date;
        NSDictionary * attributes = @{NSFontAttributeName : TextFontWithSize(9.0), NSForegroundColorAttributeName : UIColorFromRGB(0x666666)};
        CGSize textSize = [text sizeWithAttributes:attributes];
        CGFloat textX = startX + (_dataArray.count - 1 - i) * eachWidth - textSize.width * 0.5;
        CGFloat textY = startY + (KBottom_H - textSize.height) * 0.5;
        
        [text drawInRect:CGRectMake(textX, textY, textSize.width, textSize.height) withAttributes:attributes];
    }
    
    // 画y轴线
    for (int i = 0; i < _dataArray.count; i++) {
        CGContextMoveToPoint(ctx, startX + (_dataArray.count - 1 - i) * eachWidth, startY);
        CGContextAddLineToPoint(ctx, startX + (_dataArray.count - 1 - i) * eachWidth, KTop_H);
    }
    
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0xcccccc).CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextStrokePath(ctx);
    
#pragma  mark - 绘制灰色的线
    
    if (self.notShowDataArray && self.notShowDataArray.count > 0) {
        // 绘制灰色线
        XRKLinePlotModel * grayModel = _notShowDataArray[0];
        double grayNum = [grayModel.profit doubleValue];
        CGFloat grayCircleX = startX + (_notShowDataArray.count - 1) * eachWidth;
        CGFloat grayCircleY = _maxNum == _minNum? (startY - eachHeight) : (startY - (grayNum - _minNum) * eachHeight);
        CGContextMoveToPoint(ctx, grayCircleX, grayCircleY);
        for (int i = 1; i < _notShowDataArray.count; i++) {
            XRKLinePlotModel * model = _notShowDataArray[i];
            grayNum = [model.profit doubleValue];
            if (grayNum != -9999) {
                grayCircleX = startX + (_notShowDataArray.count - 1 - i) * eachWidth;
                if (_maxNum == _minNum) {
                    grayCircleY = startY - eachHeight;
                }else {
                    grayCircleY = startY - (grayNum - _minNum) * eachHeight;
                }
                CGContextAddLineToPoint(ctx, grayCircleX, grayCircleY);
            }
        }
        
        CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0xcccccc).CGColor);
        CGContextSetLineWidth(ctx, 2.0);
        CGContextStrokePath(ctx);
    }
    
#pragma mark - 绘制红色的线
    
    if (_dataArray.count == 7) {
        _colorsArray = Week_dayColors;
    }else if (_dataArray.count == 30) {
        _colorsArray = Month_dayColors;
    }else if (_dataArray.count == 90) {
        _colorsArray = ThreeMonth_dayColors;
    }
    
    if (_pointsArray.count > 0) {
        [_pointsArray removeAllObjects];
    }
    
    // 记录画线的坐标点的值
    for (int i = 0; i < _dataArray.count; i++) {
        XRKLinePlotModel * model = _dataArray[i];
        double num = [model.profit doubleValue];
        CGFloat circleX = startX + (_dataArray.count - i - 1) * eachWidth;
        CGFloat circleY = 0.0;
        if (_maxNum == _minNum) {
            circleY = startY - eachHeight;
        }else {
            circleY = startY - (num - _minNum) * eachHeight;
        }
        
        CGPoint point = CGPointMake(circleX, circleY);
        NSValue * value = [NSValue valueWithCGPoint:point];
        [_pointsArray addObject:value];
    }
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    CGPoint beginPoint;
    CGPoint endPoint;
    
    CGPoint startPt = [_pointsArray[0] CGPointValue];
    CGFloat circleX = startPt.x;
    CGFloat circleY = startPt.y;
    
    CGContextMoveToPoint(ctx, circleX, circleY);
    for (int i = 0; i < _pointsArray.count - 1; i++) {
        UIColor * beginColor;
        UIColor * endColor;
        if (_pointsArray.count == _colorsArray.count) {
            beginColor = _colorsArray[i];
            endColor = _colorsArray[i + 1];
            // begin to end
            beginPoint = [_pointsArray[_pointsArray.count - i - 1] CGPointValue];
            endPoint = [_pointsArray[_pointsArray.count - i - 2] CGPointValue];
            
            NSArray * array = @[(__bridge id)beginColor.CGColor, (__bridge id)endColor.CGColor];
            CGGradientRef gradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)array, NULL);
            CGColorSpaceRelease(rgb);
            
            CGContextSaveGState(ctx);
            
            CGFloat increateY = fabs(endPoint.x - beginPoint.x) / distanceBetweenPoint(beginPoint, endPoint) * 1.0;
            CGFloat increateX = fabs(endPoint.y - beginPoint.y) / distanceBetweenPoint(beginPoint, endPoint) * 1.0;
            
            if (endPoint.y > beginPoint.y) {
                CGContextMoveToPoint(ctx, beginPoint.x - increateX, beginPoint.y + increateY);
                CGContextAddLineToPoint(ctx, beginPoint.x + increateX, beginPoint.y - increateY);
                CGContextAddLineToPoint(ctx, endPoint.x + increateX, endPoint.y - increateY);
                CGContextAddLineToPoint(ctx, endPoint.x - increateX, endPoint.y + increateY);
            }
            else {
                CGContextMoveToPoint(ctx, beginPoint.x - increateX, beginPoint.y - increateY);
                CGContextAddLineToPoint(ctx, beginPoint.x + increateX, beginPoint.y + increateY);
                CGContextAddLineToPoint(ctx, endPoint.x + increateX, endPoint.y + increateY);
                CGContextAddLineToPoint(ctx, endPoint.x - increateX, endPoint.y - increateY);
            }
            
            CGContextClip(ctx);
            CGContextDrawLinearGradient(ctx, gradient,beginPoint ,endPoint,
                                        kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(ctx); // 恢复到之前的context
        }
    }
    // 释放colorSpace
    CGColorSpaceRelease(rgb);
    
    // 灰色圈
    for (int i = 0; i < _notShowDataArray.count; i++) {
        XRKLinePlotModel * model = _notShowDataArray[i];
        double num = [model.profit doubleValue];
        if (num != -9999) {
            CGFloat circleX = startX + (_notShowDataArray.count - 1 - i) * eachWidth;
            CGFloat circleY = 0.0;
            if (_maxNum == _minNum) {
                circleY = startY - eachHeight;
            }else {
                circleY = startY - (num - _minNum) * eachHeight;
            }
            
            // 小圆
            CGContextAddArc(ctx, circleX, circleY, KCircle_Radius, 0, M_PI * 2, 0);
            CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0xffffff).CGColor);
            CGContextDrawPath(ctx, kCGPathEOFill);
            // 大圆
            UIColor * circle_color = UIColorFromRGB(0xcccccc);
            CGContextAddArc(ctx, circleX, circleY, KCircle_Radius, 0, M_PI * 2, 0);
            CGContextSetStrokeColorWithColor(ctx, circle_color.CGColor);
            CGContextSetLineWidth(ctx, 2.0);
            CGContextStrokePath(ctx);
        }
    }
    
    // 渐变圈
    for (int i = 0; i < _dataArray.count; i++) {
        XRKLinePlotModel * model = _dataArray[i];
        double num = [model.profit doubleValue];
        if (num != -9999) {
            CGFloat circleX = startX + (_dataArray.count - 1 - i) * eachWidth;
            CGFloat circleY = 0.0;
            if (_maxNum == _minNum) {
                circleY = startY - eachHeight;
            }else {
                circleY = startY - (num - _minNum) * eachHeight;
            }
            
            // 小圆
            CGContextAddArc(ctx, circleX, circleY, KCircle_Radius, 0, M_PI * 2, 0);
            CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0xffffff).CGColor);
            CGContextDrawPath(ctx, kCGPathEOFill);
            // 大圆
            UIColor * circle_color = UIColorFromRGB(0xff4949);
            if (self.dataArray.count == _colorsArray.count) {
                circle_color = _colorsArray[_colorsArray.count - 1 - i];
            }
            
            CGContextAddArc(ctx, circleX, circleY, KCircle_Radius, 0, M_PI * 2, 0);
            CGContextSetStrokeColorWithColor(ctx, circle_color.CGColor);
            CGContextSetLineWidth(ctx, 2.0);
            CGContextStrokePath(ctx);
        }
    }
    
    // 画胶囊
    // 左半圆
    NSDictionary * attributes = @{NSFontAttributeName : TextFontWithSize(9.0), NSForegroundColorAttributeName : UIColorFromRGB(0xffffff)};
    for (int i = 0; i < _dataArray.count; i++) {
        XRKLinePlotModel * model = _dataArray[i];
        double num = [model.profit doubleValue];
        
        if (num != -9999) {
            CGFloat circleX = startX + (_dataArray.count - 1 - i) * eachWidth;
            CGFloat circleY = 0.0;
            if (_maxNum == _minNum) {
                circleY = startY - eachHeight;
            }else {
                circleY = startY - (num - _minNum) * eachHeight;
            }
            
            NSString * numStr = [NSString stringWithFormat:@"%.2lf", num];
            
            CGSize numSize = [numStr sizeWithAttributes:attributes];
            CGFloat radius = (numSize.height + KTextBorder * 2.0) * 0.5;
            CGFloat numX = circleX - numSize.width * 0.5;
            CGFloat numY = 0.0;
            
            // 取出上一个点的数据和这个点的数据
            double preNum = 0.0;
            if (i > 0) {
                XRKLinePlotModel * model = _dataArray[i-1];
                preNum = [model.profit doubleValue];
            }
            
            // 第一个点和上升的点在上面
            if ((num - preNum) >= 0.0) {
                // 在圆点上面
                numY = circleY - KCircle_Radius - KPointBorder - radius;
                
                // 判断第一个点的走势
                if (self.dataArray.count > 2 && i == 0) {
                    XRKLinePlotModel * nextModel = self.dataArray[i+1];
                    double nextNum = [nextModel.profit doubleValue];
                    if (nextNum > num) {
                        // 在圆点下面
                        numY = circleY + KCircle_Radius + KPointBorder + radius;
                    }else {
                        // 在圆点上面
                        numY = circleY - KCircle_Radius - KPointBorder - radius;
                    }
                }
            }else {
                // 在圆点下面
                numY = circleY + KCircle_Radius + KPointBorder + radius;
            }
            
            CGContextAddArc(ctx, numX, numY, radius, M_PI_2, M_PI_2 * 3, 0);
            CGContextAddLineToPoint(ctx, numX, numY);
            // 右半圆
            CGContextAddArc(ctx, numX + numSize.width, numY, radius, M_PI_2, -M_PI_2, 1);
            CGContextAddLineToPoint(ctx, numX + numSize.width, numY + radius);
            
            // 画矩形
            CGContextMoveToPoint(ctx, numX, numY - radius);
            CGContextAddLineToPoint(ctx, numX + numSize.width, numY - radius);
            CGContextAddLineToPoint(ctx, numX + numSize.width, numY + radius);
            CGContextAddLineToPoint(ctx, numX, numY + radius);
            CGContextAddLineToPoint(ctx, numX, numY - radius);
            
            UIColor * circle_color = UIColorFromRGB(0xff4949);
            if (self.dataArray.count == _colorsArray.count) {
                circle_color = _colorsArray[_colorsArray.count - 1 - i];
            }
            
            CGContextSetFillColorWithColor(ctx, circle_color.CGColor);
            CGContextFillPath(ctx);
            
            // 画文字（此处可以调整字的位置）
            [numStr drawInRect:CGRectMake(numX, numY - numSize.height * 0.5 - 0.5, numSize.width, numSize.height) withAttributes:attributes];
        }
    }
}

@end
