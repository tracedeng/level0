//
//  MerchantNameVC.m
//  Calculus
//
//  Created by ben on 15/12/25.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantNameVC.h"
#import "ActionMMaterial.h"
#import "MMaterialTVC.h"

@interface MerchantNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *merchantNameTXT;

@end

@implementation MerchantNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.merchantNameTXT.text = self.merchantName;
    self.merchantNameTXT.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //TODO 判断各种按键是否正常
    if (string.length == 0){
        self.merchantName = [self.merchantNameTXT.text substringToIndex:[self.merchantNameTXT.text length] -1];
        return YES;     //支持已经输满长度按退格键删除
    }
    if (textField == self.merchantNameTXT) {
        if (textField.text.length > 15) {
            return NO;
        }
    }
    self.merchantName = [self.merchantNameTXT.text stringByAppendingString:string];
    return YES;
}


@end
