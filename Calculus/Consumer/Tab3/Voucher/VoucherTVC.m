//
//  VoucherTVC.m
//  Calculus
//
//  Created by tracedeng on 16/1/8.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "VoucherTVC.h"
#import "VoucherCell.h"
#import "ActionVoucher.h"
#import "VoucherDetailsVC.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height

@interface VoucherTVC ()
@property (nonatomic, retain) NSMutableArray *voucherList;
@property (nonatomic, retain) IBOutlet UIImageView *defaultimage;
@property (nonatomic, assign) NSInteger checkedRow;
@end

@implementation VoucherTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultimage = [[UIImageView alloc] init];
    self.defaultimage.image=[UIImage imageNamed:@"nocoupon"];
    self.defaultimage.frame=CGRectMake( deviceWidth *1/8, (deviceHeight - deviceWidth *3/4) / 4,  deviceWidth *3/4, deviceWidth *3/4 );
    [self.view addSubview:self.defaultimage];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.voucherList = [[NSMutableArray alloc] init];
    
//    [self.refreshControl addTarget:self action:@selector(loadVoucherList:) forControlEvents:UIControlEventValueChanged];
    
    //下拉刷新，上拉加载
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(loadVoucherList:)];
    //    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(loadVoucherList:)];
    
    

    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [self loadVoucherList:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadVoucherList:(id)sender {
    ActionVoucher *voucher = [[ActionVoucher alloc] init];
    voucher.afterQueryVoucher = ^(NSArray *voucherList) {
        [self.voucherList removeAllObjects];
        [self.voucherList addObjectsFromArray:voucherList];
        [self.tableView reloadData];
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        
        if ([voucherList count] == 0) {
            // TODO 处理以上警告
            self.defaultimage.hidden = NO;
        }else{
            self.defaultimage.hidden = YES;
        }
    };
    voucher.afterQueryVoucherFailed = ^(NSString *message) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        //        TODO...错误提示
    };
    [voucher doQueryVoucher];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.voucherList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoucherCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.voucherInfo = [self.voucherList objectAtIndex:indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.checkedRow = indexPath.row;
    [self performSegueWithIdentifier:@"VoucherDetails" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
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
    if ([segue.identifier isEqualToString:@"VoucherDetails"]) {
        if ([segue.destinationViewController isKindOfClass:[VoucherDetailsVC class]]) {
            VoucherDetailsVC *destination = (VoucherDetailsVC *)segue.destinationViewController;
//            destination.voucherInfo = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"i"];
            destination.voucherInfo = [self.voucherList objectAtIndex:self.checkedRow];
            VoucherCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.checkedRow inSection:0]];
            destination.logo = cell.merchantLogo.image;
        }
    }
}

@end
