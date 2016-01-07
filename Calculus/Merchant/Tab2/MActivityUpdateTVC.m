//
//  MActivityUpdateTVC.m
//  Calculus
//
//  Created by ben on 16/1/5.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MActivityUpdateTVC.h"
#import "MActivityExpireVC.h"
#import "MActivityTVC.h"

@interface MActivityUpdateTVC ()
@property (weak, nonatomic) IBOutlet UITextField *atitleTXT;
@property (weak, nonatomic) IBOutlet UITextField *acreditTXT;
@property (weak, nonatomic) IBOutlet UILabel *aexpireTXT;
@property (weak, nonatomic) IBOutlet UITextView *aintroduceTXT;

@end

@implementation MActivityUpdateTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.atitle = [self.activity objectForKey:@"t"];
    self.acredit = [NSString stringWithFormat:@"%@",[self.activity objectForKey:@"cr"] ];
    self.aintroduce = [self.activity objectForKey:@"in"];
    self.aexpire_time = [self.activity objectForKey:@"et"];
    self.aposter = @"TODO POSTER";
    self.id = [self.activity objectForKey:@"id"];
    
    
    
    self.atitleTXT.text = self.atitle;
    self.acreditTXT.text = self.acredit;
    self.aintroduceTXT.text = self.aintroduce;
    self.aexpireTXT.text = self.aexpire_time;
    
    self.atitleTXT.delegate = self;
    self.acreditTXT.delegate = self;
    self.aintroduceTXT.delegate = self;

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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



- (IBAction)unwindUpdateExpire:(UIStoryboardSegue *)segue {
    if([segue.sourceViewController isKindOfClass:[MActivityExpireVC class]]){
        MActivityExpireVC *activitytvc = (MActivityExpireVC *)segue.sourceViewController;
        
        self.aexpire_time = activitytvc.aexpire;
        self.aexpireTXT.text = activitytvc.aexpire;
    }
    
    
    
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //TODO 判断各种按键是否正常
    if (string.length == 0){
        //TODO 退格触发问题无法赋值
        //        textField.text = [textField.text substringToIndex:[textField.text length] -1];
        //self.exchangeRate = [self.exchangeRateTXT.text substringToIndex:[self.exchangeRateTXT.text length] -1];
        return YES;     //支持已经输满长度按退格键删除
    }
    if (textField == self.atitleTXT) {
        if (textField.text.length > 15) {
            return NO;
        }else{
            self.atitle = [self.atitleTXT.text stringByAppendingString:string];
            
        }
    }else if (textField == self.acreditTXT){
        if (textField.text.length > 15) {
            return NO;
        }else{
            self.acredit = [self.acreditTXT.text stringByAppendingString:string];
            
        }
    }
    return YES;
    
}
-(void)textViewDidChange:(UITextView *)textView{
    self.aintroduce = textView.text;
}


@end
