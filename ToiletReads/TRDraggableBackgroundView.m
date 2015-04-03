//
//  TRDraggableBackgroundView.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRDraggableBackgroundView.h"
#import "TRFeedModel.h"
#import "TRCoreDataStack.h"
#import "TRSavedFeed.h"

//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2;
static const CGFloat kHorizontalPadding = 10.0f;
static const CGFloat kVerticalPadding = 10.0f;
static const CGFloat kButtonSize = 60.0f;
static const CGFloat kButtonViewHeight = kButtonSize + 2*kVerticalPadding;

@interface TRDraggableBackgroundView() <TRFeedModelProtocol>
{
    NSInteger feedIndex;
    NSMutableArray *loadedCards;
    NSDateFormatter *dateFormatter;
    
    UILabel* dateLabel;
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
    
    TRFeedModel* model;
    NSArray* feedItems;
}
@end

@implementation TRDraggableBackgroundView

@synthesize allCards;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
        
        feedItems = [[NSArray alloc] init];
        model = [[TRFeedModel alloc] init];
        model.delegate = self;
        
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        
        feedIndex = 0;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    }
    return self;
}

-(void)setupView {
    self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:241.0/255.0 alpha:1]; //the gray background colors
    [self addDateLabel];
    [self addButtons];
}

- (void)addDateLabel {
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kVerticalPadding, self.frame.size.width, 40.0f)];
    [dateLabel setText:@""];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setFont:[UIFont flatFontOfSize:18]];
    [self addSubview:dateLabel];
}

- (void)addButtons {
    CGRect buttonViewFrame = CGRectMake(0, self.frame.size.height - kButtonSize - 2*kVerticalPadding , self.frame.size.width, kButtonSize + 2*kVerticalPadding);
    UIView* buttonView = [[UIView alloc] initWithFrame:buttonViewFrame];
    [self addSubview:buttonView];
    
    CGRect buttonsframe = CGRectInset(buttonViewFrame, 0, kVerticalPadding);
    
    xButton = [[UIButton alloc] initWithFrame:CGRectMake((buttonsframe.size.width/2.0f - kButtonSize)/2.0f, 0, kButtonSize, kButtonSize)];
    checkButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonsframe.size.width/2.0f + (buttonsframe.size.width/2.0f - kButtonSize)/2.0f, 0, kButtonSize, kButtonSize)];
    [buttonView addSubview:xButton];
    [buttonView addSubview:checkButton];
    
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    
    xButton.hidden = checkButton.hidden = YES;
}

- (void)downloadItems {
    if (self.delegate) {
        [self.delegate downloadStarted];
    }
    [model downloadItems];
}

- (void)refresh {
    if (self.delegate) {
        [self.delegate downloadStarted];
    }
    [loadedCards removeAllObjects];
    [allCards removeAllObjects];
    feedIndex = 0;

    [model restartDownload];
}

#pragma mark TRFeedModelProtocol

- (void)itemsDownloaded:(NSArray *)items withError:(NSError *)error {
    feedItems = items;
    if (self.delegate) {
        [self.delegate downloadFinishedWithError:error];
    }
    if (error == nil) {
        [self loadCards];
        xButton.hidden = checkButton.hidden = NO;
        dateLabel.hidden = NO;
    } else {
       xButton.hidden = checkButton.hidden = YES;
        dateLabel.hidden = YES;
    }
}

#pragma mark
-(TRDraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index {
    TRDraggableView* draggableView = [[TRDraggableView alloc] initWithFrame:CGRectMake(kHorizontalPadding, 2*kVerticalPadding + 40.0f, self.frame.size.width - 2*kHorizontalPadding, self.frame.size.height - 3*kVerticalPadding - kButtonViewHeight - 40.0f)];
    
    TRFeedItem* item = [feedItems objectAtIndex:index];
    
    dateLabel.text = [dateFormatter stringFromDate:item.date];
    draggableView.item = item;
    
    draggableView.delegate = self;
    
    return draggableView;
}

-(void)loadCards {
    
    if([feedItems count] > 0) {
        NSInteger numLoadedCardsCap =(([feedItems count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[feedItems count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        for (int i = 0; i<[feedItems count]; i++) {
            TRDraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                [loadedCards addObject:newCard];
            }
        }
        
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            feedIndex++;
        }
        [self setDate];
    }
}

-(void)cardSwipedLeft:(UIView *)card; {
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (feedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:feedIndex]];
        feedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
        [self setDate];
    }
    
    [self checkForNoFeeds];
}

-(void)cardSwipedRight:(UIView *)card {
    TRDraggableView *c = (TRDraggableView *)card;
    [self saveFeed:c.item];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (feedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:feedIndex]];
        feedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
        [self setDate];
    }

    [self checkForNoFeeds];

}

-(void)swipeRight {
    TRDraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = TROverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightTapAction];
}

-(void)swipeLeft {
    TRDraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = TROverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftTapAction];
}

- (void)checkForNoFeeds {
    if ([loadedCards count] <= 0) {
        if (self.delegate) {
            [self.delegate itemsFinished];
        }
        xButton.hidden = checkButton.hidden = YES;
        dateLabel.hidden = YES;
    }
}

- (void)setDate {
    TRDraggableView *view = (TRDraggableView*)[loadedCards objectAtIndex:0];
    [dateLabel setText:[dateFormatter stringFromDate:view.item.date]];
}

-(NSString*)currentArticleLink {
    if (loadedCards.count) {
        TRDraggableView *view = (TRDraggableView*)[loadedCards objectAtIndex:0];
        return view.item.url;
    }
    return nil;
}

- (void)saveFeed:(TRFeedItem*)item {
    TRCoreDataStack* coreDataStack = [TRCoreDataStack defaultStack];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TRSavedFeed"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"link == %@", item.url]];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    NSUInteger count = [coreDataStack.managedObjectContext countForFetchRequest:fetchRequest error:&error];
     
    if (!error) {
        if (count == 0) {
            TRSavedFeed* savedFeed = [NSEntityDescription insertNewObjectForEntityForName:@"TRSavedFeed" inManagedObjectContext: coreDataStack.managedObjectContext];
            savedFeed.title = item.title;
             
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"MMMM dd yy";
            savedFeed.date = [formatter stringFromDate:item.date];
            savedFeed.link = item.url;
            savedFeed.category = item.category;
             
            [coreDataStack saveContext];
        }
    }
}


@end
