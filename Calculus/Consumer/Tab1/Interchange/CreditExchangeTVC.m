//
//  CreditExchangeTVC.m
//  Calculus
//
//  Created by ben on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "CreditExchangeTVC.h"
#import "ActionCredit.h"
#import "SVProgressHUD.h"
#import "CreditExchangeCell.h"
#import "MerchantSelectTVC.h"


@interface CreditExchangeTVC ()
@property (nonatomic, retain) NSMutableArray *creditList;
@property (nonatomic, retain) NSIndexPath *lastCheckedIndex;  //nil表示没有cell被选中

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextstep;
@end

@implementation CreditExchangeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"积分汇率";
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
    credit.afterConsumerQueryOtherCreditList = ^(NSArray *creditList) {
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
    credit.afterConsumerQueryOtherCreditListFailed = ^(NSString *message) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示
    };
    [credit doConsumerQueryOtherCreditList:self.merchant];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.creditList count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.creditList objectAtIndex:section] objectForKey:@"cr"] count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.creditList objectAtIndex:section] objectForKey:@"t"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditExchangeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.awardInfo = [[[self.creditList objectAtIndex:indexPath.section] objectForKey:@"cr"] objectAtIndex:indexPath.row];
    cell.tableView = tableView;
    
    __block CreditExchangeCell *_cell = cell;
    cell.afterToggleAction = ^(BOOL checked, NSIndexPath *indexPath) {
        if (self.lastCheckedIndex == indexPath) {
            //toggle同一cell
            self.lastCheckedIndex = !checked ? indexPath : nil;
            [_cell toggle];
            self.nextstep.enabled = !checked ? YES : NO;
        }else{
            //toggle上一次选择的row
            if (self.lastCheckedIndex) {
                CreditExchangeCell *lastCell = (CreditExchangeCell *)[tableView cellForRowAtIndexPath:self.lastCheckedIndex];
                [lastCell toggle];
            }
            self.lastCheckedIndex = indexPath;
            [_cell toggle];
            self.nextstep.enabled = YES;
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

//必须，否则第二个section head上面包含footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    CreditExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditExchangeCell" forIndexPath:indexPath];
//    cell.awardInfo = [[[self.creditList objectAtIndex:indexPath.section] objectForKey:@"cr"] objectAtIndex:indexPath.row];
//    
//}


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
    if ([segue.identifier isEqualToString:@"ChooseMerchantIn"]) {
        if ([segue.destinationViewController isKindOfClass:[MerchantSelectTVC class]]) {
            MerchantSelectTVC *destination = (MerchantSelectTVC *)segue.destinationViewController;
            NSDictionary *oneMCredit =[self.creditList objectAtIndex:self.lastCheckedIndex.section];
            NSDictionary *oneCredit = [[oneMCredit objectForKey:@"cr"] objectAtIndex:self.lastCheckedIndex.row];
            destination.merchantOut = @{@"name": [oneMCredit objectForKey:@"t"], @"logo": [oneMCredit objectForKey:@"l"], @"mIdentity": [oneMCredit objectForKey:@"i"], @"cIdentity": [oneCredit objectForKey:@"id"], @"quantity": [oneCredit objectForKey:@"qu"], @"expire": [oneCredit objectForKey:@"et"]};
        }
    }
}


@end
