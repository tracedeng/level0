//
//  MeTVC.m
//  Calculus
//
//  Created by tracedeng on 15/12/11.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MeTVC.h"
#import "MaterialManager.h"
#import "Constance.h"
#import "UIImageView+WebCache.h"
#import "MaterialTVC.h"
#import "FeedbackController.h"
#import "ActionStatistic.h"
#import "UIColor+Extension.h"

@interface MeTVC ()
@property (nonatomic, retain) NSMutableDictionary *material;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation MeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorColor:[UIColor colorWithHex:0xEFEFF4]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"个人中心";
    
    self.material = [NSMutableDictionary dictionaryWithDictionary:[MaterialManager getMaterial]];
    
    //    圆角
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 4.0f;
//    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2.0;
    
//    [MeTVC hideEmptySeparators:self.tableView];

}
//
//+ (void)hideEmptySeparators:(UITableView *)tableView
//{
//    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
//    [tableView setTableFooterView:v];
//    [tableView setTableHeaderView:v];
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self.navigationController setNavigationBarHidden:YES];
//    
//    [UIApplication sharedApplication].statusBarHidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    [self.navigationController setNavigationBarHidden:NO];
//}



- (void)setMaterial:(NSMutableDictionary *)material {
    if (material) {
        _material = material;
        self.nicknameLabel.text = [material objectForKey:@"ni"];
        self.numbersLabel.text = [material objectForKey:@"lo"];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [material objectForKey:@"ava"]];
        //        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path]];
        //        NSString *path = [NSString stringWithFormat:@"%@/%@", QINIUURL, [material objectForKey:@"ava"]];
//        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"logo-consumer"]];

    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 2;
            break;
        case 3:
            rows = 2;
            break;
        default:
            break;
    }
    return rows;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    // Configure the cell...
//    
//    return cell;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 112.0f;
    }
    return 44.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
        }else if (1 == indexPath.row) {
            
        }
    } else if(2 == indexPath.section) {
        if (0 == indexPath.row) {
        }else if (1 == indexPath.row) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps ://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8"]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }else if (1 == section) {
        return 0.01f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return 0.01f;
    }
    
    return 0.0f;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ConsumerMaterial"]) {
        if ([segue.destinationViewController isKindOfClass:[MaterialTVC class]]) {
            MaterialTVC *destination = (MaterialTVC *)segue.destinationViewController;
            destination.material = self.material;
        }
    }
}

- (IBAction)unwindMeUpdateMaterial:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[MaterialTVC class]]) {
        MaterialTVC *source = (MaterialTVC *)segue.sourceViewController;
        if (source.updateMaterialTypeMask & MATERIALTYPEAVATAR) {
            //同时更新头像
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [source.material objectForKey:@"ava"]];
            [self.material setObject:[source.material objectForKey:@"ava"] forKey:@"ava"];
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path]];
        }
        if(source.updateMaterialTypeMask & MATERIALTYPENICKNAME){
            [self.material setObject:[source.material objectForKey:@"ni"] forKey:@"ni"];
            self.nicknameLabel.text = [self.material objectForKey:@"ni"];
        }
        if(source.updateMaterialTypeMask & MATERIALTYPEADDRESS){
            [self.material setObject:[source.material objectForKey:@"lo"] forKey:@"lo"];
            self.numbersLabel.text = [self.material objectForKey:@"lo"];
        }
    }else if ([segue.sourceViewController isKindOfClass:[FeedbackController class]]){
              
        
    }
}

@end
