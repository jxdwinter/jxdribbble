//
//  jxdribbble_HeaderView.h
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-12.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jxdribbble_shots.h"

@interface jxdribbble_HeaderView : UIControl

@property (nonatomic, strong) jxdribbble_shots *shot;

- (id) initWithPlayerInfo : (jxdribbble_shots *) shot;

@end
