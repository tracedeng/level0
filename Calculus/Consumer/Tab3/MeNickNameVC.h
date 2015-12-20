//
//  MeNickNameVC.h
//  Calculus
//
//  Created by ben on 15/12/20.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeNickNameVC : UIViewController<UITextFieldDelegate>
@property (nonatomic ,strong) NSString *nickName;
@property (nonatomic, retain) NSMutableDictionary *material;


@end
