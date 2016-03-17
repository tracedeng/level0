//
//  ApplyCreditTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/20.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ApplyCreditTVC.h"
#import "ActionMMaterial.h"
#import "ClickableImageView.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"

@interface ApplyCreditTVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet ClickableImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;

@end

@implementation ApplyCreditTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 圆角
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height / 2.0;
    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [self.material objectForKey:@"logo"]];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
    self.nameLabel.text = [self.material objectForKey:@"n"];
    
    if (self.money) {
        self.moneyField.text = [NSString stringWithFormat:@"%0.0f", self.money];
    }else{
        [self.moneyField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }
    return 0.0f;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0){
        // 按退格键，更新消费金额量
        NSString *money = (textField.text.length == 1) ? @"0" : [textField.text substringWithRange:NSMakeRange(0, textField.text.length -1)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateApplyMoney" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:money, @"money", nil]];

        return YES;     //支持已经输满长度按退格键删除
    }
    
    // 必须是数字，且第一个数字不能是0
    if ((textField.text.length == 0) && [string isEqualToString:@"0"]) {
        return NO;
    }

    if (textField == self.moneyField) {
        // 输入金额最大
        if (textField.text.length > 5) {
            return NO;
        }
        NSString *money = [self.moneyField.text stringByAppendingString:string];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateApplyMoney" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:money, @"money", nil]];
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
