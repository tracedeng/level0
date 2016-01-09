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
#import "MActivityUpdateTVC.h"
#import "SVProgressHUD.h"


@interface MerchantActivityTVC ()

@property (nonatomic, retain) NSMutableArray *activityList;
@property (nonatomic, retain) NSNumber *selectRowNumber;

@end

@implementation MerchantActivityTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = self.nickname;
    
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
    [self.activityList insertObject:activity atIndex:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
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
    
    cell.activityInfo = [self.activityList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101.0f;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        self.selectRowNumber =[NSNumber numberWithInteger:indexPath.row];
        [self performSegueWithIdentifier:@"goupdateactivity" sender:nil];

    }
}
- (IBAction)unwindUpdateActivity:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[MActivityUpdateTVC class]]){
        MActivityUpdateTVC *activitytvc = (MActivityUpdateTVC *)segue.sourceViewController;
        ActionMActivity *action = [[ActionMActivity alloc] init];
        action.afterUpdateMerchantActivity = ^(NSString *result){
            NSMutableDictionary *newactivity = [NSMutableDictionary dictionaryWithCapacity:6];
            if (activitytvc.atitle && activitytvc.aintroduce && activitytvc.acredit && activitytvc.aposter && activitytvc.aexpire_time) {
                [newactivity setObject:activitytvc.atitle forKey:@"t"];
                [newactivity setObject:activitytvc.aintroduce forKey:@"in"];
                [newactivity setObject:activitytvc.acredit forKey:@"cr"];
                [newactivity setObject:activitytvc.aposter forKey:@"po"];
                [newactivity setObject:activitytvc.aexpire_time forKey:@"et"];
                [newactivity setObject:activitytvc.id forKey:@"id"];
                
            }
            NSMutableArray *showac = [[NSMutableArray alloc] initWithArray:self.activityList];
            [showac removeObjectAtIndex:[self.selectRowNumber integerValue]];
            
            self.activityList = [[NSMutableArray alloc] init];
            self.activityList = showac;
                        
            //            //TODO 更新新的活动内容，本页更新， 可传递过来 ,新增返回内容为id
            //考虑更新后，首页活动列表更新
            [self.tableView reloadData];
        };
        [action doUpdateMerchantActivity:[self.material objectForKey:@"id"] activity:@"id" title:activitytvc.atitle introduce:activitytvc.aintroduce credit:activitytvc.acredit poster:activitytvc.aposter expire_time:activitytvc.aexpire_time];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"gocreateactivity"]){
        //        [segue.destinationViewController setValue:[self.material objectForKey:@"id"] forKey:@"merchant"];
        
    } else if([segue.identifier isEqualToString:@"goupdateactivity"]){
        if ([segue.destinationViewController isKindOfClass:[MActivityUpdateTVC class]]) {
            MActivityUpdateTVC *destination = (MActivityUpdateTVC *)segue.destinationViewController;
            destination.activity = [self.activityList objectAtIndex:[self.selectRowNumber integerValue]];
        }
    }
    
    
}


@end
