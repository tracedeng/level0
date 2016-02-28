//
//  BuyDiscountCell.m
//  Calculus
//
//  Created by tracedeng on 16/1/4.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "BuyDiscountCell.h"
#import "ClickableImageView.h"


@interface BuyDiscountCell ()
@property (weak, nonatomic) IBOutlet UILabel *creditDueLBL;
@property (weak, nonatomic) IBOutlet UILabel *creditAmountLBL;
@property (weak, nonatomic) IBOutlet ClickableImageView *checkImageView;

@property (nonatomic, assign) BOOL checked;     // toggle时上一个状态
@property (nonatomic, retain) UIImage *checkedImage;
@property (nonatomic, retain) UIImage *uncheckedImage;

@property (nonatomic, assign) NSInteger upperQuantity;  // 当前cell可使用最大积分量
@property (nonatomic, assign) NSInteger effectUpperQuantity;  // 当前cell可使用的有效最大积分量(>=upperQuantity)
@property (nonatomic, assign) NSInteger lastQuantity;  // 当前cell积分量记录
@end


@implementation BuyDiscountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
    if (awardInfo) {
        _awardInfo = awardInfo;
        self.upperQuantity = [[awardInfo objectForKey:@"am"] integerValue];
        self.creditTextField.delegate = self;
        self.checkedImage = [UIImage imageNamed:@"icon-radio-checked"];
        self.uncheckedImage = [UIImage imageNamed:@"icon-radio"];
        
        self.creditDueLBL.text = [[awardInfo objectForKey:@"et"] substringToIndex:10];
        self.creditAmountLBL.text = [[awardInfo objectForKey:@"am"] stringValue];
        self.checkImageView.afterClickImageView = ^(id sender) {
            if (self.afterToggleAction) {
                self.afterToggleAction(self.checked, [self.tableView indexPathForCell:self]);
            }
            if (self.currentNeedQuantity) {
                NSInteger quantity = self.checked ? -[self.creditTextField.text integerValue] : 0;
                self.effectUpperQuantity = self.currentNeedQuantity(quantity);
                if (!self.checked) {
                    if (self.effectUpperQuantity > self.upperQuantity) {
                        self.effectUpperQuantity = self.upperQuantity;
                    }
                    if (self.effectUpperQuantity == 0) {
                        //
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"abc" message:@"def" preferredStyle:UIAlertControllerStyleActionSheet];
//                        [alert addAction:[UIAlertAction actionWithTitle:@"ljk" style:UIAlertActionStyleDefault handler:nil]];
//                        [self presentViewController:alert animated:YES completion:nil];
                        return ;
                    }else{
                        self.creditTextField.text =[NSString stringWithFormat:@"%ld", self.effectUpperQuantity];
                        self.currentNeedQuantity(self.effectUpperQuantity);
                    }
                }
            }
            [self toggle];
        };
    }
}

// toggle 选择状态
- (void)toggle {
    self.checkImageView.image = self.checked ? self.uncheckedImage : self.checkedImage;
    self.creditTextField.hidden = self.checked ? YES : NO;
    self.checked = !self.checked;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.currentNeedQuantity) {
        // 开始编辑积分量时，计算本cell能使用的积分上限
        self.effectUpperQuantity = [self.creditTextField.text integerValue] + self.currentNeedQuantity(0);
        if (self.effectUpperQuantity > self.upperQuantity) {
            self.effectUpperQuantity = self.upperQuantity;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0){
        // 按退格键，更新已选积分总量
        NSInteger lastQuantity = [self.creditTextField.text integerValue];
        NSInteger quantity = lastQuantity / 10;
        if (self.currentNeedQuantity) {
            self.currentNeedQuantity(quantity - lastQuantity);
        }
//        if (0 == quantity) {
//            self.creditTextField.text = @"0";
//            [self toggle];
//        }
        
        return YES;     //支持已经输满长度按退格键删除
    }
    // 必须是数字，且第一个数字不能是0
    if ((textField.text.length == 0) && [string isEqualToString:@"0"]) {
        return NO;
    }
    
    NSInteger lastQuantity = [self.creditTextField.text integerValue];
    NSInteger quantity = [[self.creditTextField.text stringByAppendingString:string] integerValue];
    if (textField == self.creditTextField) {
        // 输入超过拥有的积分上限
        if (quantity > self.effectUpperQuantity) {
            return NO;
        }
    }
    
    // 当前cell积分增加，更新已选积分总量
    if (self.currentNeedQuantity) {
        self.currentNeedQuantity(quantity - lastQuantity);
    }
    
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
////    NSString *credit = [self.creditTextField.text stringByAppendingString:string];
//    
//    DLog(@"end editing");
//}
@end
