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
#import "Constance.h"

@interface CreateMerchantTVC ()
@property (nonatomic, retain) NSString *uploadToken;
@property (nonatomic, retain) NSString *prepath;
@property (nonatomic, retain) NSString *path;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
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
    self.path = @"default";
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height / 2.0;

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
    return 0 == section ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((0 == indexPath.row) && (0 == indexPath.section)) {
        return 150.0f;
    }
    return 50.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (0 == indexPath.row) {
            //头像，right detail，修改accessory图标
            self.logoImageView.layer.cornerRadius = 4.0f;
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, self.path];
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"icon-alipay"]];
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
        // 创建商家
//        NSString *name = self.nameField.text;
//        if (name.length == 0) {
//            //至少需要商家名称
//        }else{
//            ActionMMaterial *action = [[ActionMMaterial alloc] init];
//            action.afterCreateMerchantOfAccount = ^(NSString *merchant) {
//                //进入商家主页
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoMerchant", @"destine", nil]];
//            };
//            [action doCreateMerchantOfAccount:name logo:self.path];
//        }
//        self.path = self.prepath;
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
    if (name.length == 0) {
        //至少需要商家名称
    }else{
        ActionMMaterial *action = [[ActionMMaterial alloc] init];
        action.afterCreateMerchantOfAccount = ^(NSString *merchant) {
            [MMaterialManager changeMaterialOfKey:@"id" withValue:merchant];
            //进入商家主页
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoMerchantAfterCreate", @"destine", nil]];
        };
        [action doCreateMerchantOfAccount:name logo:self.path];
    }
}
@end
