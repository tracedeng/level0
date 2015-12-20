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
@end
