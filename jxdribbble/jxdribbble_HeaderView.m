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
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.opaque = YES;
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 7.0, 30.0, 30.0)];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 15.0;
        avatarImageView.opaque = YES;
        
        [avatarImageView setImageWithURL:[NSURL URLWithString:shot.player.avatar_url] placeholderImage:[UIImage imageNamed:@"headimg_bg"]];
        [self addSubview:avatarImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 5.0, 250.0, 20.0)];
        titleLabel.text = shot.title;
        titleLabel.font = [jxdribbble_Global globlaFontWithSize:15];
        titleLabel.textColor = [jxdribbble_Global globlaColor];
        titleLabel.opaque = YES;
        [self addSubview:titleLabel];
        
        UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 25.0, 150.0, 14.0)];
        usernameLabel.text = [NSString stringWithFormat:@"by %@", shot.player.name];
        usernameLabel.font = [jxdribbble_Global globlaFontWithSize:10];
        usernameLabel.textColor = [jxdribbble_Global globlaColor];
        usernameLabel.opaque = YES;
        [self addSubview:usernameLabel];
        
        UILabel *created_atLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 25.0, 107.0, 14.0)];
        created_atLabel.text = [shot.created_at substringToIndex:16];
        created_atLabel.textAlignment = NSTextAlignmentRight;
        created_atLabel.font = [jxdribbble_Global globlaFontWithSize:10];
        created_atLabel.textColor = [jxdribbble_Global globlaTextColor];
        created_atLabel.opaque = YES;
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
