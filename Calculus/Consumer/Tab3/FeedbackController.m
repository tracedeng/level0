//
//  FeedbackController.m
//  Calculus
//
//  Created by tracedeng on 16/2/18.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "FeedbackController.h"
#import "ActionStatistic.h"

@interface FeedbackController ()
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackPlaceholder;
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

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
//        self.saveBTN.enabled = NO;
        
        self.feedbackPlaceholder.text = @"请输入反馈";
        //        self.canSub21mitMask &= 0xfb;
        //        [textView resignFirstResponder];
    }else{
//        self.saveBTN.enabled = [self.feedbackContent isEqualToString:self.feedbackTextView.text] ? NO : YES;
        self.feedbackPlaceholder.text = @"";
        //        self.canSubmitMask |= 0x4;
    }
    if (textView.text.length > 200) {
        
        self.feedbackTextView.text = [self.feedbackTextView.text substringToIndex:200];
    }
    self.feedbackContent = self.feedbackTextView.text;
    
    
    
    
}
- (IBAction)saveBTN:(UIBarButtonItem *)sender {

    // 提交反馈
    ActionStatistic *action = [[ActionStatistic alloc] init];
    action.afterFeedback = ^(){
        
        
        NSString *selectButtonOKTitle = NSLocalizedString(@"确定", nil);
        NSString *resultTitle = NSLocalizedString(@"提交结果", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:resultTitle message:@"TODO 提交成功否" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectButtonOKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    };
    [action doFeedback:@"v1.0" feedback:self.feedbackContent];

}
@end
