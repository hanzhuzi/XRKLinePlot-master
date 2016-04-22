//
//  XRKLinePlotModel.m
//  XRKLinePlot-master
//
//  Created by xuran on 16/4/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "XRKLinePlotModel.h"

@implementation XRKLinePlotModel

- (id)copyWithZone:(NSZone *)zone
{
    XRKLinePlotModel * model = [[XRKLinePlotModel alloc] init];
    model.date = self.date;
    model.profit = self.profit;
    return model;
}

@end
