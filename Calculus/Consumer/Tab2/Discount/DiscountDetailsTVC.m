//
//  DiscountDetailsTVC.m
//  Calculus
//
//  Created by ben on 16/1/27.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "DiscountDetailsTVC.h"
#import "BuyDiscountController.h"
#import "Constance.h"
#import "ImageListCVC.h"
#import "UIImageView+WebCache.h"


@interface DiscountDetailsTVC ()
@property (nonatomic, retain) NSString *path;
@property (weak, nonatomic) IBOutlet UIImageView *activityIMG;
@property (weak, nonatomic) IBOutlet UILabel *name; // 商家名称
@property (weak, nonatomic) IBOutlet UILabel *address; // 商家地址
@property (weak, nonatomic) IBOutlet UILabel *credit;   // 活动需要多少积分

@property (weak, nonatomic) IBOutlet UILabel *heading;  // 活动标题
@property (weak, nonatomic) IBOutlet UILabel *detail;   // 活动详情

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@end

@implementation DiscountDetailsTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = [self.discountInfo objectForKey:@"t"];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/1600/h/900", QINIUURL, [self.discountInfo objectForKey:@"po"]];
    [self.activityIMG sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"icon-activitytest"]];
    
    self.heading.text = [self.discountInfo objectForKey:@"t"];
    self.detail.text = [self.discountInfo objectForKey:@"in"];
    
    self.name.text = [self.discountInfo objectForKey:@"t"];
    self.address.text = [self.discountInfo objectForKey:@"t"];
    self.credit.text = [[self.discountInfo objectForKey:@"cr"] stringValue];
    
    self.buyButton.clipsToBounds = YES;
    self.buyButton.layer.cornerRadius = 4.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    switch (indexPath.section) {
        case 0:
            // 16:9 展示
            height = [UIScreen mainScreen].bounds.size.width * 9 / 16.0f;
            break;
        case 1:
            height = 35.0f;
            break;
        case 2:
            height = 75.0f;
            break;
        case 3:
            height = 44.0f;
            break;
//        case 4:
//            height = 44.0f;
//            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return 0.0f;
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
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"BuyDiscount"]) {
        if ([segue.destinationViewController isKindOfClass:[BuyDiscountController class]]) {
            BuyDiscountController *destination = (BuyDiscountController *)segue.destinationViewController;
            destination.merchant = [self.discountInfo objectForKey:@"mid"];
            destination.discountInfo = self.discountInfo;
        }
    }
}


@end
