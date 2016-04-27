//
//  MAssistanceTVC.m
//  Calculus
//
//  Created by ben on 16/2/21.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MAssistanceTVC.h"
#import "Constance.h"

@interface MAssistanceTVC ()
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLBL;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation MAssistanceTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.versionLabel.text = VERSION;
    self.contactNumberLBL.text = CONTACT_NUMBER ;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 1;
            break;
        case 3:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        
    } else if(1 == indexPath.section) {
        
        if (0 == indexPath.row) {
            [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.contactNumberLBL.text];
            NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }else if (1 == indexPath.row) {
        }
    }
    
}



@end
