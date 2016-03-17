//
//  MerchantAddressVC.m
//  Calculus
//
//  Created by ben on 15/12/26.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantAddressVC.h"
#import "ActionMMaterial.h"
#import "MMaterialTVC.h"


@interface MerchantAddressVC () 
//@property (weak, nonatomic) IBOutlet UITextField *merchantAddressTXT;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *geoPlaceholder;
@property (nonatomic, retain) CLLocationManager *locationService;
@property (nonatomic, assign) CLLocationCoordinate2D gps;
@property (nonatomic, retain) NSString *locationName;

@end

@implementation MerchantAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.merchantAddressTXT.text = self.merchantAddress;
//    self.merchantAddressTXT.delegate = self;
    self.contentTextView.text = self.merchantAddress;
    if (self.self.merchantAddress.length) {
        self.placeholderLabel.text = @"";
    }
    
    self.locationService = [[CLLocationManager alloc] init];
    self.locationService.delegate = self;
    [self.locationService requestWhenInUseAuthorization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"unwindUpdateMMeterialMerchantAddress"]){
        self.merchantAddress = self.contentTextView.text;
        self.latitude = self.gps.latitude;
        self.longitude = self.gps.longitude;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) return YES;     //支持已经输满长度按退格键删除
    
    if (textView.text.length > 50) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.saveButton.enabled = NO;
        self.placeholderLabel.text = @"商户地址";

    }else{
        self.saveButton.enabled = [self.merchantAddress isEqualToString:self.contentTextView.text] ? NO : YES;
        self.placeholderLabel.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length <= 0) {
        return;
    }
    // 正向编码，地址 ＝> gps
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo geocodeAddressString:textView.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            // 正向编码失败，无效地址
            self.locationName = textView.text;
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
            textView.text = self.locationName;
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
        self.geoPlaceholder.text = @"定位中...";
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
            self.locationName = [NSString stringWithFormat:@"%@%@%@", [dict objectForKey:@"State"],  [dict objectForKey:@"SubLocality"], [dict objectForKey:@"Street"]];
            self.contentTextView.text = self.locationName;
            self.geoPlaceholder.text = @"";
            self.saveButton.enabled = [self.merchantAddress isEqualToString:self.contentTextView.text] ? NO : YES;
        }else{
            // 反向编码失败
            self.geoPlaceholder.text = @"定位失败";
        }
    }];
}

// 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.geoPlaceholder.text = @"定位失败";
}


@end
