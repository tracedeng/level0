//
//  MActivityCreateTVC.h
//  Calculus
//
//  Created by ben on 16/1/4.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MActivityCreateTVC : UITableViewController<UITextFieldDelegate,UITextViewDelegate>
//@property (nonatomic ,strong) NSString *atitle;
//@property (nonatomic ,strong) NSString *aintroduce;
//@property (nonatomic ,strong) NSString *aposter;
//@property (nonatomic ,strong) NSString *acredit;
//@property (nonatomic ,strong) NSString *aexpire_time;
@property (nonatomic, assign) BOOL bUpdateActivity;     // 更新还是新增
@property (nonatomic, retain) NSDictionary *activityInfo;
@end
