//
//  MyAwardTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

/*
 1 判断登录
 2 未登录
    2.1 cache中有积分列表，展示
    2.2 cache中没有积分列表，展示缺省
 3 已经登录
    3.1 网络状况良好，拉取用户所有积分
    3.2 网络状况差或者无网络
        3.2.1 cache中有积分列表，展示
        3.2.2 cache中没有积分列表，不展示缺省
        3.2.3 无网络则提示，网络差依旧发起网络请求
 4 监听登录状态发生变化，执行相应的动作
 */

#import "MyAwardTVC.h"
#import "MyAwardCell.h"
#import "ActionCredit.h"
#import "SVProgressHUD.h"
#import "MyOneAwardTVC.h"
#import "MJRefresh.h"
#import "XHToast.h"

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height

@interface MyAwardTVC ()
@property (nonatomic, retain) NSMutableArray *creditList;
@property (nonatomic, assign) NSInteger checkedRow;
@property (nonatomic, retain) IBOutlet UIImageView *defaultimage;



@end

@implementation MyAwardTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultimage = [[UIImageView alloc] init];
    self.defaultimage.image=[UIImage imageNamed:@"nocreditlogo"];
    self.defaultimage.frame=CGRectMake( deviceWidth *1/8, (deviceHeight - deviceWidth *3/4) / 4,  deviceWidth *3/4, deviceWidth *3/4 );
    [self.view addSubview:self.defaultimage];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.creditList = [[NSMutableArray alloc] init];
    
    //下拉刷新，上拉加载
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(loadCreditList:)];
//    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(loadCreditList:)];

//    [self.refreshControl addTarget:self action:@selector(loadCreditList:) forControlEvents:UIControlEventValueChanged];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [self loadCreditList:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 提供一个重新获取积分列表的机会
    if ([self.creditList count] == 0) {
        [self loadCreditList:nil];
    }
}

- (void)loadCreditList:(id)sender {
    ActionCredit *credit = [[ActionCredit alloc] init];
    credit.afterConsumerQueryAllCredit = ^(NSArray *creditList) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleAwardView" object:nil userInfo:@{@"award": ([creditList count] == 0) ? @"noaward" : @"award"}];
        
        [self.creditList removeAllObjects];
        [self.creditList addObjectsFromArray:creditList];
        [self.tableView reloadData];
//        if ([self.refreshControl isRefreshing]) {
//            [self.refreshControl endRefreshing];
//        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        
        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];

        if ([creditList count] == 0) {
            
            self.defaultimage.hidden = NO;
            
        }else{
            self.defaultimage.hidden = YES;
        }
        
    };
    credit.afterConsumerQueryAllCreditFailed = ^(NSString *message) {
//        if ([self.refreshControl isRefreshing]) {
//            [self.refreshControl endRefreshing];
//        }
//        
        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
        
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示

    };
    credit.afterConsumerQueryAllCreditFailedNetConnect = ^(NSString *message) {
        //错误提示
        
        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
        
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }

        [XHToast showCenterWithText:@"网络不可用，无法与服务器通讯，请检查移动数据网络或WIFI是否开启" duration:3.0];
    };
    
    [credit doConsumerQueryAllCredit];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.creditList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAwardCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.awardInfo = [self.creditList objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.checkedRow = indexPath.row;
    [self performSegueWithIdentifier:@"OneAward" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"OneAward"]) {
        if ([segue.destinationViewController isKindOfClass:[MyOneAwardTVC class]]) {
            MyOneAwardTVC *destination = (MyOneAwardTVC *)segue.destinationViewController;
            destination.merchant = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"i"];
            destination.name = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"t"];
            destination.logo = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"l"];
        }
    }
}


@end
