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
        [self addSubview:self.shot_imageView];

        self.viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 230.0, 90.0, 15.0)];
        self.viewsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.viewsLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.viewsLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.viewsLabel];
        
        self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 230.0, 90.0, 15.0)];
        self.likesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.likesLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.likesLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.likesLabel];
        
        self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 230.0, 100.0, 15.0)];
        self.commentsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.commentsLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.commentsLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.commentsLabel];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 254.5, 300.0, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        //[self addSubview:line];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
