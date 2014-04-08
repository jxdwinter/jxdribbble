//
//  jxdribbble_PlayerListCell.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-16.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_PlayerListCell.h"

@implementation jxdribbble_PlayerListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.frame = CGRectMake(0.0, 0.0, 320.0, 60.0);
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 40.0, 40.0)];
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 20.0;
        [self.contentView addSubview:self.avatarImageView];
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 10.0, 150.0, 20.0)];
        self.usernameLabel.font = [jxdribbble_Global globlaFontWithSize:15];
        self.usernameLabel.textColor = [jxdribbble_Global globlaColor];
        [self.contentView addSubview:self.usernameLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 35.0, 150.0, 15.0)];
        self.nameLabel.font = [jxdribbble_Global globlaFontWithSize:10];
        self.nameLabel.textColor = [jxdribbble_Global globlaTextColor];
        [self.contentView addSubview:self.nameLabel];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
