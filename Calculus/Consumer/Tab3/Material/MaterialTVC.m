//
//  MaterialTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//
#define WIDTH  self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height

#import "MaterialTVC.h"
#import "ImageListCVC.h"
#import "UIImageView+WebCache.h"
#import "ActionMaterial.h"
#import "ImageListCVC.h"
#import "QiniuSDK.h"
#import "Constance.h"
#import "ActionQiniu.h"
#import "YMUtils.h"
#import "MeNickNameVC.h"

#import "PickView.h"


@interface MaterialTVC ()<PickViewDelegate>
@property (nonatomic, retain) NSString *uploadToken;
@property (nonatomic, retain) NSString *path;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic, strong) PickView *picker;
@property (nonatomic, strong) NSArray *cities;

@end

@implementation MaterialTVC

- (NSArray *)cities{
    if (_cities == nil) {
        _cities = @[@[@"111",@"222",@"333",@"444",@"555"],@[@"上海",@"北京",@"广州",@"深圳"]];
    }
    return _cities;
}

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 1;
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
            // 更新头像
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Album" bundle:[NSBundle mainBundle]];
            ImageListCVC *album = [board instantiateInitialViewController];
            album.bMultiChecked = NO;
            album.checkableCount = 1;
            // 先准备token
            [self prepareQiniuToken];
            [self.navigationController pushViewController:album animated:YES];
        }else if (1 == indexPath.row) {
            
        }else if (2 == indexPath.row) {
            NSString *selectButtonMaleTitle = NSLocalizedString(@"男", nil);
            NSString *selectButtonFemaleTitle = NSLocalizedString(@"女", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            // Create the actions.
            UIAlertAction *maleAction = [UIAlertAction actionWithTitle:selectButtonMaleTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                ActionMaterial *gender = [[ActionMaterial alloc] init];
                gender.afterModifyGender = ^(NSDictionary *materail){
                    [self.material setObject:@"male" forKey:@"sex"];
                    NSIndexPath *cell=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cell,nil] withRowAnimation:UITableViewRowAnimationNone];
                };
                [gender doModifyGender:@"male"];
            }];
            
            UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:selectButtonFemaleTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                ActionMaterial *gender = [[ActionMaterial alloc] init];
                gender.afterModifyGender = ^(NSDictionary *materail){
                    [self.material setObject:@"female" forKey:@"sex"];
                    
                    NSIndexPath *cell=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cell,nil] withRowAnimation:UITableViewRowAnimationNone];

                };
                [gender doModifyGender:@"female"];
            }];
            
            // Add the actions.
            [alertController addAction:maleAction];
            [alertController addAction:femaleAction];
            
//            [self presentViewController:alertController animated:YES completion:nil];
            [self presentViewController: alertController animated: YES completion:^{
                alertController.view.superview.userInteractionEnabled = YES;
                [alertController.view.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(alertControllerBackgroundTapped)]];
                }];
        }else if (3 == indexPath.row) {
            self.picker = [[PickView alloc] initWithMode:PickViewTypeCustom target:self title:nil];
//            _picker.maskViewColor = [UIColor redColor];
            _picker.pickerData = self.cities;
            
            [self.view addSubview:_picker];
            [_picker show];
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
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"logo-consumer"]];
                self.avatarImageView.layer.cornerRadius = 4.0f;
                self.avatarImageView.clipsToBounds = YES;
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
                NSString *sex = [self.material objectForKey:@"sex"];
                if ([ sex isEqual: @"male"]) {
                    cell.detailTextLabel.text = NSLocalizedString(@"男", nil);
                }else if ([sex  isEqual:@"female"]){
                    cell.detailTextLabel.text = NSLocalizedString(@"女", nil);
                }else{
                    cell.detailTextLabel.text = @"";
                }
                break;
            }
            case 3:
            {
                //TODO...地区，right detail，是否用用户位置定位
                cell.detailTextLabel.text = [self.material objectForKey:@"lo"];
                break;
            }
            case 4:
            {
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [self.material objectForKey:@"nu"];
        }
    }
    
    return cell;
}

- (void)alertControllerBackgroundTapped
{
    [self dismissViewControllerAnimated: YES completion: nil];
}


// 当用户点击非picker区域时,退出
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.picker.frame, point)) {
        
    }else{
        [_picker hide];
    }
}

- (void)pickView:(PickView *)pickView didClickButtonConfirm:(id)data {
    if (self.picker.pickerMode == PickViewTypeCustom) {
        DLog(@"%@", data);
        NSString *location = [data[0] stringByAppendingString:data[1]];;
        
        ActionMaterial *actionlocation = [[ActionMaterial alloc] init];
        actionlocation.afterModifyLocation = ^(NSDictionary *materail){
            [self.material setObject:location forKey:@"lo"];
            self.locationLabel.text = location;
            self.updateMaterialTypeMask |= MATERIALTYPEADDRESS;
            
        };
        [actionlocation doModifyLocation:location];
        
    }else{
        DLog(@"%@",data);
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
            [self.material setObject:path forKey:@"ava"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            更新用户头像资料
            ActionMaterial *action2 = [[ActionMaterial alloc] init];
            [action2 doModifyAvatar:path];
            self.updateMaterialTypeMask |= MATERIALTYPEAVATAR;
        };
        [action doQiniuUpload:photo token:self.uploadToken path:self.path];
    }
    else if([segue.sourceViewController isKindOfClass:[MeNickNameVC class]]){
        MeNickNameVC *nicknamevc = (MeNickNameVC *)segue.sourceViewController;
        ActionMaterial *action = [[ActionMaterial alloc] init];
        action.afterModifyNickName = ^(NSDictionary *materail){
            [self.material setObject:nicknamevc.nickName forKey:@"ni"];
            //[self.navigationController popViewControllerAnimated:YES];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

            self.updateMaterialTypeMask |= MATERIALTYPENICKNAME;

        };
        [action doModifyNickName:nicknamevc.nickName];
        
    }
}


#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gonickname"]){
        // [segue.destinationViewController setValue:self.material forKey:@"material"];
        [segue.destinationViewController setValue:[self.material objectForKey:@"ni"] forKey:@"nickName"];
    }
}
@end
