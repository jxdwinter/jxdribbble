//
//  jxdribbble_TableViewCell.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-12.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_TableViewCell.h"

@implementation jxdribbble_TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.frame = CGRectMake(0.0, 0.0, 320.0, 255.0);

        
        self.shot_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 225.0)];
        self.shot_imageView.userInteractionEnabled = YES;
        self.shot_imageView.opaque = YES;
        [self.contentView addSubview:self.shot_imageView];
        
        self.gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 193.0, 30.0, 30.0)];
        self.gifImageView.image = [UIImage imageNamed:@"Gif"];
        [self.shot_imageView addSubview:self.gifImageView];
        
        UIImageView *viewsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 230.0, 17.0, 17.0)];
        viewsImageView.image = [UIImage imageNamed:@"eye"];
        [self.contentView addSubview:viewsImageView];

        self.viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(33.0, 230.0, 65.0, 15.0)];
        self.viewsLabel.font = [jxdribbble_Global globlaFontWithSize:10];
        self.viewsLabel.textColor = [jxdribbble_Global globlaTextColor];
        self.viewsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.viewsLabel];
        
        UIImageView *likesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150.0, 233.0, 10.0, 10.0)];
        likesImageView.image = [UIImage imageNamed:@"heart"];
        [self.contentView addSubview:likesImageView];
        
        self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(165.0, 230.0, 45.0, 15.0)];
        self.likesLabel.font = [jxdribbble_Global globlaFontWithSize:10];
        self.likesLabel.textColor = [jxdribbble_Global globlaTextColor];
        [self.contentView addSubview:self.likesLabel];
        
        
        UIImageView *commentsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270.0, 233.0, 10.0, 10.0)];
        commentsImageView.image = [UIImage imageNamed:@"spech"];
        [self.contentView addSubview:commentsImageView];
        
        self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(285.0, 230.0, 35.0, 15.0)];
        self.commentsLabel.font = [jxdribbble_Global globlaFontWithSize:10];
        self.commentsLabel.textColor = [jxdribbble_Global globlaTextColor];
        [self.contentView addSubview:self.commentsLabel];
        
        self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        self.hud.mode = MBProgressHUDModeAnnularDeterminate;
        
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
