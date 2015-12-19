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



@interface MaterialTVC ()
@property (nonatomic, retain) NSString *uploadToken;
@property (nonatomic, retain) NSString *path;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation MaterialTVC{
    NSInteger row1;
    NSInteger row2;
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
                    [self.material setObject:@"male" forKey:@"gender"];
                    NSIndexPath *cell=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cell,nil] withRowAnimation:UITableViewRowAnimationNone];
                };
                [gender doModifyGender:@"male"];
                
            }];
            
            UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:selectButtonFemaleTitle style:UIAlertControllerStyleActionSheet handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
                
                ActionMaterial *gender = [[ActionMaterial alloc] init];
                gender.afterModifyGender = ^(NSDictionary *materail){
                    [self.material setObject:@"female" forKey:@"gender"];
                    
                    NSIndexPath *cell=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:cell,nil] withRowAnimation:UITableViewRowAnimationNone];

                    
                };
                [gender doModifyGender:@"female"];

            }];
            
            // Add the actions.
            [alertController addAction:maleAction];
            [alertController addAction:femaleAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else if (4 == indexPath.row) {
            
            
            //Citylist
            row1 = 0;
            row2 = 0;
            self.cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, HEIGHT/2  , WIDTH, HEIGHT/2)];
            self.cityPicker.tag = 0;
            
            self.cityPicker.delegate = self;
            self.cityPicker.dataSource = self;
            self.cityPicker.showsSelectionIndicator = YES;
            [self.view addSubview:self.cityPicker];
            self.cityPicker.backgroundColor = [UIColor grayColor];
            
            self.cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT/2, WIDTH, 40)];
            self.cityLabel.textAlignment = NSTextAlignmentCenter;
            self.cityLabel.backgroundColor = [UIColor whiteColor];
            self.cityLabel.text = @"dfadafdafd";
//

            self.selectcancel = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT/2, WIDTH/4, 30)];
            self.selectcancel.textAlignment = NSTextAlignmentCenter;
            self.selectcancel.backgroundColor = [UIColor whiteColor];
            self.selectcancel.text = NSLocalizedString(@"取消", nil);
            [self.view addSubview:self.selectcancel];
            
            self.selectok = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*3/4, HEIGHT/2, WIDTH/4, 30)];
            self.selectok.textAlignment = NSTextAlignmentCenter;
            self.selectok.backgroundColor = [UIColor whiteColor];
            self.selectok.text = NSLocalizedString(@"完成", nil);;
            [self.view addSubview:self.selectok];
            
            
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
                         break;
            }
            case 3:
            {
                if ([[self.material objectForKey:@"gender"]  isEqual: @"male"]) {
                    cell.detailTextLabel.text = NSLocalizedString(@"男", nil);
                }else if ([[self.material objectForKey:@"gender"]  isEqual:@"female"]){
                    cell.detailTextLabel.text = NSLocalizedString(@"女", nil);
                }
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


//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.cityPicker) {
        return 2;
    }
    else
        return 1;
}

//返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    

    if (component == 0) {
        return [YMUtils getCityData].count;
        
    }
    else if (component == 1) {
        NSArray *array = [YMUtils getCityData][row1][@"children"];
        if ((NSNull*)array != [NSNull null]) {
            return array.count;
        }
        return 0;
    }
    else {
        NSArray *array = [YMUtils getCityData][row1][@"children"];
        if ((NSNull*)array != [NSNull null]) {
            NSArray *array1 = [YMUtils getCityData][row1][@"children"][row2][@"children"];
            if ((NSNull*)array1 != [NSNull null]) {
                return array1.count;
            }
            return 0;
        }
        return 0;
    }
}
//设置当前行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component == 0) {
        return [YMUtils getCityData][row][@"name"];
    }
    else if (component == 1) {
        return [YMUtils getCityData][row1][@"children"][row][@"name"];
    }
    return nil;
    
}
//选择的行数
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        row1 = row;
        row2 = 0;
        [self.cityPicker reloadComponent:1];
        
    }
    else if (component == 1){
        row2 = row;
    }
    NSInteger cityRow1 = [self.cityPicker selectedRowInComponent:0];
    NSInteger cityRow2 = [self.cityPicker selectedRowInComponent:1];
    NSMutableString *str = [[NSMutableString alloc]init];
    [str appendString:[YMUtils getCityData][cityRow1][@"name"]];
    NSArray *array = [YMUtils getCityData][cityRow1][@"children"];
    if ((NSNull*)array != [NSNull null]) {
        [str appendString:[YMUtils getCityData][cityRow1][@"children"][cityRow2][@"name"]];
        NSArray *array1 = [YMUtils getCityData][cityRow1][@"children"][cityRow2][@"children"];
    }
    self.cityLabel.text = str;
}
//每行显示的文字样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 107, 30)];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    if (component == 0) {
        titleLabel.text = [YMUtils getCityData][row][@"name"];
    }
    else if (component == 1) {
        titleLabel.text = [YMUtils getCityData][row1][@"children"][row][@"name"];
    }
    else {
        titleLabel.text = [YMUtils getCityData][row1][@"children"][row2][@"children"][row][@"name"];
    }
    return titleLabel;

    
}
@end
