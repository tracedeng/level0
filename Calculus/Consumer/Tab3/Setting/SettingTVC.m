//
//  SettingTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "SettingTVC.h"
#import "ActionAccount.h"
#import "UIImageView+WebCache.h"

@interface SettingTVC ()
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@property (nonatomic, assign) NSInteger cacheSize;

@end

@implementation SettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.cacheSize.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[SDImageCache sharedImageCache] getSize]];
//    self.cacheSize.
    self.cacheSize = [[SDImageCache sharedImageCache] getSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 2;
    }else if (1 == section) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
    [ActionAccount doLogout];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoAccount", @"destine", nil]];
}

// 当用户点击非picker区域时,退出
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:self.view];
//    
//    if (CGRectContainsPoint(self.picker.frame, point)) {
//        
//    }else{
//        [_picker hide];
//    }
//}
@end
