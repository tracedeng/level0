//
//  CreditExchangeInTVC.m
//  Calculus
//
//  Created by ben on 15/12/21.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "CreditExchangeInTVC.h"
#import "AwardDerivateCell.h"
#import "ActionCredit.h"
#import "SVProgressHUD.h"


@interface CreditExchangeInTVC ()
@property (nonatomic, retain) NSMutableArray *creditList;
@end

@implementation CreditExchangeInTVC


- (void)viewDidLoad {
    [super viewDidLoad];

    self.creditList = [[NSMutableArray alloc] init];
//
//    [self.refreshControl addTarget:self action:@selector(loadCreditList:) forControlEvents:UIControlEventValueChanged];
//    
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - Table view data source delegate
//返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回总行数
-(NSInteger ) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger )section
{
    
    return [self.creditList count];
}

// 添加每一行的信息
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSString *tag=@"tag";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tag];
    
    if (cell==nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tag];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    NSUInteger row=[indexPath row];
    
    NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
    details = [self.creditList objectAtIndex:row];
    cell.textLabel.text = [details objectForKey:@"et"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[details objectForKey:@"s"]];
    
    
    
    //cell.text =[listData objectAtIndex :row];
    //选中后的颜色又不发生改变，进行下面的设置
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //不需要分割线
    //tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    
    
    return cell;
    
}

#pragma mark 第section组显示的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if (section == 0) return self.name;
        if (section == 1) return @"湖南";
        if (section == 2) return @"湖北";
        if (section == 3) return @"广西";
        if (section == 4) return @"浙江";
        if (section == 5) return @"安徽";
    return @"non";
    
//    NSDictionary *province = _allProvinces[section];
//    
//    return province[kHeader];
}
//#pragma mark 第section组显示的尾部标题
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//        if (section == 0) return @"广东好";
//        if (section == 1) return @"湖南也好";
//        if (section == 2) return @"湖北更好";
//        if (section == 3) return @"广西一般般";
//        if (section == 4) return @"浙江应该可以吧";
//        if (section == 5) return @"安徽确实有点坑爹";
//    return @"non";
//
////    return _allProvinces[section][kFooter];
//}



#pragma mark - Table view data delegate

//响应用户单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.nextPageTitle = [self.listData objectAtIndex:indexPath.row];
//    self.nextPageContent = [self.listContent objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"gocreditexchangeinconfirm" sender:self]; //这个方法。跳转页面。
    
    
}






#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
//    
//    NSString *data = self.nextPageTitle;
//    NSString *content = self.nextPageContent;
//    
//    newsDetailsViewController *detailsview = segue.destinationViewController;
//    if ([detailsview respondsToSelector:@selector(setParamx:)]) {
//        [detailsview setValue:data forKey:@"paramx"];
//    }
//    if ([detailsview respondsToSelector:@selector(setParamy:)]) {
//        [detailsview setValue:content forKey:@"paramy"];
//    }
    
    
}






@end