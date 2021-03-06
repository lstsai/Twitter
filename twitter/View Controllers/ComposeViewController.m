//
//  ComposeViewController.m
//  twitter
//
//  Created by laurentsai on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"

@interface ComposeViewController ()<UITextViewDelegate>

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetTextView.delegate=self;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.profileImage setImageWithURL:appDelegate.currentUser.profileImageURL];
    self.profileImage.layer.cornerRadius=self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds=YES;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth=1;
    self.profileImage.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    
    [self.tweetTextView setClearsOnInsertion:YES];
}
- (IBAction)sendTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.tweetTextView.text completion:^(Tweet *senttweet, NSError * error) {
        if (senttweet) {
            NSLog(@"Successfully posted the tweet");
            [self.delegate didTweet:senttweet];
        } else {
            NSLog(@"😫😫😫 Error posting tweet: %@", error.localizedDescription);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (IBAction)closeTweet:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // TODO: Check the proposed new text character count
   // Allow or disallow the new text
    int charLimit=281;
    //see if user is allowed to add the new text
    NSString *newText= [self.tweetTextView.text stringByReplacingCharactersInRange:range withString:text];
    if(newText.length>260)
        self.charCount.textColor=[UIColor redColor];
    else
        self.charCount.textColor=[UIColor blackColor];
    if(newText.length < charLimit)
        self.charCount.text= [NSString stringWithFormat:@"%lu",280-newText.length];
    
    return newText.length < charLimit;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
