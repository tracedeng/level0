//
//  FeedbackController.m
//  Calculus
//
//  Created by tracedeng on 16/2/18.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "FeedbackController.h"
#import "ActionStatistic.h"
#import "Constance.h"

@interface FeedbackController ()
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackPlaceholder;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBTN;

- (IBAction)saveBTN:(UIBarButtonItem *)sender;
@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"反馈";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) return YES;     //支持已经输满长度按退格键删除
    
    if (textView.text.length > 199) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.saveBTN.enabled = NO;
        
        self.feedbackPlaceholder.text = @"请输入反馈";
    }else{
        self.saveBTN.enabled = YES;
        self.feedbackPlaceholder.text = @"";
    }
}

// 提交反馈
- (IBAction)saveBTN:(UIBarButtonItem *)sender {
    [self.feedbackTextView resignFirstResponder];
    ActionStatistic *action = [[ActionStatistic alloc] init];
    action.afterFeedback = ^(){
        NSString *selectButtonOKTitle = NSLocalizedString(@"确定", nil);
        NSString *resultTitle = NSLocalizedString(@"反馈成功", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:resultTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectButtonOKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    [action doFeedback:VERSION feedback:self.feedbackTextView.text];

}
@end
