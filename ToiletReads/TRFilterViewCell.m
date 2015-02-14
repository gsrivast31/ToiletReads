//
//  TRFilterViewCell.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 12/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRFilterViewCell.h"
#import "TRHelper.h"

@interface TRFilterViewCell()
{
    NSString* topic;
}

@end

@implementation TRFilterViewCell

- (void)configureCellWithString:(NSString*)string {
    
    topic = string;
    
    self.label.text = string;
    self.label.font = [UIFont flatFontOfSize:18];
    self.label.textColor = [UIColor colorWithRed:39/255.0f green:30/255.0f blue:43/255.0f alpha:1.0f];

    NSString* initials = [string substringToIndex:1];
    
    [self.cellButton setTitle:[initials capitalizedString] forState:UIControlStateNormal];
    [self.cellButton.titleLabel setFont:[UIFont flatFontOfSize:20]];
    [self.cellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cellButton setBackgroundColor:[UIColor colorWithRed:76.0/255.0 green:62.0/255.0 blue:82.0/255.0 alpha:1]];

    [self.checkButton addTarget:self action:@selector(toggleState:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([TRHelper isFilterEnabled:topic]) {
        [self.checkButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    } else {
        [self.checkButton setImage:[UIImage imageNamed:@"check-disabled"] forState:UIControlStateNormal];
    }
    self.checkButton.clipsToBounds = YES;
    
    self.accessoryView = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)toggleState:(id)sender {
    BOOL isEnabled = [TRHelper isFilterEnabled:topic];
    
    if (isEnabled) {
        [TRHelper disableFilter:topic];
        [self.checkButton setImage:[UIImage imageNamed:@"check-disabled"] forState:UIControlStateNormal];
    } else {
        [TRHelper enableFilter:topic];
        [self.checkButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
}

@end
