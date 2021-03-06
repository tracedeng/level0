//
//  ExchangeRateTVC.m
//  Calculus
//
//  Created by tracedeng on 16/2/23.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ExchangeRateTVC.h"
#import "ActionCredit.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"
#import "XHToast.h"


@interface ExchangeRateTVC ()
//@property (weak, nonatomic) IBOutlet UIView *sourceCreditView;
//@property (weak, nonatomic) IBOutlet UIView *destCreditView;
//@property (weak, nonatomic) IBOutlet UIView *feeView;
@property (weak, nonatomic) IBOutlet UILabel *merchantOutCredit;
@property (weak, nonatomic) IBOutlet UIImageView *merchantOutImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantOutName;
@property (weak, nonatomic) IBOutlet UIImageView *merchantInImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantInName;
@property (weak, nonatomic) IBOutlet UILabel *merchantInCredit;
@property (weak, nonatomic) IBOutlet UILabel *feeCredit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *interchangeButton;

- (IBAction)interchangeAction:(id)sender;
@end

@implementation ExchangeRateTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 导出商家logo，名称，积分量
    self.merchantOutImageView.clipsToBounds = YES;
    self.merchantOutImageView.layer.cornerRadius = 4.0f;
//    self.merchantOutImageView.layer.cornerRadius = self.merchantOutImageView.frame.size.height / 2.0f;
    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [self.merchantOut objectForKey:@"logo"]];
    [self.merchantOutImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
    
    self.merchantOutName.text = [self.merchantOut objectForKey:@"name"];
//    self.merchantOutCredit.text = [[self.merchantOut objectForKey:@"quantity"] stringValue];
    self.merchantOutCredit.text = [NSString stringWithFormat:@"转出%ld", [[self.merchantOut objectForKey:@"quantity"] integerValue]];

    // 导入商家logo，名称
    self.merchantInImageView.clipsToBounds = YES;
    self.merchantInImageView.layer.cornerRadius = 4.0f;
//    self.merchantInImageView.layer.cornerRadius = self.merchantInImageView.frame.size.height / 2.0f;
    NSString *path2 = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [self.merchantIn objectForKey:@"logo"]];
    [self.merchantInImageView sd_setImageWithURL:[NSURL URLWithString:path2] placeholderImage:nil];
    
    self.merchantInName.text = [self.merchantIn objectForKey:@"name"];
    
    // 后台计算导入积分量，手续费
    ActionCredit *action = [[ActionCredit alloc] init];
    action.afterCreditInterchange = ^(NSInteger quantity, NSInteger fee) {
        self.merchantInCredit.text = [NSString stringWithFormat:@"转入%ld", quantity];
        self.feeCredit.text = [NSString stringWithFormat:@"%ld", fee];
//        UITableViewCell *feeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//        feeCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", fee];
//        feeCell.textLabel.text = [NSString stringWithFormat:@"%ld", fee];
        self.interchangeButton.enabled = YES;
    };
    action.afterCreditInterchangeFailed = ^(NSString *message) {
        // 计算互换比例失败，提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"计算互换比率失败，请联系平台" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    action.afterCreditInterchangeFailedNetConnect = ^(NSString *message) {
        // 计算互换比例失败，提示
        [XHToast showCenterWithText:@"网络不可用，无法与服务器通讯，请检查移动数据网络或WIFI是否开启" duration:3.0];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"计算互换比率失败，请联系平台" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };

    [action doCreditInterchange:[self.merchantOut objectForKey:@"cIdentity"] from_merchant:[self.merchantOut objectForKey:@"mIdentity"] quantity:[[self.merchantOut objectForKey:@"quantity"] integerValue] to_merchant:[self.merchantIn objectForKey:@"identity"] exec_exchange:NO];
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
    NSInteger row = 0;
    if (section == 0) {
        row = 2;
    }else if (section == 1) {
        row = 1;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 100.0f;
    }
    return 44.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
*/

- (IBAction)interchangeAction:(id)sender {
    ActionCredit *action = [[ActionCredit alloc] init];
    action.afterCreditInterchange = ^(NSInteger quantity, NSInteger fee) {
        NSString *notice = [NSString stringWithFormat:@"%@(%@) => %@(%@)", [self.merchantOut objectForKey:@"name"], self.merchantOutCredit.text, [self.merchantIn objectForKey:@"name"], self.merchantInCredit.text];
//        NSString *notice = [NSString stringWithFormat:@"%@(%@) => %@(%@)", [self.merchantOut objectForKey:@"name"], [[self.merchantOut objectForKey:@"quantity"] stringValue], [self.merchantIn objectForKey:@"name"], self.merchantInCredit.text];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"兑换成功" message:notice preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"afterInterchange" object:self];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    action.afterCreditInterchangeFailed = ^(NSString *message) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"兑换失败，点击确定重新尝试" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    [action doCreditInterchange:[self.merchantOut objectForKey:@"cIdentity"] from_merchant:[self.merchantOut objectForKey:@"mIdentity"] quantity:[[self.merchantOut objectForKey:@"quantity"] integerValue] to_merchant:[self.merchantIn objectForKey:@"identity"] exec_exchange:YES];
}

@end
