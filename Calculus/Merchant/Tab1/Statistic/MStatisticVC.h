//
//  MStatisticVC.h
//  Calculus
//
//  Created by ben on 16/4/5.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "XFSegementView.h"

@interface MStatisticVC : UIViewController<PNChartDelegate, TouchLabelDelegate>
@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) PNBarChart * barChart;



@property (nonatomic) UIView *lineLegend;
@property (nonatomic) UIView *barLegend;

@end
