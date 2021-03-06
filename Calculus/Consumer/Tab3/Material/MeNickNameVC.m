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
@property (weak, nonatomic) IBOutlet UITextView *nickNameTextView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLBL;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)doUpdateNickName:(UIBarButtonItem *)sender;
@end

@implementation MeNickNameVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.nickNameTextView.text = self.nickName;
    if (self.nickName.length) {
        self.nickNameLBL.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doUpdateNickName:(UIBarButtonItem *)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ModifyNicknameUnwind"]){
        self.nickName = self.nickNameTextView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) return YES;     //支持已经输满长度按退格键删除

    if (textView.text.length > 15) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.saveButton.enabled = NO;
        self.nickNameLBL.text = @"昵称";
        //        self.canSub21mitMask &= 0xfb;
        //        [textView resignFirstResponder];
    }else{
        self.saveButton.enabled = [self.nickName isEqualToString:self.nickNameTextView.text] ? NO : YES;
        self.nickNameLBL.text = @"";
        //        self.canSubmitMask |= 0x4;
    }
}
@end
