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
        
        self.frame = CGRectMake(0.0, 0.0, 320.0, 265.0);

        
        self.shot_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 225.0)];
        [self addSubview:self.shot_imageView];
        
        
        /*
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.center = CGPointMake(self.shot_imageView.frame.size.width / 2, self.shot_imageView.frame.size.height / 2);
        self.spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin;
        self.spinner.color = UIColor.lightGrayColor;
        [self addSubview:self.spinner];
        [self.spinner startAnimating];

        NSLog(@"%@",self.shot.image_url);
        
        // fetch the remote photo
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://dribbble.com/system/users/1/screenshots/21603/shot_1274474082.png"]];
        
        // do UI stuff back in UI land
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // ditch the spinner
            [self.spinner stopAnimating];
            [self.spinner removeFromSuperview];
            
            // failed to get the photo?
            if (!data) {
                self.alpha = 0.3;
                return;
            }
            
            // got the photo, so lets show it
            UIImage *image = [UIImage imageWithData:data];
            self.shot_imageView.image = image;
            
            [self addSubview:self.shot_imageView];
            self.shot_imageView.alpha = 0;
            self.shot_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
            | UIViewAutoresizingFlexibleHeight;
            
            // fade the image in
            [UIView animateWithDuration:0.2 animations:^{
                self.shot_imageView.alpha = 1;
            }];
        });
        */
        
        self.viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 230.0, 90.0, 15.0)];
        self.viewsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        self.viewsLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        self.viewsLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.viewsLabel];
        
        self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 230.0, 90.0, 15.0)];
        self.likesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        self.likesLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        self.likesLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.likesLabel];
        
        self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 230.0, 100.0, 15.0)];
        self.commentsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        self.commentsLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        self.commentsLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.commentsLabel];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 259.5, 300.0, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
        [self addSubview:line];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end