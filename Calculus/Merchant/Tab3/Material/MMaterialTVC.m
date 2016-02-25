//
//  MMaterialTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/19.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MMaterialTVC.h"
#import "UIImageView+WebCache.h"
#import "ImageListCVC.h"
#import "ActionMMaterial.h"
#import "ActionQiniu.h"
#import "Constance.h"
#import "MerchantNameVC.h"
#import "MerchantQrcodeVC.h"
#import "MerchantEmailVC.h"
#import "MerchantContactNumberVC.h"
#import "MerchantAddressVC.h"
#import "MMeExchangeRateVC.h"

@interface MMaterialTVC ()
@property (nonatomic, retain) NSString *uploadToken;
@property (nonatomic, retain) NSString *path;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation MMaterialTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //TODO
    
    self.title = @"商户信息";

    //    圆角
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = 4.0f;
//    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height / 2.0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self performSegueWithIdentifier:@"unwindUpdateMaterial" sender:nil];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }else if (1 == section) {
        return 6;
    }else{
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (0 == indexPath.row) {
            //头像，right detail，修改accessory图标
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [self.material objectForKey:@"logo"]];
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                //名称，right detail
                cell.detailTextLabel.text = [self.material objectForKey:@"n"];
//                if ([[self.material objectForKey:@"v"] isEqualToString:@"yes"]) {
//                    cell.userInteractionEnabled = FALSE;
//                
//                }
                break;
            }
            case 1:
            {
//                创建人
                cell.detailTextLabel.text = [self.material objectForKey:@"fou"];
                break;
            }
            case 2:
            {
                //二维码
//                cell.detailTextLabel.text = [self.material objectForKey:@"qr"];
                break;
            }
            case 3:
            {
                //联系电话，right detail
                cell.detailTextLabel.text = [self.material objectForKey:@"con"];
                break;
            }
            case 4:
            {
                //email，right detail
                cell.detailTextLabel.text = [self.material objectForKey:@"em"];
                break;
            }
            case 5:
            {
                //地址，right detail
                cell.detailTextLabel.text = [self.material objectForKey:@"lo"];
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section == 2){
        //管理员，right detail
//        cell.detailTextLabel.text = [self.material objectForKey:@"lo"];
    }
    
    return cell;
}

//获取7牛上传token，做好准备
- (void)prepareQiniuToken {
    ActionMMaterial *action = [[ActionMMaterial alloc] init];
    action.afterQueryUploadToken = ^(NSDictionary *result) {
        self.uploadToken = [result objectForKey:@"tok"];
        self.path = [result objectForKey:@"path"];
    };
    [action doQueryUploadToken:[self.material objectForKey:@"id"] ofResource:@"m_logo"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            // 更新头像
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Album" bundle:[NSBundle mainBundle]];
            ImageListCVC *album = [board instantiateInitialViewController];
            album.bMultiChecked = NO;
            album.checkableCount = 1;
            // 先准备token
            [self prepareQiniuToken];
            [self.navigationController pushViewController:album animated:YES];
        }else if (1 == indexPath.row) {
            
        }
    }else if (1 == indexPath.section) {
        if (0 == indexPath.row) {

            if ([[self.material objectForKey:@"v"] isEqualToString:@"yes"]) {

                NSString *selectButtonOKTitle = NSLocalizedString(@"确定", nil);
                NSString *selectTitle = NSLocalizedString(@"已认证商户修改名称，请联系客服", nil);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:selectTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectButtonOKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                }];
                
                [alertController addAction:okAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }

        }else if (1 == indexPath.row) {

        }


    }

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
- (IBAction)unwindUpdateMaterial:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[ImageListCVC class]]) {
        ImageListCVC *imageList = (ImageListCVC *)segue.sourceViewController;
        //保存已选择的头像图片
        NSDictionary *photo = [imageList.currentCheckedImages objectAtIndex:0];
        ActionQiniu *action = [[ActionQiniu alloc] init];
        action.afterQiniuUpload = ^(NSString *path) {
            [self.material setObject:path forKey:@"logo"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            //            更新用户头像资料
            ActionMMaterial *action2 = [[ActionMMaterial alloc] init];
            [action2 doModifyLogo:path merchant:[self.material objectForKey:@"id"]];
            self.updateMMaterialTypeMask |= MMATERIALTYPELOGO;
        };
        [action doQiniuUpload:photo token:self.uploadToken path:self.path];
    }else if([segue.sourceViewController isKindOfClass:[MerchantQrcodeVC class]]){
        MerchantQrcodeVC *merchantqrcodevc = (MerchantQrcodeVC *)segue.sourceViewController;
//        ActionMMaterial *action = [[ActionMMaterial alloc] init];
//        action.afterModifyMerchantName = ^(NSDictionary *materail){
//            [self.material setObject:merchantnamevc.merchantName forKey:@"n"];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//            
//            self.updateMMaterialTypeMask |= MMATERIALTYPENAME;
//        };
//        [action doModifyMerchantName:merchantnamevc.merchantName merchant:[self.material objectForKey:@"id"]];
        [self.material setObject:merchantqrcodevc.merchantQrcode forKey:@"qr"];

    }else if([segue.sourceViewController isKindOfClass:[MerchantNameVC class]]){
        MerchantNameVC *merchantnamevc = (MerchantNameVC *)segue.sourceViewController;
        ActionMMaterial *action = [[ActionMMaterial alloc] init];
        action.afterModifyMerchantName = ^(NSDictionary *materail){
            [self.material setObject:merchantnamevc.merchantName forKey:@"n"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            
            self.updateMMaterialTypeMask |= MMATERIALTYPENAME;
        };
        [action doModifyMerchantName:merchantnamevc.merchantName merchant:[self.material objectForKey:@"id"]];
        
    }else if([segue.sourceViewController isKindOfClass:[MerchantContactNumberVC class]]){
        MerchantContactNumberVC *merchantvc = (MerchantContactNumberVC *)segue.sourceViewController;
        ActionMMaterial *action = [[ActionMMaterial alloc] init];
        action.afterModifyMerchantContactNumber = ^(NSDictionary *materail){
            [self.material setObject:merchantvc.merchantContactNumber forKey:@"con"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            
            self.updateMMaterialTypeMask |= MMATERIALTYPECONTRACT;
        };
        [action doModifyMerchantContactNumber:merchantvc.merchantContactNumber merchant:[self.material objectForKey:@"id"]];
        
    }else if([segue.sourceViewController isKindOfClass:[MerchantEmailVC class]]){
        MerchantEmailVC *merchantvc = (MerchantEmailVC *)segue.sourceViewController;
        ActionMMaterial *action = [[ActionMMaterial alloc] init];
        action.afterModifyMerchantEmail = ^(NSDictionary *materail){
            [self.material setObject:merchantvc.merchantEmail forKey:@"em"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            
            self.updateMMaterialTypeMask |= MMATERIALTYPEEMAIL;
        };
        [action doModifyMerchantEmail:merchantvc.merchantEmail merchant:[self.material objectForKey:@"id"]];
        
    }else if([segue.sourceViewController isKindOfClass:[MerchantAddressVC class]]){
        MerchantAddressVC *merchantvc = (MerchantAddressVC *)segue.sourceViewController;
        ActionMMaterial *action = [[ActionMMaterial alloc] init];
        action.afterModifyMerchantAddress = ^(NSDictionary *materail){
            [self.material setObject:merchantvc.merchantAddress forKey:@"lo"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            
            self.updateMMaterialTypeMask |= MMATERIALTYPELOCATION;
        };
        [action doModifyMerchantAddress:merchantvc.merchantAddress merchant:[self.material objectForKey:@"id"]];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"gomerchantname"]){
        if ([[self.material objectForKey:@"v"] isEqualToString:@"yes"]) {
            return NO;
        }
    }
    return YES;
}



#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"gomerchantname"]){
        //TODO 认证商户提示不可修改姓名
        [segue.destinationViewController setValue:[self.material objectForKey:@"n"] forKey:@"merchantName"];
        
    } else if([segue.identifier isEqualToString:@"gomerchantemail"]){
        [segue.destinationViewController setValue:[self.material objectForKey:@"em"] forKey:@"merchantEmail"];
        
    } else if([segue.identifier isEqualToString:@"gocontactnumber"]){
        [segue.destinationViewController setValue:[self.material objectForKey:@"con"] forKey:@"merchantContactNumber"];
        
    } else if([segue.identifier isEqualToString:@"gomerchantaddress"]){
        [segue.destinationViewController setValue:[self.material objectForKey:@"lo"] forKey:@"merchantAddress"];
        
    }else if([segue.identifier isEqualToString:@"gomerchantqrcode"]){
        [segue.destinationViewController setValue:[self.material objectForKey:@"qr"] forKey:@"merchantQrcode"];
        [segue.destinationViewController setValue:[self.material objectForKey:@"id"] forKey:@"merchant"];
        [segue.destinationViewController setValue:self.logoImageView.image forKey:@"logo"];
        
    }
        
    
}

@end
