//
//  jxdribbble_WebViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 11/8/13.
//  Copyright (c) 2013 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_WebViewController.h"

@interface jxdribbble_WebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation jxdribbble_WebViewController

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
	// Do any additional setup after loading the view.

    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_spinner setCenter:CGPointMake(300.0 , 20.0)];
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
    [self navigationItem].rightBarButtonItem = barButton;
    
    self.title = self.titleString;
    self.webView  = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 64.0, 320.0,self.view.bounds.size.height - 64.0 - 49.0)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_spinner stopAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}


- (void)backToPreViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
