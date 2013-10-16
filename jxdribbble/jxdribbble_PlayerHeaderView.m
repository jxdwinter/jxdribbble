//
//  jxdribbble_PlayerHeaderView.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-16.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_PlayerHeaderView.h"

@implementation jxdribbble_PlayerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (id) initWithPlayerInfo:(jxdribbble_player *)playInfo
{
    self = [super init];
    
    if (self)
    {
        self.frame = CGRectMake(0.0, 0.0, 320.0, 200.0);
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 80.0)];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 40.0;
        [avatarImageView setImageWithURL:[NSURL URLWithString:playInfo.avatar_url] placeholderImage:[UIImage imageNamed:@"headimg_bg"]];
        UIButton *avaterButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 20.0, 80.0, 80.0)];
        [avaterButton addSubview:avatarImageView];
        avaterButton.tag = 9999;
        [self addSubview:avaterButton];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(99.5, 10.0, 0.5, 110.0)];
        lineImageView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [self addSubview:lineImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 10.0, 190.0, 25.0)];
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        nameLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        nameLabel.text = playInfo.name;
        [self addSubview:nameLabel];
        
        UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110.0, 40.0, 13.0, 13.0)];
        locationImageView.image = [UIImage imageNamed:@"location"];
        [self addSubview:locationImageView];
        
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 40.0, 170.0, 15.0)];
        locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        locationLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        locationLabel.text = playInfo.location;
        [self addSubview:locationLabel];
        
        UIImageView *twitterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110.0, 62.0, 13.0, 13.0)];
        twitterImageView.image = [UIImage imageNamed:@"twitter"];
        [self addSubview:twitterImageView];
        
        UILabel *twitterLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 60.0, 170.0, 15.0)];
        twitterLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        twitterLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        if (playInfo.twitter_screen_name != (NSString *) [NSNull null]) twitterLabel.text = playInfo.twitter_screen_name;
        [self addSubview:twitterLabel];
        
        UIImageView *webImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110.0, 84.0, 13.0, 13.0)];
        webImageView.image = [UIImage imageNamed:@"website"];
        [self addSubview:webImageView];
        
        UILabel *webLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 82.0, 170.0, 15.0)];
        webLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        webLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        if (playInfo.website_url != (NSString *) [NSNull null] )webLabel.text = playInfo.website_url;
        [self addSubview:webLabel];
        
        UIImageView *calendarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110.0, 106.0, 13.0, 13.0)];
        calendarImageView.image = [UIImage imageNamed:@"calendar"];
        [self addSubview:calendarImageView];
        
        UILabel *calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 104.0, 170.0, 15.0)];
        calendarLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        calendarLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        calendarLabel.text = [NSString stringWithFormat:@"since %@", [playInfo.created_at substringToIndex:10]];
        [self addSubview:calendarLabel];
        
        
        UIImageView *dribbbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 106.0, 13.0, 13.0)];
        dribbbleImageView.image = [UIImage imageNamed:@"dribbble"];
        [self addSubview:dribbbleImageView];
        
        UILabel *dribbbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 104.0, 60.0, 15.0)];
        dribbbleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        dribbbleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        dribbbleLabel.text = [NSString stringWithFormat:@"shots %@", playInfo.shots_count];
        [self addSubview:dribbbleLabel];
        
        
        UIView *drafteesView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 75.0, 50.0)];
        UILabel *drafteesLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 65, 20.0)];
        drafteesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        drafteesLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        drafteesLabel.text = [NSString stringWithFormat:@"draftees"];
        drafteesLabel.textAlignment = NSTextAlignmentCenter;
        UILabel *drafteesNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 25.0, 65.0, 20.0)];
        drafteesNumberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        drafteesNumberLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        drafteesNumberLabel.text = [NSString stringWithFormat:@"%@",playInfo.draftees_count];
        drafteesNumberLabel.textAlignment = NSTextAlignmentCenter;
        [drafteesView addSubview:drafteesLabel];
        [drafteesView addSubview:drafteesNumberLabel];
        
        UIButton *drafteesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        drafteesButton.tag = 8888;
        drafteesButton.frame = CGRectMake(225.0, 130.0, 75.0, 50.0);
        [drafteesButton addSubview:drafteesView];
        [self addSubview:drafteesButton];
        
        
        
        UIView *followingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 75.0, 50.0)];
        UILabel *followingLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 65, 20.0)];
        followingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        followingLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        followingLabel.text = [NSString stringWithFormat:@"following"];
        followingLabel.textAlignment = NSTextAlignmentCenter;
        UILabel *followingNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 25.0, 65.0, 20.0)];
        followingNumberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        followingNumberLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        followingNumberLabel.text = [NSString stringWithFormat:@"%@",playInfo.following_count];
        followingNumberLabel.textAlignment = NSTextAlignmentCenter;
        [followingView addSubview:followingLabel];
        [followingView addSubview:followingNumberLabel];
        
        UIButton *followingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        followingButton.tag = 7777;
        followingButton.frame = CGRectMake(75.0, 130.0, 75.0, 50.0);
        [followingButton addSubview:followingView];
        [self addSubview:followingButton];
        
        
        UIView *followerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 75.0, 50.0)];
        UILabel *followerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 65, 20.0)];
        followerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        followerLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        followerLabel.text = [NSString stringWithFormat:@"followers"];
        followerLabel.textAlignment = NSTextAlignmentCenter;
        UILabel *followerNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 25.0, 65.0, 20.0)];
        followerNumberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        followerNumberLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        followerNumberLabel.text = [NSString stringWithFormat:@"%@",playInfo.followers_count];
        followerNumberLabel.textAlignment = NSTextAlignmentCenter;
        [followerView addSubview:followerLabel];
        [followerView addSubview:followerNumberLabel];
        
        UIButton *followerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        followerButton.tag = 6666;
        followerButton.frame = CGRectMake(150.0, 130.0, 75.0, 50.0);
        [followerButton addSubview:followerView];
        [self addSubview:followerButton];
        
        
        UIView *likesView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 75.0, 50.0)];
        UILabel *likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 65, 20.0)];
        likesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        likesLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        likesLabel.text = [NSString stringWithFormat:@"likes"];
        likesLabel.textAlignment = NSTextAlignmentCenter;
        UILabel *likesNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 25.0, 65.0, 20.0)];
        likesNumberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        likesNumberLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        likesNumberLabel.text = [NSString stringWithFormat:@"%@",playInfo.likes_count];
        likesNumberLabel.textAlignment = NSTextAlignmentCenter;
        [likesView addSubview:likesLabel];
        [likesView addSubview:likesNumberLabel];
        
        UIButton *likesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likesButton.tag = 5555;
        likesButton.frame = CGRectMake(0.0, 130.0, 75.0, 50.0);
        [likesButton addSubview:likesView];
        [self addSubview:likesButton];
        
        
    }
    
    return self;
    
}

@end
