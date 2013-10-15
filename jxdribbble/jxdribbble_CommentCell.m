//
//  jxdribbble_CommentCell.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-14.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_CommentCell.h"

@implementation jxdribbble_CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 30.0, 30.0)];
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 15.0;
        [self addSubview:self.avatarImageView];
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 15.0, 150.0, 15.0)];
        self.usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        self.usernameLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        [self addSubview:self.usernameLabel];
        
        self.bodyLabel = [[UILabel alloc] init];
        self.bodyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        //self.bodyLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        self.bodyLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [self.bodyLabel setNumberOfLines:0];
        self.bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.bodyLabel];
        
        
        self.likesLabel = [[UILabel alloc] init];
        self.likesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        self.likesLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.likesLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.likesLabel];
        
        self.created_atLabel = [[UILabel alloc] init];
        self.created_atLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.created_atLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.created_atLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.created_atLabel];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
