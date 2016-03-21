//
//  MSettingTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MSettingTVC.h"
#import "ActionAccount.h"
#import "UIImageView+WebCache.h"


@interface MSettingTVC ()
- (IBAction)logoutAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@property (nonatomic, assign) NSInteger cacheSize;
@property (weak, nonatomic) IBOutlet UITextField *currentAccountLabel;

@end

@implementation MSettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/ImageCaches"];
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog(@"%@",[dict objectForKey:NSFileSize]);

    self.cacheSize = [[SDImageCache sharedImageCache] getSize];
    
    self.currentAccountLabel.text = [@"当前账号：" stringByAppendingString:[self.material objectForKey:@"fou"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)setCacheSize:(NSInteger)cacheSize {
    if (cacheSize == 0) {
        self.cacheSizeLabel.text = @"0";
        
    }else{
        
        _cacheSize = cacheSize / 1024 /1024;
        if (_cacheSize < 1) {
            self.cacheSizeLabel.text = @"1M";
        }else{
            self.cacheSizeLabel.text = [NSString stringWithFormat:@"%ldM", (long)_cacheSize];
        }
        
    }
    _cacheSize = cacheSize;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 2;
    }else if (1 == section) {
        return 1;
    }else if (2 == section) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 20.0f;
    }else if (1 == section) {
        return 20.0f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }else if (1 == section) {
        return 0.01f;
    }
    return 0.01f;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            //clear cache
            NSString *selectButtonOKTitle = NSLocalizedString(@"确定", nil);
            NSString *selectButtonCancelTitle = NSLocalizedString(@"取消", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectButtonOKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [[SDImageCache sharedImageCache] clearDisk];
                self.cacheSize = [[SDImageCache sharedImageCache] getSize];
                
                
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:selectButtonCancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else if (1 == indexPath.row) {
            //切换版本
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoBootstrap", @"destine", nil]];
        }
    }else if(1 == indexPath.section) {
        //登出
        [ActionAccount doLogout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoAccount", @"destine", nil]];
    }
}

//设置Section的Footer
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    if (0 == section) {
//        return nil;
//    }else if (1 == section) {
//        return @"当前登录";
//    }
//    return nil;
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    
//}
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

- (IBAction)logoutAction:(id)sender {
    //登出
    [ActionAccount doLogout];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoAccount", @"destine", nil]];
}
@end
