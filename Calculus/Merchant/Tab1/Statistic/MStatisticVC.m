//
//  MStatisticVC.m
//  Calculus
//
//  Created by ben on 16/4/5.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MStatisticVC.h"
#import "XFSegementView.h"

@interface MStatisticVC ()

@end

@implementation MStatisticVC
XFSegementView *segementMView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"统计";
    
    segementMView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, 50)];
    segementMView.titleArray = @[@"发放积分",@"积分收发"];
    
    [segementMView.scrollLine setBackgroundColor:[UIColor greenColor]];
    segementMView.titleSelectedColor = [UIColor redColor];
    segementMView.touchDelegate = self;
    [self.view addSubview:segementMView];
    

    
    
    
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
    
    [self.view addSubview:self.lineChart];
    [self.view addSubview:self.lineLegend];

    
    
    
    
    
    
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
            self.barChart.showLabel = YES;
    self.barChart.backgroundColor = [UIColor clearColor];
//    self.barChart.yLabelFormatter = ^(CGFloat yValue){
//        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
//    };
    
    self.barChart.yChartLabelWidth = 20.0;
    self.barChart.chartMarginLeft = 30.0;
    self.barChart.chartMarginRight = 10.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 10.0;
    
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = YES;
    [self.barChart setXLabels:@[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月"]];
           self.barChart.yLabels = @[@-10,@0,@10];
    [self.barChart setYValues:@[@10,@1,@16,@9,@-6,@8]];
    [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNGreen,PNGreen,PNRed,PNGreen]];
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = YES;
    self.barChart.showLevelLine = YES;
    
    
    [self.barChart strokeChart];
    
    self.barChart.delegate = self;
    
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)touchLabelWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            
            [self.view addSubview:self.lineChart];
            [self.view addSubview:self.lineLegend];
            [self.barChart removeFromSuperview];
            [self.barLegend removeFromSuperview];
            
            break;
        case 1:
            [self.view addSubview:self.barChart];
            [self.view addSubview:self.barLegend];
            [self.lineChart removeFromSuperview];
            [self.lineLegend removeFromSuperview];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
