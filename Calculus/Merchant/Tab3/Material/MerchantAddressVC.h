//
//  MerchantAddressVC.h
//  Calculus
//
//  Created by ben on 15/12/26.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MerchantAddressVC : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>
@property (nonatomic ,strong) NSString *merchantAddress;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@end
