//
//  MeNickNameVC.m
//  Calculus
//
//  Created by ben on 15/12/20.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MeNickNameVC.h"
#import "ActionMaterial.h"
#import "MaterialTVC.h"

@interface MeNickNameVC()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTXT;
@property (weak, nonatomic) IBOutlet UITextView *nickNameTextView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLBL;

- (IBAction)doUpdateNickName:(UIBarButtonItem *)sender;

@end
@implementation MeNickNameVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.nickNameTXT.text = self.nickName;
    self.nickNameTXT.delegate = self;
    self.nickNameTextView.text = self.nickName;
    
    if (self.nickName.length == 0 ) {
        //
    }else{
        self.nickNameLBL.text = @"";
    }
    
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;     //支持已经输满长度按退格键删除
    if (textField == self.nickNameTXT) {
        if (textField.text.length > 15) {
            return NO;
        }
    }
    self.nickName = [self.nickNameTXT.text stringByAppendingString:string];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doUpdateNickName:(UIBarButtonItem *)sender {
    

}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.nickNameLBL.text = @"请输入昵称";
        //        self.canSub21mitMask &= 0xfb;
        //        [textView resignFirstResponder];
    }else{
        self.nickNameLBL.text = @"";
        //        self.canSubmitMask |= 0x4;
    }
    if (textView.text.length > 15) {
        
        self.nickNameTextView.text = [self.nickNameTextView.text substringToIndex:15];
    }
    self.nickName = self.nickNameTextView.text;

}
@end
