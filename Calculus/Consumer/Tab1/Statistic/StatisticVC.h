//
//  StatisticVC.h
//  Calculus
//
//  Created by ben on 16/3/30.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PNChartDelegate.h"
#import "PNChart.h"
#import "XFSegementView.h"

@interface StatisticVC : UIViewController<PNChartDelegate, TouchLabelDelegate>

@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNCircleChart * circleChart;
@property (nonatomic) PNPieChart *pieChart;


@property (nonatomic) UIView *lineLegend;
@property (nonatomic) UIView *pieLegend;



- (IBAction)changeValue:(id)sender;
@end