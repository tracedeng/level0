//
//  MerchantAddressVC.m
//  Calculus
//
//  Created by ben on 15/12/26.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantAddressVC.h"
#import "ActionMMaterial.h"
#import "MMaterialTVC.h"

@interface MerchantAddressVC ()
@property (weak, nonatomic) IBOutlet UITextField *merchantAddressTXT;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation MerchantAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.merchantAddressTXT.text = self.merchantAddress;
//    self.merchantAddressTXT.delegate = self;
    self.contentTextView.text = self.merchantAddress;
    if (self.self.merchantAddress.length) {
        self.placeholderLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"unwindUpdateMMeterialMerchantAddress"]){
        self.merchantAddress = self.contentTextView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) return YES;     //支持已经输满长度按退格键删除
    
    if (textView.text.length > 50) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.saveButton.enabled = NO;
        self.placeholderLabel.text = @"商户地址";
        //        self.canSub21mitMask &= 0xfb;
        //        [textView resignFirstResponder];
    }else{
        self.saveButton.enabled = [self.merchantAddress isEqualToString:self.contentTextView.text] ? NO : YES;
        self.placeholderLabel.text = @"";
        
        //        self.canSubmitMask |= 0x4;
    }
}



@end
