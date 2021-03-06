//
//  DiscountTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "DiscountTVC.h"
#import "DiscountCell.h"
#import "DiscountIntroduceController.h"
#import "ActionDiscount.h"
#import "SVProgressHUD.h"
#import "DiscountDetailsTVC.h"
#import "MJRefresh.h"
#import "XHToast.h"

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height

@interface DiscountTVC ()
@property (nonatomic, retain) NSMutableArray *discountList;
@property (nonatomic, retain) NSIndexPath *checkedIndexPath;
@property (nonatomic, retain) IBOutlet UIImageView *defaultimage;

@property (nonatomic, retain) NSString *mark;   // 每次上拉刷新时间戳
@end

@implementation DiscountTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultimage = [[UIImageView alloc] init];
    self.defaultimage.image=[UIImage imageNamed:@"cuactivity-empty"];
    self.defaultimage.frame=CGRectMake( deviceWidth *1/8, (deviceHeight - deviceWidth *3/4) / 4,  deviceWidth *3/4, deviceWidth *3/4 );
    [self.view addSubview:self.defaultimage];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"活动";
    self.mark = @"";
    
    self.discountList = [[NSMutableArray alloc] init];
    
//    [self.refreshControl addTarget:self action:@selector(loaddiscountList:) forControlEvents:UIControlEventValueChanged];
    //下拉刷新，上拉加载
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(loaddiscountList:)];
    //    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(loaddiscountListUp:)];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [self loaddiscountList:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loaddiscountList:(id)sender {
    ActionDiscount *discount = [[ActionDiscount alloc] init];
    discount.afterConsumerQueryDiscount = ^(NSArray *discountList) {
        [self.discountList removeAllObjects];
        [self.discountList addObjectsFromArray:discountList];
        [self.tableView reloadData];
//        if ([self.refreshControl isRefreshing]) {
//            [self.refreshControl endRefreshing];
//        }
        
        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
        

        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        if ( [discountList count] == 0) {
            
            self.defaultimage.hidden = NO;
            
        }else{
            self.defaultimage.hidden = YES;
            
            self.mark = [[discountList lastObject] objectForKey:@"ct"];
        }
    };
    discount.afterConsumerQueryDiscountFailed = ^(NSString *message) {
//        if ([self.refreshControl isRefreshing]) {
//            [self.refreshControl endRefreshing];
//        }
        
        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
        

        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示
    };
    discount.afterConsumerQueryDiscountFailedNetConnect = ^(NSString *message) {
        
        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
        
        
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        [XHToast showCenterWithText:@"网络不可用，无法与服务器通讯，请检查移动数据网络或WIFI是否开启" duration:3.0];

    };

    [discount doConsumerQueryDiscount:@""];
}

- (void)loaddiscountListUp:(id)sender {
    ActionDiscount *discount = [[ActionDiscount alloc] init];
    discount.afterConsumerQueryDiscount = ^(NSArray *discountList) {
//        [self.discountList removeAllObjects];
        [self.discountList addObjectsFromArray:discountList];
        [self.tableView reloadData];
        //        if ([self.refreshControl isRefreshing]) {
        //            [self.refreshControl endRefreshing];
        //        }
        
//        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        if ( [discountList count] == 0) {
            
//            self.defaultimage.hidden = NO;
            
        }else{
            self.defaultimage.hidden = YES;
            
            self.mark = [[discountList lastObject] objectForKey:@"ct"];
        }
    };
    discount.afterConsumerQueryDiscountFailed = ^(NSString *message) {
        //        if ([self.refreshControl isRefreshing]) {
        //            [self.refreshControl endRefreshing];
        //        }
        
//        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示
    };
    discount.afterConsumerQueryDiscountFailedNetConnect = ^(NSString *message) {
        
//        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        [XHToast showCenterWithText:@"网络不可用，无法与服务器通讯，请检查移动数据网络或WIFI是否开启" duration:3.0];
        
    };
    
    [discount doConsumerQueryDiscount:self.mark];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.discountList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscountCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.discountInfo = [self.discountList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.01f;
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 8.01f;
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.checkedIndexPath = indexPath;
    return indexPath;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.checkedIndexPath = indexPath;
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
    if ([segue.identifier isEqualToString:@"DiscountIntroduce"]) {
        if ([segue.destinationViewController isKindOfClass:[DiscountIntroduceController class]]) {
            DiscountIntroduceController *destination = (DiscountIntroduceController *)segue.destinationViewController;
            destination.discountInfo = [self.discountList objectAtIndex:self.checkedIndexPath.row];
        }
    }else  if ([segue.identifier isEqualToString:@"DiscountDetails"]) {
        if ([segue.destinationViewController isKindOfClass:[DiscountDetailsTVC class]]) {
            DiscountDetailsTVC *destination = (DiscountDetailsTVC *)segue.destinationViewController;
            destination.discountInfo = [self.discountList objectAtIndex:self.checkedIndexPath.row];
        }
    }

        
        
}


@end
