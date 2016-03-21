//
//  MMeTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/19.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MMeTVC.h"
#import "MMeExchangeRateVC.h"
#import "ActionBusiness.h"
#import "ActionMMaterial.h"
#import "MMaterialManager.h"
#import "ActionFlow.h"
#import "UIImageView+WebCache.h"

#import "Constance.h"
#import "MMaterialTVC.h"
#import "MSettingTVC.h"


@interface MMeTVC ()
#define MMATERIALEXCHANGERATE  0x1
@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLBL;
@property (weak, nonatomic) IBOutlet UILabel *merchantCreditAmountLBL;
@property (weak, nonatomic) IBOutlet UIImageView *merchantAvatarIMG;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantContactNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantVerifyLable;
@property (weak, nonatomic) IBOutlet UILabel *merchantCreditMayIssueLabel;

@end

@implementation MMeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"商家中心";
    self.material = [NSMutableDictionary dictionaryWithDictionary:[MMaterialManager getMaterial]];
    
    //    圆角
    self.merchantAvatarIMG.clipsToBounds = YES;
    self.merchantAvatarIMG.layer.cornerRadius = 4.0f;
//    self.merchantAvatarIMG.layer.cornerRadius = self.merchantAvatarIMG.frame.size.height / 2.0;
    
    ActionMMaterial *action = [[ActionMMaterial alloc] init];
    action.afterQueryMerchantOfAccount = ^(NSDictionary *material) {
        if (material) {
            self.merchantNameLabel.text = [material objectForKey:@"n"];
            self.merchantContactNumberLabel.text = [material objectForKey:@"con"];
//            NSString *unverifytitle = NSLocalizedString(@"未认证", nil);

            if ([[material objectForKey:@"v"] isEqualToString:@"no"]) {
//                self.merchantVerifyLable.text = unverifytitle;
                self.merchantVerifyLable.hidden = NO;
            }else{
                self.merchantVerifyLable.hidden = YES;
            }
            
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [material objectForKey:@"logo"]];
            [self.merchantAvatarIMG sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"logo-merchant-default"]];
            
            
            //保存
            [MMaterialManager setMaterial:material];
            self.material = [NSMutableDictionary dictionaryWithDictionary:material];
        }
    };
    [action doQueryMerchantOfAccount];
    
    if (self.material) {
        ActionBusiness *action = [[ActionBusiness alloc] init];
        action.afterQueryBusinessParameters = ^(NSDictionary *business){
            if(business){
                self.business = [NSMutableDictionary dictionaryWithDictionary:business];
                self.exchangeRateLBL.text = [NSString stringWithFormat:@"%@", [business objectForKey:@"crt"]];
            }
        };
        [action doQueryBusinessParameters:[self.material objectForKey:@"id"]];
    
        ActionFlow *action2 = [[ActionFlow alloc] init];
        action2.afterQqueryFlow = ^(NSDictionary *flow){
            if (flow) {
                self.flow = [NSMutableDictionary dictionaryWithDictionary:flow];
//                self.merchantCreditAmountLBL.text = [ [[NSString stringWithFormat:@"%@",[flow objectForKey:@"mi"]] stringByAppendingString:@" / "] stringByAppendingString:  [NSString stringWithFormat:@"%@",[flow objectForKey:@"is"]]];
                self.merchantCreditMayIssueLabel.text = [NSString stringWithFormat:@"%@",[flow objectForKey:@"mi"]];

                self.merchantCreditAmountLBL.text = [NSString stringWithFormat:@"%@", [flow objectForKey:@"is"]] ;
            }
        };
        [action2 doQueryFlow:[self.material objectForKey:@"id"]];
    }
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
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 4;
            break;
        case 2:
            rows = 2;
            break;
        case 3:
            rows = 2;
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                break;
            }
            case 1:
            {
                break;
            }
            case 2:
            {
//                if ([[self.material objectForKey:@"v"] isEqualToString:@"yes"]) {
//                    cell.userInteractionEnabled = TRUE;
//                } else if([[self.material objectForKey:@"v"] isEqualToString:@"no"]) {
//                    cell.userInteractionEnabled = FALSE;
//                }
                break;
            }
            default:
                break;
        }

       }else if (indexPath.section == 1){
           
           switch (indexPath.row) {
               case 0:
               {
                   break;
               }
               case 1:
               {
                   break;
               }
               case 2:
               {

                   //TODO CHECKOUT IF THE MERCHANT IS VERIFIED--the follow solution need capture material.v by login action
//                   if ([[self.material objectForKey:@"v"] isEqualToString:@"yes"]) {
//                       cell.userInteractionEnabled = TRUE;
//                   } else if([[self.material objectForKey:@"v"] isEqualToString:@"no"]) {
//                       cell.userInteractionEnabled = FALSE;
//                   }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 120.0f;
    }
    return 44.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }else if (1 == section) {
        return 0.01f;
    }
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (0 == section) {
//        return 0.01f;
//    }
    
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
        }else if (1 == indexPath.row) {
            
        }
        
    } else if(1 == indexPath.section) {
        if (0 == indexPath.row) {
            [self showAlert:@"确定" :@"修改请联系平台"];

        
        }else  if (3 == indexPath.row) {
        //
            if ([[self.material objectForKey:@"v"] isEqualToString:@"no"]) {
                [self showAlert:@"确定" :@"认证请联系平台"];
            }
        }else  if (4 == indexPath.row) {
        //
        }

    } else if(2 == indexPath.section) {
        if (0 == indexPath.row) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me"bundle:nil];
            UIViewController *myView = [storyboard instantiateViewControllerWithIdentifier:@"feedbackView"];
//            self.view.window.rootViewController = myView;
            
            [self.navigationController pushViewController:myView animated:YES];
//            [self.navigationController pushViewController:[self.navigationController.viewControllers objectAtIndex:2]
//                                                  animated:YES];
        }else if (1 == indexPath.row) {
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps ://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8"]];
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

- (IBAction)unwindUpdateMaterial:(UIStoryboardSegue *)segue {
    if([segue.sourceViewController isKindOfClass:[MMeExchangeRateVC class]]){
        MMeExchangeRateVC *merchantvc = (MMeExchangeRateVC *)segue.sourceViewController;
        ActionBusiness *action = [[ActionBusiness alloc] init];
        action.afterModifyConsumptionRatio = ^(NSDictionary *result){
            [self.business setObject:merchantvc.exchangeRate forKey:@"crt"];
            self.exchangeRateLBL.text = [NSString stringWithFormat:@"%@", [self.business objectForKey:@"crt"]];
//            self.exchangeRateLBL.text = [[NSString stringWithFormat:@"%@", [self.business objectForKey:@"crt"]] stringByAppendingString:@" : 1"];
            self.updateMMaterialTypeMask |= MBUSINESSTYPECONSUMPTIONRATIO;
        };
        [action doModifyConsumptionRatio:merchantvc.exchangeRate merchant:[self.material objectForKey:@"id"]];
    
    }else if([segue.sourceViewController isKindOfClass:[MMaterialTVC class]]){
        MMaterialTVC *source = (MMaterialTVC *)segue.sourceViewController;
        if(source.updateMMaterialTypeMask & MMATERIALTYPELOGO){
//            [self.material setObject:[source.material objectForKey:@"ni"] forKey:@"ni"];
//            self.nicknameLabel.text = [self.material objectForKey:@"ni"];
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [source.material objectForKey:@"logo"]];
            [self.material setObject:[source.material objectForKey:@"logo"] forKey:@"logo"];
            [self.merchantAvatarIMG sd_setImageWithURL:[NSURL URLWithString:path]];
        }
        if(source.updateMMaterialTypeMask & MMATERIALTYPENAME){
            [self.material setObject:[source.material objectForKey:@"n"] forKey:@"n"];
            self.merchantNameLabel.text = [self.material objectForKey:@"n"];
        }
        if(source.updateMMaterialTypeMask & MMATERIALTYPECONTRACT){
            [self.material setObject:[source.material objectForKey:@"con"] forKey:@"con"];
            self.merchantContactNumberLabel.text = [self.material objectForKey:@"con"];
        }
        
    }
}


- (void)showAlert:(NSString *)title :(NSString *)info{
    
    NSString *selectButtonOKTitle = NSLocalizedString(title, nil);
    NSString *selectTitle = NSLocalizedString(info, nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:selectTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectButtonOKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"goverifiedinfo"]){
        if ([[self.material objectForKey:@"v"] isEqualToString:@"no"]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goupdatecrt"]){
        [segue.destinationViewController setValue:[NSString stringWithFormat:@"%@", [self.business objectForKey:@"crt"]] forKey:@"exchangeRate"];
    }else if([segue.identifier isEqualToString:@"goverifiedinfo"]){
        [segue.destinationViewController setValue:self.business forKey:@"business"];
        [segue.destinationViewController setValue:self.flow forKey:@"flow"];
    }else if ([segue.identifier isEqualToString:@"MerchantMaterialUpdate"]){
        MMaterialTVC *destination = (MMaterialTVC *)segue.destinationViewController;
        destination.material = self.material;
    }else if ([segue.identifier isEqualToString:@"gosetting"]){
        MSettingTVC *destination = (MSettingTVC *)segue.destinationViewController;
        destination.material = self.material;
    }
    
}

@end
