//
//  TROverlayView.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TROverlayView.h"

@implementation TROverlayView

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noButton"]];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setMode:(TROverlayViewMode)mode {
    if (_mode == mode) {
        return;
    }
    
    _mode = mode;
    
    if (mode == TROverlayViewModeLeft) {
        imageView.image = [UIImage imageNamed:@"noButton"];
    } else {
        imageView.image = [UIImage imageNamed:@"yesButton"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(50, 50, 100, 100);
}

@end
