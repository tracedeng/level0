//
//  BuyDiscountTVC.m
//  Calculus
//
//  Created by tracedeng on 16/1/4.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "BuyDiscountTVC.h"
#import "SVProgressHUD.h"
#import "BuyDiscountCell.h"
#import "ActionCredit.h"

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height

@interface BuyDiscountTVC ()
@property (nonatomic, retain) NSMutableArray *creditList;
@property (nonatomic, assign) NSInteger checkedQuantity;        //已选积分量
@property (nonatomic, retain) NSMutableArray *checkedIndexPath;        //cell选中indexpath
@property (nonatomic, retain) IBOutlet UIImageView *defaultimage;

@end

@implementation BuyDiscountTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultimage = [[UIImageView alloc] init];
    self.defaultimage.image=[UIImage imageNamed:@"creditless"];
    self.defaultimage.frame=CGRectMake( deviceWidth *1/8, (deviceHeight - deviceWidth *3/4) / 4,  deviceWidth *3/4, deviceWidth *3/4 );
    [self.view addSubview:self.defaultimage];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.creditList = [[NSMutableArray alloc] init];
    self.checkedIndexPath = [[NSMutableArray alloc] init];
    
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
        if ([creditList count] == 0) {
            
            self.defaultimage.hidden = NO;
            
        }else{
            self.defaultimage.hidden = YES;
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

- (NSArray *)spendCredits {
    NSMutableArray *credits = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.checkedIndexPath) {
        BuyDiscountCell *cell = (BuyDiscountCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *creditQuantity = cell.creditTextField.text;
        NSString *creditIdentity = [cell.awardInfo objectForKey:@"i"];
        
        [credits addObject:@{@"quantity": creditQuantity, @"identity": creditIdentity}];
    }
    
    return credits;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.creditList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuyDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyDiscountCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.awardInfo = [self.creditList objectAtIndex:indexPath.row];
    cell.tableView = tableView;
    
//    __block BuyDiscountCell *_cell = cell;
    cell.afterToggleAction = ^(BOOL checked, NSIndexPath *indexPath) {
        //CreditExchangeCell *lastCell = (CreditExchangeCell *)[tableView cellForRowAtIndexPath:self.lastCheckedIndex];
        if (checked) {
            [self.checkedIndexPath removeObject:indexPath];
        }else{
            [self.checkedIndexPath addObject:indexPath];
        }
    };
    cell.currentNeedQuantity = ^(NSInteger quantity) {
        self.checkedQuantity += quantity;
        
        // 更新合计
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCheckedCredit" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", self.checkedQuantity], @"quantity", nil]];
        
        return self.needQuantity - self.checkedQuantity;
    };

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
