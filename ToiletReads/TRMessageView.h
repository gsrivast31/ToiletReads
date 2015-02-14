//
//  TRMessageView.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 13/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMessageView : UIView

@property (nonatomic, strong) UILabel* label;

- (void)setLabelText:(NSString*)text;

@end
