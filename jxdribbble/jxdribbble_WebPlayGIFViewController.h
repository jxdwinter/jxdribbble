//
//  jxdribbble_WebPlayGIFViewController.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 12/2/13.
//  Copyright (c) 2013 Jiang Xiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFDepthView/JFDepthView.h"

@interface jxdribbble_WebPlayGIFViewController : UIViewController
@property (weak, nonatomic) JFDepthView* depthViewReference;
@property (weak, nonatomic) UIView* presentedInView;
@property (copy, nonatomic) NSString *urlStr;
- (IBAction)closeView:(id)sender;
@end
