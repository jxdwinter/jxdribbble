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
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 12.0, 150.0, 18.0)];
        self.usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        self.usernameLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        [self.contentView addSubview:self.usernameLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 35.0, 150.0, 10.0)];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.nameLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
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
