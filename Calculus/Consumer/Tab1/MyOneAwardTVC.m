//
//  MyOneAwardTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/20.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MyOneAwardTVC.h"
#import "MyOneAwardCell.h"
#import "ActionCredit.h"
#import "SVProgressHUD.h"
#import "CreditExchangeInTVC.h"


@interface MyOneAwardTVC ()
@property (nonatomic, retain) NSMutableArray *creditList;
@end

@implementation MyOneAwardTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = self.name;
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
    ActionCredit *credit = [[ActionCredit alloc] init];
    credit.afterConsumerQueryOneCredit = ^(NSArray *creditList) {
        [self.creditList removeAllObjects];
        [self.creditList addObjectsFromArray:creditList];
        [self.tableView reloadData];
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
    };
    credit.afterConsumerQueryOneCreditFailed = ^(NSString *message) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示
    };
    [credit doConsumerQueryOneCredit:self.merchant];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.creditList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOneAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOneAwardCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.awardInfo = [self.creditList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
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


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gocreditexchangein"]) {
        if ([segue.destinationViewController isKindOfClass:[CreditExchangeInTVC class]]) {
            CreditExchangeInTVC *destination = (CreditExchangeInTVC *)segue.destinationViewController;
            destination.merchant = self.merchant;
            destination.name = self.name;
            destination.logo = self.logo;
        }
    }
}



@end
