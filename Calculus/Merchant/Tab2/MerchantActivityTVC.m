//
//  MerchantActivityTVC.m
//  Calculus
//
//  Created by ben on 16/1/7.
//  Copyright © 2016年 tracedeng. All rights reserved.
//



#import "MerchantActivityTVC.h"
#import "MActivityCell.h"
#import "ActionMActivity.h"
#import "MMaterialManager.h"
#import "MActivityCreateTVC.h"
#import "SVProgressHUD.h"


@interface MerchantActivityTVC ()
@property (nonatomic, retain) NSMutableArray *activityList;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@end

@implementation MerchantActivityTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityList = [[NSMutableArray alloc] init];
    self.material = [MMaterialManager getMaterial];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewActivity:) name:@"refreshNewActivity" object:nil];
    
    [self.refreshControl addTarget:self action:@selector(loadActivityList:) forControlEvents:UIControlEventValueChanged];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [self loadActivityList:nil];
}

- (void)loadActivityList:(id)sender {
    ActionMActivity *activity = [[ActionMActivity alloc] init];
    activity.afterQueryMerchantActivity = ^(NSArray *activityList) {
        [self.activityList removeAllObjects];
        if (activityList.count) {
            [self.activityList addObjectsFromArray:activityList];
        }
        [self.tableView reloadData];
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
    };
    activity.afterQueryMerchantActivityFailed = ^(NSString *message) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示
    };
    [activity doQueryMerchantActivity:[self.material objectForKey:@"id"]];
    
}

// 新增活动后刷新
- (void)refreshNewActivity:(NSNotification *)notification {
    NSDictionary *activity = [notification userInfo];
    NSString *mode = [activity objectForKey:@"mode"];
    
    if ([mode isEqualToString:@"create"]) {
        [self.activityList insertObject:activity atIndex:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }else if([mode isEqualToString:@"update"]){
        [self.activityList replaceObjectAtIndex:self.selectedIndexPath.row withObject:activity];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.activityList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MActivityCell" forIndexPath:indexPath];

    // Configure the cell...
    cell.activityInfo = [self.activityList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    return indexPath;
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
    if([segue.identifier isEqualToString:@"CreateActivity"]){
        if ([segue.destinationViewController isKindOfClass:[MActivityCreateTVC class]]) {
            MActivityCreateTVC *destination = (MActivityCreateTVC *)segue.destinationViewController;
            destination.bUpdateActivity = NO;
        }
    } else if([segue.identifier isEqualToString:@"UpdateActivity"]){
        if ([segue.destinationViewController isKindOfClass:[MActivityCreateTVC class]]) {
            MActivityCreateTVC *destination = (MActivityCreateTVC *)segue.destinationViewController;
            destination.bUpdateActivity = YES;
            destination.activityInfo = [self.activityList objectAtIndex:self.selectedIndexPath.row];
        }
    }
}

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

@end
