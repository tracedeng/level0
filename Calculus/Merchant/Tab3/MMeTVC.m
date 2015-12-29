//
//  MMeTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/19.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MMeTVC.h"
#import "MMeExchangeRateVC.h"
#import "ActionMMaterial.h"

@interface MMeTVC ()
#define MMATERIALEXCHANGERATE  0x1
@property (weak, nonatomic) IBOutlet UILabel *merchantCreditAmountLBL;
@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLBL;

@end

@implementation MMeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadMerchantInfo];
}
- (void)loadMerchantInfo{
    //TODO 获取最新数据
    self.exchangeRateLBL.text = @"1:1(TODO...)";

//    ActionMMaterial *action = [[ActionMMaterial alloc] init];
//    action.afterModifyMerchantExchangeRate
//    
//    ActionMCredit *credit = [[ActionMCredit alloc] init];
//    credit.afterMerchantQueryApplyCredit = ^(NSArray *creditList) {
//        [self.creditList removeAllObjects];
//        [self.creditList addObjectsFromArray:creditList];
//        [self.tableView reloadData];
//        if ([self.refreshControl isRefreshing]) {
//            [self.refreshControl endRefreshing];
//        }
//        if ([SVProgressHUD isVisible]) {
//            [SVProgressHUD dismiss];
//        }
//    };
//    credit.afterMerchantQueryApplyCreditFailed = ^(NSString *message) {
//        if ([self.refreshControl isRefreshing]) {
//            [self.refreshControl endRefreshing];
//        }
//        if ([SVProgressHUD isVisible]) {
//            [SVProgressHUD dismiss];
//        }
//        //        TODO...错误提示
//    };
//    [credit doMerchantQueryApplyCredit];
//
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
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 3;
            break;
        case 1:
            rows = 2;
            break;
        case 2:
            rows = 2;
            break;
        case 3:
            rows = 2;
            break;
        default:
            break;
    }
    return rows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
        }else if (1 == indexPath.row) {
            
        }
    }
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

- (IBAction)unwindUpdateMaterial:(UIStoryboardSegue *)segue {
    if([segue.sourceViewController isKindOfClass:[MMeExchangeRateVC class]]){
        MMeExchangeRateVC *merchantvc = (MMeExchangeRateVC *)segue.sourceViewController;
        ActionMMaterial *action = [[ActionMMaterial alloc] init];
        action.afterModifyMerchantExchangeRate = ^(NSDictionary *materail){
            [self.material setObject:merchantvc.exchangeRate forKey:@"er"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            
            self.updateMMaterialTypeMask |= MMATERIALEXCHANGERATE;
        };
        [action doModifyMerchantExchangeRate:merchantvc.exchangeRate merchant:[self.material objectForKey:@"id"]];
        
    }
    
    
    
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
