//
//  MActivityCreateTVC.m
//  Calculus
//
//  Created by ben on 16/1/4.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MActivityCreateTVC.h"
#import "MActivityExpireVC.h"
#import "MerchantActivityTVC.h"

@interface MActivityCreateTVC ()
@property (weak, nonatomic) IBOutlet UITextField *atittleTXT;
@property (weak, nonatomic) IBOutlet UITextField *acreditTXT;
@property (weak, nonatomic) IBOutlet UILabel *aexpireTXT;
@property (weak, nonatomic) IBOutlet UITextView *adetailsTXT;




@end

@implementation MActivityCreateTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //TODO 选取海报
    self.aposter = @"empty";
    self.atitle = @"empty";
    self.acredit = 0;
    self.aintroduce = @"empty";
    self.aexpire_time = @"empty";
    
    self.atittleTXT.delegate = self;
    self.acreditTXT.delegate = self;
    self.adetailsTXT.delegate = self;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    self.aexpire_time = [dateFormatter stringFromDate:currentDate];
    self.aexpireTXT.text = [dateFormatter stringFromDate:currentDate];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unwindUpdateExpire:(UIStoryboardSegue *)segue {
    if([segue.sourceViewController isKindOfClass:[MActivityExpireVC class]]){
        MActivityExpireVC *activitytvc = (MActivityExpireVC *)segue.sourceViewController;

        self.aexpire_time = activitytvc.aexpire;
        self.aexpireTXT.text = activitytvc.aexpire;
    }
    
    
    
}



//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
//}



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    
//    // Configure the cell...
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//            {
//                //头像，right detail，修改accessory图标
//                        break;
//            }
//            case 1:
//            {
//                //昵称，right detail
//                break;
//            }
//                
//            case 2:
//            {
//            }
//            case 3:
//            {
//            }
//            case 4:
//            {
//                break;
//            }
//            default:
//                break;
//        }
//    }
//    
//    return cell;
//}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //TODO 判断各种按键是否正常
    if (string.length == 0){
        //TODO 退格触发问题无法赋值
        //        textField.text = [textField.text substringToIndex:[textField.text length] -1];
        //self.exchangeRate = [self.exchangeRateTXT.text substringToIndex:[self.exchangeRateTXT.text length] -1];
        return YES;     //支持已经输满长度按退格键删除
    }
    if (textField == self.atittleTXT) {
        if (textField.text.length > 15) {
            return NO;
        }else{
            self.atitle = [self.atittleTXT.text stringByAppendingString:string];

        }
    }else if (textField == self.acreditTXT){
        if (textField.text.length > 15) {
            return NO;
        }else{
            self.acredit = [self.acreditTXT.text stringByAppendingString:string];
            
        }
    }
    return YES;

}

//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    self.adetails = textView.text;
//}
//- (void)textViewDidEndEditing:(UITextView *)textView{
//    self.adetails = textView.text;
//}
-(void)textViewDidChange:(UITextView *)textView{
    self.aintroduce = textView.text;
}





@end
