//
//  MerchantActivityTVC.h
//  Calculus
//
//  Created by ben on 16/1/7.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantActivityTVC : UITableViewController<UITextViewDelegate>
//#define MMATERIALTYPELOGO  0x1
//#define MBUSINESSTYPECONSUMPTIONRATIO  0x2
//
//@property (nonatomic, assign) NSInteger updateMMaterialTypeMask;
@property (nonatomic, retain) NSDictionary *material;
//@property (nonatomic, retain) NSMutableDictionary *business;
//@property (nonatomic, retain) NSMutableDictionary *flow;

@end