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

@interface MaterialTVC ()
@property (nonatomic, retain) NSString *uploadToken;
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
    [self prepareQiniuToken];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取7牛上传token，做好准备
- (void)prepareQiniuToken {
    ActionMaterial *action = [[ActionMaterial alloc] init];
    action.afterModifyAvatar = ^(NSString *token) {
        self.uploadToken = token;
    };
    [action doModifyAvatar];
}

- (void)doQiniuUpload {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *data = [@"Hello, World!" dataUsingEncoding : NSUTF8StringEncoding];
    [upManager putData:data key:@"c/avatar/18688982240" token:self.uploadToken complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%@", info);
        NSLog(@"%@", resp);
    } option:nil];
    
}
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
            [self.navigationController pushViewController:album animated:YES];
            
//            QNUploadManager *upManager = [[QNUploadManager alloc] init];
//            NSData *data = [@"Hello, World!" dataUsingEncoding : NSUTF8StringEncoding];
//            [upManager putData:data key:@"hello" token:token
//                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                          NSLog(@"%@", info);
//                          NSLog(@"%@", resp);
//                      } option:nil];
        }else if (1 == indexPath.row) {
            
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
                NSString *path = [NSString stringWithFormat:@"%@/%@", QINIUURL, [self.material objectForKey:@"ava"]];
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path]];
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

- (IBAction)unwindForUpdateMaterial:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[ImageListCVC class]]) {
//        ImageListCVC *imageList = (ImageListCVC *)segue.sourceViewController;
        //保存已选择的头像图片
//        self.checkedHeadImage = [imageList.currentCheckedImages objectAtIndex:0];
//        [self updateHeadImage:self.checkedHeadImage];
        [self doQiniuUpload];
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
