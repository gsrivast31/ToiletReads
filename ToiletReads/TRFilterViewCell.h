//
//  TRFilterViewCell.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 12/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRFilterViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

- (void)configureCellWithString:(NSString*)string;

@end
