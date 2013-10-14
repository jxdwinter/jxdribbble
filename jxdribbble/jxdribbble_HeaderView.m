//
//  jxdribbble_HeaderView.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-12.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_HeaderView.h"

@implementation jxdribbble_HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithPlayerInfo : (jxdribbble_shots *) shot
{
    self = [super init];
    
    if (self)
    {
        self.shot = shot;
        
        self.frame = CGRectMake(0.0, 0.0, 320.0, 44.0);
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 7.0, 30.0, 30.0)];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 15.0;
        
        [avatarImageView setImageWithURL:[NSURL URLWithString:shot.player.avatar_url] placeholderImage:nil];
        [self addSubview:avatarImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 5.0, 250.0, 20.0)];
        titleLabel.text = shot.title;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        titleLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        [self addSubview:titleLabel];
        
        UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 25.0, 150.0, 14.0)];
        usernameLabel.text = [NSString stringWithFormat:@"by %@", shot.player.username];
        usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        usernameLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        [self addSubview:usernameLabel];
        
        UILabel *created_atLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 25.0, 107.0, 14.0)];
        created_atLabel.text = [shot.created_at substringToIndex:19];
        created_atLabel.textAlignment = NSTextAlignmentRight;
        created_atLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        created_atLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        [self addSubview:created_atLabel];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
