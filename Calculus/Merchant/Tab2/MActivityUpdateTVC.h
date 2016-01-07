//
//  MActivityUpdateTVC.h
//  Calculus
//
//  Created by ben on 16/1/5.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MActivityUpdateTVC : UITableViewController<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, retain) NSMutableDictionary *activity;
@property (nonatomic ,strong) NSString *atitle;
@property (nonatomic ,strong) NSString *aintroduce;
@property (nonatomic ,strong) NSString *aposter;
@property (nonatomic ,strong) NSString *acredit;
@property (nonatomic ,strong) NSString *aexpire_time;
@property (nonatomic ,strong) NSString *id;


@end
