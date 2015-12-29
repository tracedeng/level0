//
//  MerchantEmailVC.m
//  Calculus
//
//  Created by ben on 15/12/26.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantEmailVC.h"
#import "ActionMMaterial.h"
#import "MMaterialTVC.h"

@interface MerchantEmailVC ()
@property (weak, nonatomic) IBOutlet UITextField *merchantEmailTXT;

@end

@implementation MerchantEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.merchantEmailTXT.text = self.merchantEmail;
    self.merchantEmailTXT.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //TODO 判断各种按键是否正常
    if (string.length == 0){
        self.merchantEmail = [self.merchantEmailTXT.text substringToIndex:[self.merchantEmailTXT.text length] -1];
        return YES;     //支持已经输满长度按退格键删除
    }
    if (textField == self.merchantEmailTXT) {
        if (textField.text.length > 15) {
            return NO;
        }
    }
    self.merchantEmail = [self.merchantEmailTXT.text stringByAppendingString:string];
    return YES;
}


@end
