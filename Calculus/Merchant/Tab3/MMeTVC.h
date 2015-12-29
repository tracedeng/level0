//
//  MMeTVC.h
//  Calculus
//
//  Created by tracedeng on 15/12/19.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMeTVC : UITableViewController
#define MMATERIALTYPELOGO  0x1

@property (nonatomic, assign) NSInteger updateMMaterialTypeMask;
@property (nonatomic, retain) NSMutableDictionary *material;
@end
