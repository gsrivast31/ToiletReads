//
//  TRDraggableView.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TROverlayView.h"
#import "TRFeedItem.h"

@protocol TRDraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@end

@interface TRDraggableView : UIView

@property (weak) id <TRDraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)TROverlayView* overlayView;

@property (nonatomic,strong)UILabel* titleLabel;
@property (nonatomic,strong)UILabel* categoryLabel;
@property (nonatomic,strong)UIImageView* imageView;

@property (nonatomic,strong)UILabel* linkLabel;
@property (nonatomic,strong)UILabel* summaryLabel;

@property (nonatomic,strong)TRFeedItem* item;

-(void)leftTapAction;
-(void)rightTapAction;

@end
