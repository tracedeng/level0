//
//  StatisticVC.m
//  Calculus
//
//  Created by ben on 16/3/30.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "StatisticVC.h"
#define ARC4RANDOM_MAX 0x100000000

@interface StatisticVC ()

@end




@implementation StatisticVC
XFSegementView *segementView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"统计";
    
    segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, 50)];
    //    [segementView setBackgroundColor:[UIColor cyanColor]];
    //    [segementView setFrame:CGRectMake(0, 200, 320, 100)];
    //    segementView.titleArray = @[@"设计",@"舞蹈",@"歌唱",@"达人"];
    segementView.titleArray = @[@"积分分布",@"近半年统计"];
    
    //    segementView.scrollLineColor = [UIColor greenColor];
    [segementView.scrollLine setBackgroundColor:[UIColor greenColor]];
    segementView.titleSelectedColor = [UIColor redColor];
    //    segementView.titleSelectedColor = [UIColor greenColor];
    segementView.touchDelegate = self;
    //    segementView.haveNoRightLine = NO;
    [self.view addSubview:segementView];

    
    

    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月"]];
    self.lineChart.showCoordinateAxis = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.lineChart.yFixedValueMax = 300.0;
    self.lineChart.yFixedValueMin = 0.0;
    
    [self.lineChart setYLabels:@[
                                 @"0 ",
                                 @"50 ",
                                 @"100 ",
                                 @"150 ",
                                 @"200 ",
                                 @"250 ",
                                 @"300 ",
                                 ]
     ];

    
    
    // Line Chart #1
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @0.0, @186.2, @127.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"总量（积分）";
    data01.color = PNFreshGreen;
    data01.alpha = 0.3f;
    data01.itemCount = data01Array.count;
    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01];
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
    
    self.lineChart.legendStyle = PNLegendItemStyleStacked;
    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    self.lineChart.legendFontColor = [UIColor redColor];
    
    self.lineLegend = [self.lineChart getLegendWithMaxWidth:320];
    [self.lineLegend setFrame:CGRectMake(30, 340, self.lineLegend.frame.size.width, self.lineLegend.frame.size.width)];
   
    
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGrey description:@"其他"],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"肯德基"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"麦当劳"],
                       [PNPieChartDataItem dataItemWithValue:45 color:PNYellow description:@"星巴克"],
                       ];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 135, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    self.pieLegend = [self.pieChart getLegendWithMaxWidth:200];
    [self.pieLegend setFrame:CGRectMake(130, 350, self.pieLegend.frame.size.width, self.pieLegend.frame.size.height)];
    [self.view addSubview: self.pieLegend];
    
    [self.view addSubview:self.pieChart];

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchLabelWithIndex:(NSInteger)index{
    NSLog(@"我是第%ld个label",index);
    switch (index) {
        case 0:
            [self.view addSubview:self.pieChart];
            [self.view addSubview:self.pieLegend];
            [self.lineChart removeFromSuperview];
            [self.lineLegend removeFromSuperview];

            break;
        case 1:
            
            [self.view addSubview:self.lineChart];
            [self.view addSubview:self.lineLegend];
            [self.pieChart removeFromSuperview];
            [self.pieLegend removeFromSuperview];

            break;
            
        default:
            break;
    }
}

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    
    NSLog(@"Click on bar %@", @(barIndex));
    
    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [bar.layer addAnimation:animation forKey:@"Float"];
}


@end
