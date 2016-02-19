//
//  FeedbackController.m
//  Calculus
//
//  Created by tracedeng on 16/2/18.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "FeedbackController.h"

@interface FeedbackController ()
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackPlaceholder;

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
    if (textView.text.length == 0) {
        self.feedbackPlaceholder.text = @"请输入活动详细描述";
//        self.canSubmitMask &= 0xfb;
        //        [textView resignFirstResponder];
    }else{
        self.feedbackPlaceholder.text = @"";
//        self.canSubmitMask |= 0x4;
    }
    self.feedbackContnt = textView.text;
    
}
@end
