//
//  TRMessageView.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 13/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRMessageView.h"
#import "NSString+ToiletReadsAdditions.h"

@implementation TRMessageView

@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont flatFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = [label.text re_sizeWithFont:label.font constrainedToSize:CGSizeMake(self.frame.size.width - 80.0, INFINITY)].height;
    CGRect frame = CGRectMake(40.0, (self.frame.size.height - height)/2.0f, self.frame.size.width - 80.0, height);
    label.frame = frame;
}

- (void)setLabelText:(NSString*)text {
    label.text = text;
    [self setNeedsLayout];
}

@end
