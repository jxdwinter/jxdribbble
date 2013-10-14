//
//  jxdribbble_CommentCell.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-14.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jxdribbble_comments.h"

@interface jxdribbble_CommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView ;
@property (nonatomic, strong) UILabel *usernameLabel ;
@property (nonatomic, strong) UILabel *bodyLabel ;
@property (nonatomic, strong) UILabel *likesLabel ;
@property (nonatomic, strong) UILabel *created_atLabel ;

@end
