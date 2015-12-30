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


@interface MMeTVC ()
#define MMATERIALEXCHANGERATE  0x1
@property (weak, nonatomic) IBOutlet UILabel *merchantCreditAmountLBL;
@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLBL;


@end

@implementation MMeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.material = [NSMutableDictionary dictionaryWithDictionary:[MMaterialManager getMaterial]];

    if (self.material) {
        ActionBusiness *action = [[ActionBusiness alloc] init];
        action.afterQueryBusinessParameters = ^(NSDictionary *business){
            if(business){
                self.exchangeRateLBL.text = [[NSString stringWithFormat:@"%@", [business objectForKey:@"crt"]] stringByAppendingString:@" : 1"];

                self.business = [NSMutableDictionary dictionaryWithDictionary:business];
            }
        };
        [action doQueryBusinessParameters:[self.material objectForKey:@"id"]];
    }
    
    
    
    
 
    
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
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 3;
            break;
        case 1:
            rows = 2;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
        }else if (1 == indexPath.row) {
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }
    return 0.0f;
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

- (IBAction)unwindUpdateMaterial:(UIStoryboardSegue *)segue {
    if([segue.sourceViewController isKindOfClass:[MMeExchangeRateVC class]]){
        MMeExchangeRateVC *merchantvc = (MMeExchangeRateVC *)segue.sourceViewController;
        ActionBusiness *action = [[ActionBusiness alloc] init];
        action.afterModifyConsumptionRatio = ^(NSDictionary *result){
            [self.business setObject:merchantvc.exchangeRate forKey:@"crt"];
            self.exchangeRateLBL.text = [NSString stringWithFormat:@"%@", [self.business objectForKey:@"crt"]];
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
        
    }
    
    
}


@end
