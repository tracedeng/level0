//
//  MerchantVerifiedInfoTVC.m
//  Calculus
//
//  Created by ben on 15/12/28.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantVerifiedInfoTVC.h"

@interface MerchantVerifiedInfoTVC ()
@property (weak, nonatomic) IBOutlet UILabel *bondLBL;
@property (weak, nonatomic) IBOutlet UILabel *businessAllLBL;
@property (weak, nonatomic) IBOutlet UILabel *businessRestLBL;
@property (weak, nonatomic) IBOutlet UILabel *brtLBL;

@end

@implementation MerchantVerifiedInfoTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bondLBL.text = [[NSString stringWithFormat:@"%@", [self.business objectForKey:@"bo"]] stringByAppendingString:@"元"];
    self.businessAllLBL.text = [[NSString stringWithFormat:@"%@", [self.business objectForKey:@"bal"]] stringByAppendingString:@"积分"];
    self.businessRestLBL.text = @"TODO...";
    self.brtLBL.text = [[NSString stringWithFormat:@"%@", [self.business objectForKey:@"brt"]] stringByAppendingString:@" : 1"];

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 5;
    }
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
