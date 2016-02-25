//
//  MerchantContactNumberVC.m
//  Calculus
//
//  Created by ben on 15/12/26.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantContactNumberVC.h"
#import "ActionMMaterial.h"
#import "MMaterialTVC.h"

@interface MerchantContactNumberVC ()
@property (weak, nonatomic) IBOutlet UITextField *merchantContactNumberTXT;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation MerchantContactNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.merchantContactNumberTXT.text = self.merchantContactNumber;
//    self.merchantContactNumberTXT.delegate = self;
    self.contentTextView.text = self.merchantContactNumber;
    if (self.self.merchantContactNumber.length) {
        self.placeholderLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"unwindUpdateMMeterialMerchantContactNumber"]){
        self.merchantContactNumber = self.contentTextView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) return YES;     //支持已经输满长度按退格键删除
    
    if (textView.text.length > 10) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.saveButton.enabled = NO;
        self.placeholderLabel.text = @"商户联系方式";
        //        self.canSub21mitMask &= 0xfb;
        //        [textView resignFirstResponder];
    }else{
        self.saveButton.enabled = [self.merchantContactNumber isEqualToString:self.contentTextView.text] ? NO : YES;
        self.placeholderLabel.text = @"";
//        self.merchantContactNumber = self.contentTextView.text;

        
        //        self.canSubmitMask |= 0x4;
    }
}




@end
