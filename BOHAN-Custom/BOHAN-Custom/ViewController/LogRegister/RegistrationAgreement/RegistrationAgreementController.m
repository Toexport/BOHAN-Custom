//
//  RegistrationAgreementController.m
//  DDAYGO
//
//  Created by Summer on 2017/12/28.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "RegistrationAgreementController.h"
#import "FileHeader.pch"
@interface RegistrationAgreementController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView * webView;

@end

@implementation RegistrationAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.webView.opaque = NO; //设置web的opaque
    [self initUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(adjustStatusBar:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)initUI {
    [self.webView setDelegate:self];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bohan-smartec.com/"]];
    self.title = Localize(@"伯瀚");
    [self.webView loadRequest:request];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    //创建UIActivityIndicatorView背底半透明View
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZP_Width, ZP_height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setCenter:view.center];
    activityIndicator.color = [UIColor grayColor];
    [view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    NSLog(@"webViewDidStartLoad");
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [activityIndicator stopAnimating];
    UIView * view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"didFailLoadWithError:%@", error);
}

// 热点被接入，子类重写
- (void)adjustStatusBar:(NSNotification *)notification {
    NSValue * rectValue = [notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusRect = [rectValue CGRectValue];
    CGFloat height = statusRect.size.height;
    if (height > 20) {
        appD.window.frame = CGRectMake(0, 0, ZP_Width, ZP_height);
    }else{
        appD.window.frame = CGRectMake(0, 0, ZP_Width, ZP_height);
    }
}

@end
