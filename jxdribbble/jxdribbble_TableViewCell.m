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
        self.shot_imageView.opaque = YES;
        [self.contentView addSubview:self.shot_imageView];
        
        UIImageView *viewsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 230.0, 17.0, 17.0)];
        viewsImageView.image = [UIImage imageNamed:@"eye"];
        [self.contentView addSubview:viewsImageView];

        self.viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(33.0, 230.0, 65.0, 15.0)];
        self.viewsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.viewsLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.viewsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.viewsLabel];
        
        UIImageView *likesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150.0, 233.0, 10.0, 10.0)];
        likesImageView.image = [UIImage imageNamed:@"heart"];
        [self.contentView addSubview:likesImageView];
        
        self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(165.0, 230.0, 45.0, 15.0)];
        self.likesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.likesLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [self.contentView addSubview:self.likesLabel];
        
        
        UIImageView *commentsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270.0, 233.0, 10.0, 10.0)];
        commentsImageView.image = [UIImage imageNamed:@"spech"];
        [self.contentView addSubview:commentsImageView];
        
        self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(285.0, 230.0, 35.0, 15.0)];
        self.commentsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.commentsLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [self.contentView addSubview:self.commentsLabel];
        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.center = CGPointMake(self.shot_imageView.center.x - 10.0, self.shot_imageView.center.y);
        [self.shot_imageView addSubview:self.activityIndicatorView];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
