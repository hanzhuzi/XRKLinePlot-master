//
//  ScrollKLineViewController.m
//  XRKLinePlot-master
//
//  Created by xuran on 16/4/22.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//
//  图表

#import "ScrollKLineViewController.h"
#import "XRKLinePlotView.h"
#import "XRKLinePlotModel.h"
#import "NSString+Common.h"

@interface ScrollKLineViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSMutableArray * notShowDataArray;
@property (strong, nonatomic) XRKLinePlotView * plotView;
@property (strong, nonatomic) XRKLinePlotModel * lastModel;
@end

@implementation ScrollKLineViewController

- (void)setupKLinePlotView
{
    _dataArray = [[NSMutableArray alloc] init];
    _notShowDataArray = [NSMutableArray arrayWithCapacity:10];
    _lastModel = [[XRKLinePlotModel alloc] init];
    
    _myScrollView.delegate = self;
    _myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myScrollView];
    
    _plotView = [[XRKLinePlotView alloc] initWithFrame:CGRectMake(0, 0, _myScrollView.contentSize.width, _myScrollView.frame.size.height)];
    _plotView.maxNum = 500.0;
    _plotView.minNum = 0.0;
    _plotView.dataArray = _dataArray;
    [_myScrollView addSubview:_plotView];
    
    [self reloadScrollViewWithDays:7 notShowDays:7];
}

- (void)reloadScrollViewWithDays: (NSInteger)days notShowDays: (NSInteger)notShowDays {
    
    if (_dataArray.count > 0) {
        [_dataArray removeAllObjects];
    }
    
    if (_notShowDataArray.count > 0) {
        [_notShowDataArray removeAllObjects];
    }
    
    _lastModel.date = @"2016-04-22";
    _lastModel.profit = @"0.0";
    
    for (NSInteger i = 0; i < days; i++) {
        XRKLinePlotModel * model = [[XRKLinePlotModel alloc] init];
        NSString * str = _lastModel.date;
        NSString * dateStr = [str getPreDateString];
        model.date = dateStr;
        _lastModel = [model copy];
        model.date = [dateStr getMonthAndDayString];
        model.profit = [NSString stringWithFormat:@"%.2f", (float)arc4random_uniform(500)];
        [_dataArray addObject:model];
    }
    
    // notShow
    _lastModel.date = @"2016-04-22";
    _lastModel.profit = @"0.0";
    
    for (NSInteger i = 0; i < notShowDays; i++) {
        XRKLinePlotModel * model = [[XRKLinePlotModel alloc] init];
        NSString * str = _lastModel.date;
        NSString * dateStr = [str getPreDateString];
        model.date = dateStr;
        _lastModel = [model copy];
        model.date = [dateStr getMonthAndDayString];
        model.profit = [NSString stringWithFormat:@"%.2f", (float)arc4random_uniform(500)];
        [_notShowDataArray addObject:model];
    }
    
    _myScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 7.0 * _dataArray.count, _myScrollView.frame.size.height);
    _plotView.frame = CGRectMake(0, 0, _myScrollView.contentSize.width, _myScrollView.frame.size.height);
    _plotView.maxNum = 500.0;
    _plotView.minNum = 0.0;
    [_plotView reloadDoubleLineViewWithDataArray:_dataArray notShowDataArray:_notShowDataArray];
    [_myScrollView setContentOffset:CGPointMake(_myScrollView.contentSize.width - _myScrollView.frame.size.width, 0) animated:YES];
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [self reloadScrollViewWithDays:7 notShowDays:7];
        }
            break;
        case 1:
        {
            [self reloadScrollViewWithDays:30 notShowDays:30];
        }
            break;
        case 2:
        {
            [self reloadScrollViewWithDays:90 notShowDays:90];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupKLinePlotView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
