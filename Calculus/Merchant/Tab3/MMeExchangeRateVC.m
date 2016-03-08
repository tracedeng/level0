//
//  MMeExchangeRateVC.m
//  Calculus
//
//  Created by ben on 15/12/28.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MMeExchangeRateVC.h"

@interface MMeExchangeRateVC ()
@property (weak, nonatomic) IBOutlet UITextField *exchangeRateTXT;
@property (weak, nonatomic) IBOutlet UITextView *consumptionRateTextView;
@property (weak, nonatomic) IBOutlet UILabel *ratePlaceHolderLBL;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBTN;

@end

@implementation MMeExchangeRateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.exchangeRateTXT.text = self.exchangeRate;
//    self.exchangeRateTXT.delegate = self;

    self.consumptionRateTextView.text = self.exchangeRate;
    if (self.exchangeRate.length) {
        self.ratePlaceHolderLBL.text = @"";
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    //TODO 判断各种按键是否正常
//    if (string.length == 0){
//        self.exchangeRate = [self.exchangeRateTXT.text substringToIndex:[self.exchangeRateTXT.text length] -1];
//        return YES;     //支持已经输满长度按退格键删除
//    }
//    if (textField == self.exchangeRateTXT) {
//        if (textField.text.length > 15) {
//            return NO;
//        }
//    }
//    self.exchangeRate = [self.exchangeRateTXT.text stringByAppendingString:string];
//    return YES;
//}
//


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"unwindUpdateMExchangeRate"]){
        self.exchangeRate = self.consumptionRateTextView.text;
    }
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) return YES;     //支持已经输满长度按退格键删除
    
    if (textView.text.length > 5) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.saveBTN.enabled = NO;
        self.ratePlaceHolderLBL.text = @"元";
    }else{
        self.saveBTN.enabled = [self.exchangeRate isEqualToString:self.consumptionRateTextView.text] ? NO : YES;
        self.ratePlaceHolderLBL.text = @"";
    }
}


@end
