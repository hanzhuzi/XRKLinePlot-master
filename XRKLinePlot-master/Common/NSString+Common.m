//
//  NSString+Common.m
//  XRKLinePlot-master
//
//  Created by xuran on 16/4/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

- (NSString *)getPreDateString
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd +0800";
    
    NSDate * date = [formater dateFromString:self];
    NSTimeInterval timeInterVal = [date timeIntervalSince1970];
    NSTimeInterval time = timeInterVal - 60 * 60 * 24.0;
    NSDate * newDate = [NSDate dateWithTimeIntervalSince1970:time];
    formater.dateFormat = @"yyyy-MM-dd";
    NSString * newDateStr = [formater stringFromDate:newDate];
    
    return newDateStr;
}

- (NSString *)getMonthAndDayString
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd +0800";
    
    NSDate * date = [formater dateFromString:self];
    formater.dateFormat = @"MM/dd";
    NSString * newDateStr = [formater stringFromDate:date];
    
    return newDateStr;
}

@end
