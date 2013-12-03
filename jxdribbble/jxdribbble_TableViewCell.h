//
//  jxdribbble_TableViewCell.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-12.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jxdribbble_shots.h"
#import "MBProgressHUD.h"

@interface jxdribbble_TableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *shot_imageView;

@property (nonatomic, strong) UILabel *viewsLabel;
@property (nonatomic, strong) UILabel *likesLabel;
@property (nonatomic, strong) UILabel *commentsLabel;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UIImageView *gifImageView;

@end
