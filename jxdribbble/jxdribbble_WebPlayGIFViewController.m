//
//  jxdribbble_WebPlayGIFViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 12/2/13.
//  Copyright (c) 2013 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_WebPlayGIFViewController.h"

@interface jxdribbble_WebPlayGIFViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation jxdribbble_WebPlayGIFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navItem.title = self.titleStr;

    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 240)];
    self.webView.backgroundColor = [UIColor redColor];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self.view addSubview:self.webView];
    
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    tapRec.delegate = self;
    tapRec.numberOfTapsRequired = 1;
    [self.webView addGestureRecognizer:tapRec];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeView
{
    [self.depthViewReference dismissPresentedViewInView:self.presentedInView animated:YES];
}

@end
