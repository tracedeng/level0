//
//  MActivityTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/31.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MActivityTVC.h"
#import "MActivityCell.h"
#import "ActionMActivity.h"
#import "MMaterialManager.h"
#import "MActivityCreateTVC.h"
#import "MActivityUpdateTVC.h"

@interface MActivityTVC ()
@property (nonatomic, retain) NSMutableArray *activityList;
@property (nonatomic, retain) NSNumber *selectRowNumber;

@end

@implementation MActivityTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    

    
    //可变数组(期望容量设置为3)
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:3];
    //直接添加
    [mutableArray addObject:@"aaa"];
    [mutableArray addObject:@"eee"];
    [mutableArray addObject:@"000"];
    NSLog(@"addObject :%@", mutableArray);
    
    //插入元素
    [mutableArray insertObject:@"ccc" atIndex:0];
    NSLog(@"insertObject :%@", mutableArray);
    
    //移除指定元素
    [mutableArray removeObject:@"ccc"];
    NSLog(@"removeObject :%@", mutableArray);
    
    //移除指定下标元素
    [mutableArray removeObjectAtIndex:0];
    NSLog(@"removeObjectAtIndex :%@", mutableArray);
    
    //移除最后一个元素
    [mutableArray removeLastObject];
    NSLog(@"removeLastObject :%@", mutableArray);
    
    
    
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.activityList = [[NSMutableArray alloc] init];
    self.material = [NSMutableDictionary dictionaryWithDictionary:[MMaterialManager getMaterial]];
    
    if (self.material) {
        ActionMActivity *action = [[ActionMActivity alloc] init];
        action.afterQqueryMerchantActivity = ^(NSMutableArray *activity){
            if(activity){
                
                self.activityList = activity;
                [self.tableView reloadData];
                
            }
        };
        [action doQueryMerchantActivity:[self.material objectForKey:@"id"]];
    
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.activityList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MActivityCell" forIndexPath:indexPath];
    
    cell.activityInfo = [self.activityList objectAtIndex:indexPath.row];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        [self.activityList removeObjectAtIndex:indexPath.row];


            if (self.material) {
                ActionMActivity *action = [[ActionMActivity alloc] init];
                action.afterDeleteMerchantActivity = ^(NSString *result){
                if(result){
    
                    [self.activityList removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
        
                    }
            };
            [action doDeleteMerchantActivity: [self.material objectForKey:@"id"] activity:[[self.activityList objectAtIndex:indexPath.row] objectForKey:@"id"]];
                    
            }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        self.selectRowNumber =[NSNumber numberWithInteger:indexPath.row];
        [self performSegueWithIdentifier:@"goupdateactivity" sender:nil]; //这个方法。跳转页面。 nil 表示不跳转？？？


        
    }
}
- (IBAction)unwindUpdateActivity:(UIStoryboardSegue *)segue {
    if([segue.sourceViewController isKindOfClass:[MActivityCreateTVC class]]){
        MActivityCreateTVC *activitytvc = (MActivityCreateTVC *)segue.sourceViewController;
        ActionMActivity *action = [[ActionMActivity alloc] init];
        action.afterAddMerchantActivity = ^(NSString *result){
            //TODO 获取新的活动内容，本页更新， 可传递过来 ,新增返回内容为id
            NSMutableDictionary *newactivity = [NSMutableDictionary dictionaryWithCapacity:5];
            if (activitytvc.atitle && activitytvc.aintroduce && activitytvc.acredit && activitytvc.aposter && activitytvc.aexpire_time) {
                [newactivity setObject:activitytvc.atitle forKey:@"t"];
                [newactivity setObject:activitytvc.aintroduce forKey:@"in"];
                [newactivity setObject:activitytvc.acredit forKey:@"cr"];
                [newactivity setObject:activitytvc.aposter forKey:@"po"];
                [newactivity setObject:activitytvc.aexpire_time forKey:@"et"];
                 }

            
            [self.activityList addObject:newactivity];
            //考虑更新后，首页活动列表更新
            [self.tableView reloadData];
        };
        [action doAddMerchantActivity:[self.material objectForKey:@"id"] title:activitytvc.atitle introduce:activitytvc.aintroduce credit:activitytvc.acredit poster:activitytvc.aposter expire_time:activitytvc.aexpire_time];
        
    }else if ([segue.sourceViewController isKindOfClass:[MActivityUpdateTVC class]]){
        
        
        MActivityUpdateTVC *activitytvc = (MActivityUpdateTVC *)segue.sourceViewController;
        ActionMActivity *action = [[ActionMActivity alloc] init];
        action.afterUpdateMerchantActivity = ^(NSString *result){
            
            
            
            NSMutableDictionary *newactivity = [NSMutableDictionary dictionaryWithCapacity:6];
            if (activitytvc.atitle && activitytvc.aintroduce && activitytvc.acredit && activitytvc.aposter && activitytvc.aexpire_time) {
                [newactivity setObject:activitytvc.atitle forKey:@"t"];
                [newactivity setObject:activitytvc.aintroduce forKey:@"in"];
                [newactivity setObject:activitytvc.acredit forKey:@"cr"];
                [newactivity setObject:activitytvc.aposter forKey:@"po"];
                [newactivity setObject:activitytvc.aexpire_time forKey:@"et"];
                [newactivity setObject:activitytvc.id forKey:@"id"];

            }
            NSMutableArray *showac = [[NSMutableArray alloc] initWithArray:self.activityList];
            [showac removeObjectAtIndex:[self.selectRowNumber integerValue]];
            
            
            
            self.activityList = [[NSMutableArray alloc] init];
//            [self.activityList removeObjectAtIndex:5];
//            [self.activityList removeObjectAtIndex:[self.selectRowNumber integerValue]];
          //  [self.activityList addObject:newactivity];
            self.activityList = showac;
            
            
            
            
            
            
            
//            //TODO 更新新的活动内容，本页更新， 可传递过来 ,新增返回内容为id
//            if (activitytvc.atitle && activitytvc.aintroduce && activitytvc.acredit && activitytvc.aposter && activitytvc.aexpire_time) {
//                
//                [[self.activityList objectAtIndex:[self.selectRowNumber integerValue]]  setObject:activitytvc.atitle forKey:@"t"];
//                [[self.activityList objectAtIndex:[self.selectRowNumber integerValue]]  setObject:activitytvc.aintroduce forKey:@"in"];
//                [[self.activityList objectAtIndex:[self.selectRowNumber integerValue]]  setObject:activitytvc.acredit forKey:@"cr"];
//                [[self.activityList objectAtIndex:[self.selectRowNumber integerValue]]  setObject:activitytvc.aposter forKey:@"po"];
//                [[self.activityList objectAtIndex:[self.selectRowNumber integerValue]]  setObject:activitytvc.aexpire_time forKey:@"et"];
//                }
//       
//            [self.activityList addObject:newactivity];
            //考虑更新后，首页活动列表更新
            [self.tableView reloadData];
        
        
        };
        
        [action doUpdateMerchantActivity:[self.material objectForKey:@"id"] activity:@"id" title:activitytvc.atitle introduce:activitytvc.aintroduce credit:activitytvc.acredit poster:activitytvc.aposter expire_time:activitytvc.aexpire_time];
        
        }
    
    
    
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"gocreateactivity"]){
//        [segue.destinationViewController setValue:[self.material objectForKey:@"id"] forKey:@"merchant"];
        
    } else if([segue.identifier isEqualToString:@"goupdateactivity"]){
//        [segue.destinationViewController setValue:[self.activityList objectAtIndex:[self.selectRowNumber integerValue]] forKey:@"activity"];
        
            if ([segue.destinationViewController isKindOfClass:[MActivityUpdateTVC class]]) {
                MActivityUpdateTVC *destination = (MActivityUpdateTVC *)segue.destinationViewController;
                destination.activity = [self.activityList objectAtIndex:[self.selectRowNumber integerValue]];
            }

    }

}






//传参不跳转方式
//if ([segue.identifier isEqualToString:@"OneAward"]) {
//    if ([segue.destinationViewController isKindOfClass:[MyOneAwardTVC class]]) {
//        MyOneAwardTVC *destination = (MyOneAwardTVC *)segue.destinationViewController;
//        destination.merchant = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"i"];
//        destination.name = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"t"];
//        destination.logo = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"l"];
//    }
//}

@end
