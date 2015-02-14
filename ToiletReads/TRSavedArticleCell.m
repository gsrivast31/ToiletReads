//
//  TRSavedArticleCell.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 13/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRSavedArticleCell.h"

@implementation TRSavedArticleCell

- (void)configureForItem:(TRSavedFeed*)item {
    self.titleLabel.text = item.title;
    self.titleLabel.font = [UIFont flatFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor colorWithRed:39/255.0f green:30/255.0f blue:43/255.0f alpha:1.0f];
    
    self.categoryLabel.text = item.category;
    self.categoryLabel.font = [UIFont flatFontOfSize:16];
    self.categoryLabel.backgroundColor = [UIColor colorFromHexCode:[@[@"#7ecef4", @"#84ccc9", @"#88abda",@"#7dc1dd",@"#b6b8de"] objectAtIndex:arc4random_uniform(4)]];
    self.categoryLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryLabel.textColor = [UIColor whiteColor];
    
    self.dateLabel.text = item.date;
    self.dateLabel.font = [UIFont flatFontOfSize:16];
    self.dateLabel.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:62.0/255.0 blue:82.0/255.0 alpha:1];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.textColor = [UIColor colorWithRed:195.0/255.0 green:187.0/255.0 blue:198.0/255.0 alpha:1];
    self.dateLabel.numberOfLines = 3;
    
    self.backgroundColor = [UIColor clearColor];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.layer.cornerRadius = 10.0f;
    self.mainView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.mainView.layer.shadowRadius = 2.0f;
}

@end
