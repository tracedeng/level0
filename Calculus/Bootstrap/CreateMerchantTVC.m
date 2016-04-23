//
//  CreateMerchantTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/18.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "CreateMerchantTVC.h"
#import "ImageListCVC.h"
#import "ActionMMaterial.h"
#import "ActionQiniu.h"
#import "UIImageView+WebCache.h"
#import "MMaterialManager.h"
#import <CoreLocation/CoreLocation.h>
#import "Constance.h"

@interface CreateMerchantTVC () <UITextFieldDelegate, CLLocationManagerDelegate>
@property (nonatomic, retain) NSString *uploadToken;
@property (nonatomic, retain) NSString *prepath;
@property (nonatomic, retain) NSString *path;

@property (nonatomic, retain) CLLocationManager *locationService;
@property (nonatomic, assign) CLLocationCoordinate2D gps;
@property (nonatomic, retain) NSString *locationName;
//@property (nonatomic, assign) CGFloat longitude;
//@property (nonatomic, assign) CGFloat latitude;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *ratioField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
- (IBAction)createMerchantAction:(id)sender;
@end

@implementation CreateMerchantTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    圆角
//    self.prepath = @"m/logo/15216768674/Dec2715161647";
//    self.path = @"default";
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = 4.0f;

//    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height / 2.0;
    
    self.locationService = [[CLLocationManager alloc] init];
    self.locationService.delegate = self;
    //IOS8.0 启用定位请求，低于此版本不需要请求
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationService requestWhenInUseAuthorization];
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
//    return 1 == section ? 2 : 1;
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 0.0f;
    }
    return 0.01f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 8.0f;
//    }
//    return 0.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 150.0f;
//    }
    }else if (1 == indexPath.section) {
        return 50.0f;
    }else if (2 == indexPath.section) {
        return 50.0f;
    }
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (0 == indexPath.row) {
            //头像，right detail，修改accessory图标
            self.logoImageView.layer.cornerRadius = 4.0f;
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, self.path];
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"icon-add"]];
        }
    }
    
    return cell;
}

//获取7牛上传token，做好准备
- (void)prepareQiniuToken {
    ActionMMaterial *action = [[ActionMMaterial alloc] init];
    action.afterQueryUploadToken = ^(NSDictionary *result) {
        self.uploadToken = [result objectForKey:@"tok"];
        self.prepath = [result objectForKey:@"path"];
    };
    [action doQueryUploadToken:@"dummy" ofResource:@"m_logo"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            // 商家logo
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Album" bundle:[NSBundle mainBundle]];
            ImageListCVC *album = [board instantiateInitialViewController];
            album.bMultiChecked = NO;
            album.checkableCount = 1;
            // 先准备token
            [self prepareQiniuToken];
            [self.navigationController pushViewController:album animated:YES];
        }else if (1 == indexPath.row) {
            //商家名称
        }
    }else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
//            [self.ratioField resignFirstResponder];
            [self.nameField becomeFirstResponder];
        }else if (1 == indexPath.row) {
//            [self.nameField resignFirstResponder];
            [self.ratioField becomeFirstResponder];
        }
    }else if (3 == indexPath.section) {
        [self createMerchantAction:nil];
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
//            [self.material setObject:path forKey:@"logo"];
            self.path = path;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        [action doQiniuUpload:photo token:self.uploadToken path:self.prepath];
    }
}


- (IBAction)createMerchantAction:(id)sender {
    // 创建商家
    NSString *name = self.nameField.text;
    NSString *ratio = self.ratioField.text;
    NSString *address = self.addressField.text;
    if ((name.length == 0) || (ratio.length == 0) || (address.length == 0)) {
        //至少需要商家名称，ratio，位置
        NSString *title = @"请输入商家名称";
        if (ratio.length == 0) {
            title = @"请输入消费金额换积分比例";
        }else if(address.length == 0) {
            title = @"请输入商家地址";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        ActionMMaterial *action = [[ActionMMaterial alloc] init];
        action.afterCreateMerchantOfAccount = ^(NSString *merchant) {
            [MMaterialManager changeMaterialOfKey:@"id" withValue:merchant];
            //进入商家主页
            
            
            NSString *selectButtonOKTitle = NSLocalizedString(@"确定", nil);
            NSString *selectTitle = NSLocalizedString(@"创建商户成功，点击确定跳转到商户主页", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:selectTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectButtonOKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoMerchantAfterCreate", @"destine", nil]];

            }];
            
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];

            
            
        };
        [action doCreateMerchantOfAccount:name logo:(self.path ? self.path : @"default") ratio:[ratio integerValue] address:address longitude:self.gps.longitude latitude:self.gps.latitude];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.addressField.placeholder = @"商家地址";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length <= 0) {
        return;
    }
    // 正向编码，地址 ＝> gps
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo geocodeAddressString:textField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            // 正向编码失败，无效地址
            self.locationName = textField.text;
            self.gps = CLLocationCoordinate2DMake(-1, -1);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"位置输入有误，请点击定位按钮获取地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:alert completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            //取出获取的地理信息数组中的第一个显示在界面上
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            self.locationName = firstPlacemark.name;
//            self.addressField.text = self.locationName;
            self.gps =firstPlacemark.location.coordinate;
            
//            for (CLPlacemark *placemark in placemarks) {
//                DLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name, placemark.locality, placemark.country, placemark.postalCode);
//            }
        }
    }];
}

- (IBAction)clickLocationButton:(id)sender {
    if (![CLLocationManager locationServicesEnabled]) {
        // 提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请前往设置中开启定位" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        self.locationService.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationService.distanceFilter = 100.0f;
        [self.locationService startUpdatingLocation];
        self.addressField.placeholder = @"定位中...";
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.gps = locations[0].coordinate;
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    
    //反向地理编码
    [revGeo reverseGeocodeLocation:locations[0] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && [placemarks count] > 0) {
            NSDictionary *dict = [[placemarks objectAtIndex:0] addressDictionary];
//            self.addressField.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@", [dict objectForKey:@"City"], [dict objectForKey:@"Name"], [dict objectForKey:@"State"], [dict objectForKey:@"Street"], [dict objectForKey:@"SubLocality"], [dict objectForKey:@"SubThoroughfare"], [dict objectForKey:@"Thoroughfare"], [dict objectForKey:@"FormattedAddressLines"], [dict objectForKey:@"Country"]];
            self.locationName = [dict objectForKey:@"Name"];
            self.addressField.text = self.locationName;
        }else{
            // 反向编码失败
            self.addressField.placeholder = @"定位失败";
        }
    }];
}

// 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.addressField.placeholder = @"定位失败";
}


////实现逆地理编码的回调函数
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    if(response.regeocode != nil)
//    {
//        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        //        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
//        //        NSLog(@"ReGeo: %@", result);
//        
//        AMapAddressComponent *address = response.regeocode.addressComponent;
//        NSString *province = address.province;
//        if ([province isEqualToString:@"上海市"] || [province isEqualToString:@"北京市"] || [province isEqualToString:@"天津市"] || [province isEqualToString:@"重庆市"] ) {
//            self.accuratePosition = [NSString stringWithFormat:@"%@%@", province, address.district];
//            
//        } else {
//            self.accuratePosition = [NSString stringWithFormat:@"%@%@", province, address.city];
//        }
//        
//    }else{
//        self.accuratePosition = @"汪星球";
//    }
//    [self.positionButton setTitle:self.accuratePosition forState:UIControlStateNormal];
//}

@end
