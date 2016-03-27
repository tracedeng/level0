//
//  MerchantSelectTVC.m
//  Calculus
//
//  Created by ben on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantSelectTVC.h"
#import "ActionMerchant.h"
#import "SVProgressHUD.h"
#import "MerchantSelectCell.h"
#import "InterchangeController.h"
#import "ExchangeRateTVC.h"
#import "XHToast.h"

@interface MerchantSelectTVC ()
@property (nonatomic, retain) NSMutableArray *merchantList;
@property (nonatomic, retain) NSIndexPath *lastCheckedIndex; //nil表示没有cell被选中

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextstep;

@end

@implementation MerchantSelectTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.merchantList = [[NSMutableArray alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(loadMerchantList:) forControlEvents:UIControlEventValueChanged];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [self loadMerchantList:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMerchantList:(id)sender {
    ActionMerchant *merchant = [[ActionMerchant alloc] init];
    merchant.afterConsumerQueryOtherMerchantList = ^(NSArray *merchantList) {
        [self.merchantList removeAllObjects];
        [self.merchantList  addObjectsFromArray:merchantList];
        [self.tableView reloadData];
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
    };
    merchant.afterConsumerQueryOtherMerchantListFailed = ^(NSString *message) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示
    };
    merchant.afterConsumerQueryOtherMerchantListFailedNetConnect = ^(NSString *message) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        [XHToast showCenterWithText:@"网络不可用，无法与服务器通讯，请检查移动数据网络或WIFI是否开启" duration:3.0];

        
    };

//    [merchant doConsumerQueryOtherMerchantList:self.merchant];
    [merchant doQueryExchangInMerchantWithout:self.merchant];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.merchantList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MerchantSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantSelect" forIndexPath:indexPath];

    // Configure the cell...
    cell.merchantInfo = [self.merchantList objectAtIndex:indexPath.row];
    cell.tableView = tableView;
    
    __block MerchantSelectCell *_cell = cell;
    cell.afterToggleAction = ^(BOOL checked, NSIndexPath *indexPath) {
        if (self.lastCheckedIndex == indexPath) {
            //toggle同一cell
            self.lastCheckedIndex = !checked ? indexPath : nil;
            [_cell toggle];
            self.nextstep.enabled = !checked ? YES : NO;
        }else{
            //toggle上一次选择的row
            if (self.lastCheckedIndex) {
                MerchantSelectCell *lastCell = (MerchantSelectCell *)[tableView cellForRowAtIndexPath:self.lastCheckedIndex];
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
    return 0.01f;
}


//TODO ... 分组索引
#pragma mark 返回每组标题索引
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSLog(@"生成组索引");
//    NSMutableArray *indexs=[[NSMutableArray alloc]init];
//    for(KCContactGroup *group in _contacts){
//        [indexs addObject:group.name];
//    }
//    return indexs;
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
//    if ([segue.identifier isEqualToString:@"ShowInterchange"]) {
//        if ([segue.destinationViewController isKindOfClass:[InterchangeController class]]) {
//            InterchangeController *destination = (InterchangeController *)segue.destinationViewController;
//            
//            destination.merchantOut = self.merchantOut;
//            
//            NSDictionary *merchant =[self.merchantList objectAtIndex:self.lastCheckedIndex.row];
//            destination.merchantIn = @{@"name": [merchant objectForKey:@"n"], @"logo": [merchant objectForKey:@"logo"], @"identity": [merchant objectForKey:@"id"]};
//        }
//    }
    if ([segue.identifier isEqualToString:@"ShowInterchange"]) {
        if ([segue.destinationViewController isKindOfClass:[ExchangeRateTVC class]]) {
            ExchangeRateTVC *destination = (ExchangeRateTVC *)segue.destinationViewController;
            
            destination.merchantOut = self.merchantOut;
            
            NSDictionary *merchant =[self.merchantList objectAtIndex:self.lastCheckedIndex.row];
            destination.merchantIn = @{@"name": [merchant objectForKey:@"n"], @"logo": [merchant objectForKey:@"logo"], @"identity": [merchant objectForKey:@"id"]};
        }
    }
}

@end
