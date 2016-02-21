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


@interface MMeTVC ()
#define MMATERIALEXCHANGERATE  0x1
@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLBL;
@property (weak, nonatomic) IBOutlet UILabel *merchantCreditAmountLBL;


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

    if (self.material) {
        ActionBusiness *action = [[ActionBusiness alloc] init];
        action.afterQueryBusinessParameters = ^(NSDictionary *business){
            if(business){
                self.exchangeRateLBL.text = [[NSString stringWithFormat:@"%@", [business objectForKey:@"crt"]] stringByAppendingString:@" : 1"];

                self.business = [NSMutableDictionary dictionaryWithDictionary:business];
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

            }
        };
        [action doQueryBusinessParameters:[self.material objectForKey:@"id"]];
    
        ActionFlow *action2 = [[ActionFlow alloc] init];
        action2.afterQqueryFlow = ^(NSDictionary *flow){
            if (flow) {
          
                self.merchantCreditAmountLBL.text = [ [[NSString stringWithFormat:@"%@",[flow objectForKey:@"mi"]] stringByAppendingString:@" / "] stringByAppendingString:  [NSString stringWithFormat:@"%@",[flow objectForKey:@"is"]]];

//                self.merchantCreditAmountLBL.text = [NSString stringWithFormat:@"%@", [flow objectForKey:@"up"]] ;
                self.flow = [NSMutableDictionary dictionaryWithDictionary:flow];
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (0 == indexPath.section) {
//        if (0 == indexPath.row) {
//        }else if (1 == indexPath.row) {
//            
//        }
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }
    return 0.0f;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    
//    // Configure the cell...
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//            {
//                break;
//            }
//            case 1:
//            {
//                if ([self.business objectForKey:@"crt"]  == nil) {
//                    cell.userInteractionEnabled = FALSE;
//                } else{
//                    cell.userInteractionEnabled = TRUE;
//                }
//                break;
//            }
//            case 2:
//            {
////TODO CHECKOUT IF THE MERCHANT IS VERIFIED--the follow solution need capture material.v by login action
////                if ([[self.material objectForKey:@"v"] isEqualToString:@"yes"]) {
////                    cell.userInteractionEnabled = TRUE;
////                } else if([[self.material objectForKey:@"v"] isEqualToString:@"no"]) {
////                    cell.userInteractionEnabled = FALSE;
////                }
//                break;
//            }
//            default:
//                break;
//        }
//
//       }else if (indexPath.section == 1){
//        
//       }else if (indexPath.section == 2){
//        //管理员，right detail
//        //        cell.detailTextLabel.text = [self.material objectForKey:@"lo"];
//    }
//    
//    return cell;
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

- (IBAction)unwindUpdateMaterial:(UIStoryboardSegue *)segue {
    if([segue.sourceViewController isKindOfClass:[MMeExchangeRateVC class]]){
        MMeExchangeRateVC *merchantvc = (MMeExchangeRateVC *)segue.sourceViewController;
        ActionBusiness *action = [[ActionBusiness alloc] init];
        action.afterModifyConsumptionRatio = ^(NSDictionary *result){
            [self.business setObject:merchantvc.exchangeRate forKey:@"crt"];
            self.exchangeRateLBL.text = [[NSString stringWithFormat:@"%@", [self.business objectForKey:@"crt"]] stringByAppendingString:@" : 1"];
            self.updateMMaterialTypeMask |= MBUSINESSTYPECONSUMPTIONRATIO;
        };
        [action doModifyConsumptionRatio:merchantvc.exchangeRate merchant:[self.material objectForKey:@"id"]];
    }
}


#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goupdatecrt"]){
        [segue.destinationViewController setValue:[NSString stringWithFormat:@"%@", [self.business objectForKey:@"crt"]] forKey:@"exchangeRate"];
        
    }else if([segue.identifier isEqualToString:@"goverifiedinfo"]){
        [segue.destinationViewController setValue:self.business forKey:@"business"];
        [segue.destinationViewController setValue:self.flow forKey:@"flow"];
        
    }
}


@end
