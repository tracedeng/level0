//
//  MActivityTVC.h
//  Calculus
//
//  Created by tracedeng on 15/12/31.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MActivityTVC : UITableViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
//#define MMATERIALTYPELOGO  0x1
//#define MBUSINESSTYPECONSUMPTIONRATIO  0x2
//
//@property (nonatomic, assign) NSInteger updateMMaterialTypeMask;
@property (nonatomic, retain) NSMutableDictionary *material;
//@property (nonatomic, retain) NSMutableDictionary *business;
//@property (nonatomic, retain) NSMutableDictionary *flow;


@end
