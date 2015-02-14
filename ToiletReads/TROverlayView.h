//
//  TROverlayView.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

typedef NS_ENUM(NSUInteger, TROverlayViewMode) {
    TROverlayViewModeLeft,
    TROverlayViewModeRight
};

@interface TROverlayView : UIView

@property (nonatomic) TROverlayViewMode mode;
@property (nonatomic, strong) UIImageView* imageView;

@end
