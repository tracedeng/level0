//
//  COneAwardTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "COneAwardTVC.h"
#import "SVProgressHUD.h"
#import "ActionMCredit.h"
#import "COneAwardCell.h"
#import "XHToast.h"

@interface COneAwardTVC ()
@property (nonatomic, retain) NSMutableArray *creditList;
@end

@implementation COneAwardTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = self.nickname;
    
    self.creditList = [[NSMutableArray alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(loadCreditList:) forControlEvents:UIControlEventValueChanged];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [self loadCreditList:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCreditList:(id)sender {
    ActionMCredit *credit = [[ActionMCredit alloc] init];
    credit.afterQueryOneConsumerCredit = ^(NSArray *creditList) {
        [self.creditList removeAllObjects];
        if (creditList.count) {
            [self.creditList addObjectsFromArray:creditList];
        }
        [self.tableView reloadData];
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
    };
    credit.afterQueryOneConsumerCreditFailed = ^(NSString *message) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示
    };
    credit.afterQueryOneConsumerCreditFailedNetConnect = ^(NSString *message) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        [XHToast showCenterWithText:@"网络不可用，无法与服务器通讯，请检查移动数据网络或WIFI是否开启" duration:3.0];
    };


    [credit doQueryOneConsumerCredit:self.numbers];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.creditList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    COneAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"COneAwardCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.awardInfo = [self.creditList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

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

@end
