//
//  TRDraggableBackgroundView.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRDraggableView.h"

@protocol TRFeedDelegate <NSObject>

- (void)downloadStarted;
- (void)downloadFinishedWithError:(NSError*)error;
- (void)itemsFinished;

@end

@interface TRDraggableBackgroundView : UIView <TRDraggableViewDelegate>

@property (weak) id <TRFeedDelegate> delegate;

-(void)downloadItems;
-(void)refresh;
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
-(NSString*)currentArticleLink;

@property (retain,nonatomic)NSMutableArray* allCards;

@end
