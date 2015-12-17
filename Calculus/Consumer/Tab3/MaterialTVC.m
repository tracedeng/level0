//
//  MaterialTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MaterialTVC.h"
#import "ImageListCVC.h"
#import "UIImageView+WebCache.h"
#import "ActionMaterial.h"
#import "ImageListCVC.h"
#import "QiniuSDK.h"
#import "Constance.h"
#import "ActionQiniu.h"

@interface MaterialTVC ()
@property (nonatomic, retain) NSString *uploadToken;
@property (nonatomic, retain) NSString *path;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation MaterialTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取7牛上传token，做好准备
- (void)prepareQiniuToken {
    ActionMaterial *action = [[ActionMaterial alloc] init];
    action.afterQueryUploadToken = ^(NSDictionary *result) {
        self.uploadToken = [result objectForKey:@"tok"];
        self.path = [result objectForKey:@"path"];
    };
    [action doQueryUploadToken];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self performSegueWithIdentifier:@"unwindMeUpdateMaterial" sender:nil];
    }
}


//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
//        [self performSegueWithIdentifier:@"unwindMeUpdateMaterial" sender:self];
//    }
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
            
        }else if (3 == indexPath.row) {
            NSString *selectButtonMaleTitle = NSLocalizedString(@"男", nil);
            NSString *selectButtonFemaleTitle = NSLocalizedString(@"女", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            // Create the actions.
            UIAlertAction *maleAction = [UIAlertAction actionWithTitle:selectButtonMaleTitle style:UIAlertViewStyleSecureTextInput handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
               
                ActionMaterial *gender = [[ActionMaterial alloc] init];
                gender.afterModifyGender = ^(NSDictionary *materail){
                    
                };
                [gender doModifyGender:@"male"];
                
            }];
            
            UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:selectButtonFemaleTitle style:UIAlertControllerStyleActionSheet handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
                
                ActionMaterial *gender = [[ActionMaterial alloc] init];
                gender.afterModifyGender = ^(NSDictionary *materail){
                    
                };
                [gender doModifyGender:@"female"];

            }];
            
            // Add the actions.
            [alertController addAction:maleAction];
            [alertController addAction:femaleAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //头像，right detail，修改accessory图标
                NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [self.material objectForKey:@"ava"]];
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
                break;
            }
            case 1:
            {
                //昵称，right detail
                cell.detailTextLabel.text = [self.material objectForKey:@"ni"];
                break;
            }
            case 2:
            {
//                //TODO...性别，right detail，修改accessory图标
//                //                cell.detailTextLabel.text = (self.lastSex == 1) ? @"男" : @"女";
//                cell.imageView.image = [UIImage imageNamed:@"icon-sexy"];
//                //                cell.textLabel.text = @"性别";
//                if (self.lastSex == 2) {
//                    self.sexyImage.image = self.sexy;
//                }else{
//                    self.sexyImage.image = (self.lastSex == 1) ? self.male : self.female;
//                }

                break;
            }
            case 3:
            {
                break;
            }
            case 4:
            {
                //TODO...地区，right detail，是否用用户位置定位
                cell.detailTextLabel.text = [self.material objectForKey:@"lo"];
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
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
            [self.material setObject:path forKey:@"ava"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            更新用户头像资料
            ActionMaterial *action2 = [[ActionMaterial alloc] init];
            [action2 doModifyAvatar:path];
            self.updateMaterialTypeMask |= MATERIALTYPEAVATAR;
        };
        [action doQiniuUpload:photo token:self.uploadToken path:self.path];
    }
//    if ([segue.sourceViewController isKindOfClass:[ class]]) {
//        EditNicknameIntroduce *edit = (EditNicknameIntroduce *)segue.sourceViewController;
//        switch (edit.type) {
//            case EEDITTYPENICKNAME:
//                [self updateNickname:edit.info];
//                break;
//            case EEDITTYPEINTRODUCE:
//                [self updateIntroduce:edit.info];
//                break;
//            default:
//                break;
//        }
//    }else if ([segue.sourceViewController isKindOfClass:[EditCityTVC class]]){
//        EditCityTVC *edit = (EditCityTVC *)segue.sourceViewController;
//        [self updateLocation:@"CN" province:edit.checkedProvince city:edit.checkedCity];
//    }
}
@end
