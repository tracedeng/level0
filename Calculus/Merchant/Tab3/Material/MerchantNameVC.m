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
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation MerchantNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.merchantNameTXT.text = self.merchantName;
//    self.merchantNameTXT.delegate = self;

    self.contentTextView.text = self.merchantName;
    if (self.merchantName.length) {
        self.placeholderLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"unwindUpdateMMeterialMerchantName"]){
        self.merchantName = self.contentTextView.text;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) return YES;     //支持已经输满长度按退格键删除
    
    if (textView.text.length > 32) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.saveButton.enabled = NO;
        self.placeholderLabel.text = @"商户名称";
        //        self.canSub21mitMask &= 0xfb;
        //        [textView resignFirstResponder];
    }else{
        self.saveButton.enabled = [self.merchantName isEqualToString:self.contentTextView.text] ? NO : YES;
        self.placeholderLabel.text = @"";
        
        //        self.canSubmitMask |= 0x4;
    }
}


@end
