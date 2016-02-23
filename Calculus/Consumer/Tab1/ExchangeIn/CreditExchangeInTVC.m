//
//  CreditExchangeInTVC.m
//  Calculus
//
//  Created by ben on 15/12/21.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "CreditExchangeInTVC.h"
#import "CreditExchangeInCell.h"
#import "ActionCredit.h"
#import "InterchangeController.h"
#import "SVProgressHUD.h"
#import "UIColor+Extension.h"
#import "CreditExchangeSessionHeader.h"
#import "ExchangeRateTVC.h"


@interface CreditExchangeInTVC ()
@property (nonatomic, retain) NSMutableArray *creditList;
@property (nonatomic, retain) NSIndexPath *lastCheckedIndex;  //nil表示没有cell被选中
//@property (weak, nonatomic) IBOutlet UIImageView *logoIMG;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextstep;
@end

@implementation CreditExchangeInTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择转出积分";
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
    [credit doConsumerQueryCreditListWithout:self.merchant];
}


#pragma mark - Table view data source delegate
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
    CreditExchangeInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditExchangeInCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.awardInfo = [[[self.creditList objectAtIndex:indexPath.section] objectForKey:@"cr"] objectAtIndex:indexPath.row];
//    cell.logoPath = [[self.creditList objectAtIndex:indexPath.section] objectForKey:@"l"];
    cell.tableView = tableView;
    
    __block CreditExchangeInCell *_cell = cell;
    cell.afterToggleAction = ^(BOOL checked, NSIndexPath *indexPath) {
        if (self.lastCheckedIndex == indexPath) {
            //toggle同一cell
            self.lastCheckedIndex = !checked ? indexPath : nil;
            [_cell toggle];
            self.nextstep.enabled = !checked ? YES : NO;
        }else{
            //toggle上一次选择的row
            if (self.lastCheckedIndex) {
                CreditExchangeInCell *lastCell = (CreditExchangeInCell *)[tableView cellForRowAtIndexPath:self.lastCheckedIndex];
                [lastCell toggle];
            }
            self.lastCheckedIndex = indexPath;
            [_cell toggle];
            self.nextstep.enabled = YES;
        }
    };
    
    return cell;

}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CreditExchangeSessionHeader *header = [tableView dequeueReusableCellWithIdentifier: @"CreditExchangeSessionHeader"];
    
    header.name = [[self.creditList objectAtIndex:section] objectForKey:@"t"];
    header.logoPath = [[self.creditList objectAtIndex:section] objectForKey:@"l"];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

//必须，否则第二个section head上面包含footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.01f;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
////    CreditExchangeInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditExchangeCell" forIndexPath:indexPath];
//    //cell.awardInfo = [[[self.creditList objectAtIndex:indexPath.section] objectForKey:@"cr"] objectAtIndex:indexPath.row];
//    
//}


#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
//     if ([segue.identifier isEqualToString:@"ShowInterchange"]) {
//         if ([segue.destinationViewController isKindOfClass:[InterchangeController class]]) {
//             InterchangeController *destination = (InterchangeController *)segue.destinationViewController;
//             
//             NSDictionary *oneMCredit =[self.creditList objectAtIndex:self.lastCheckedIndex.section];
//             NSDictionary *oneCredit = [[oneMCredit objectForKey:@"cr"] objectAtIndex:self.lastCheckedIndex.row];
//             destination.merchantOut = @{@"name": [oneMCredit objectForKey:@"t"], @"logo": [oneMCredit objectForKey:@"l"], @"mIdentity": [oneMCredit objectForKey:@"i"], @"cIdentity": [oneCredit objectForKey:@"id"], @"quantity": [oneCredit objectForKey:@"qu"], @"expire": [oneCredit objectForKey:@"et"]};
//             
//             destination.merchantIn = @{@"name": self.name, @"logo": self.logo, @"identity": self.merchant};
//         }
//     }
     if ([segue.identifier isEqualToString:@"ShowInterchange"]) {
         if ([segue.destinationViewController isKindOfClass:[ExchangeRateTVC class]]) {
             ExchangeRateTVC *destination = (ExchangeRateTVC *)segue.destinationViewController;
             
             NSDictionary *oneMCredit =[self.creditList objectAtIndex:self.lastCheckedIndex.section];
             NSDictionary *oneCredit = [[oneMCredit objectForKey:@"cr"] objectAtIndex:self.lastCheckedIndex.row];
             destination.merchantOut = @{@"name": [oneMCredit objectForKey:@"t"], @"logo": [oneMCredit objectForKey:@"l"], @"mIdentity": [oneMCredit objectForKey:@"i"], @"cIdentity": [oneCredit objectForKey:@"id"], @"quantity": [oneCredit objectForKey:@"qu"], @"expire": [oneCredit objectForKey:@"et"]};
             
             destination.merchantIn = @{@"name": self.name, @"logo": self.logo, @"identity": self.merchant};

         }
     }
}






@end