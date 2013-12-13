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
        [self.contentView addSubview:self.avatarImageView];
        
        self.avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        [self.avatarImageView addSubview:self.avatarButton];
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 12.0, 150.0, 18.0)];
        self.usernameLabel.font = [jxdribbble_Global globlaFontWithSize:15];
        self.usernameLabel.textColor = [jxdribbble_Global globlaColor];
        [self.contentView addSubview:self.usernameLabel];
        
        self.bodyLabel = [[STTweetLabel alloc] init];
        self.bodyLabel.textColor = [jxdribbble_Global globlaTextColor];
        [self.bodyLabel setNumberOfLines:0];
        self.bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.bodyLabel];

        self.created_atLabel = [[UILabel alloc] init];
        self.created_atLabel.textColor = [jxdribbble_Global globlaTextColor];
        self.created_atLabel.font = [jxdribbble_Global globlaFontWithSize:10];
        self.created_atLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.created_atLabel];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
