//
//  TRViewController.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

@class TRDraggableBackgroundView;
@class TRMessageView;

@interface TRViewController : UIViewController

@property (nonatomic, strong) TRDraggableBackgroundView* draggableBackground;
@property (nonatomic, strong) TRMessageView* messageView;

@end
