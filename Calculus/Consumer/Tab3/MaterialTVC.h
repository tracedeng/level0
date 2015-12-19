//
//  MaterialTVC.h
//  Calculus
//
//  Created by tracedeng on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialTVC : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate>

#define MATERIALTYPEAVATAR  0x1
#define MATERIALTYPENICKNAME  0x2
#define MATERIALTYPEGENDER  0x4

@property (nonatomic, assign) NSInteger updateMaterialTypeMask;
@property (nonatomic, retain) NSMutableDictionary *material;
@property (nonatomic ,strong) UIPickerView *cityPicker;
@property (nonatomic ,strong) UILabel *cityLabel;
@property (nonatomic ,strong) UILabel *selectok;
@property (nonatomic ,strong) UILabel *selectcancel;

@end
