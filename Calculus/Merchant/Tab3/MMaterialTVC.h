//
//  MMaterialTVC.h
//  Calculus
//
//  Created by tracedeng on 15/12/19.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMaterialTVC : UITableViewController
#define MMATERIALTYPELOGO  0x1
#define MMATERIALTYPENAME  0x2
#define MMATERIALTYPEQRCODE  0x4
#define MMATERIALTYPECONTRACT  0x8
#define MMATERIALTYPEEMAIL  0x10
#define MMATERIALTYPELOCATION  0x20

@property (nonatomic, assign) NSInteger updateMMaterialTypeMask;
@property (nonatomic, retain) NSMutableDictionary *material;
@end
