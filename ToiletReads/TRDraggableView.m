//
//  TRDraggableView.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRDraggableView.h"
#import "TRMediaController.h"
#import "NSString+ToiletReadsAdditions.h"

#import "TRAppDelegate.h"
#import "REFrostedViewController.h"
#import "SVModalWebViewController.h"

#import "NSString+HTML.h"

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle

static const CGFloat kImageSize = 160.0f;
static const CGFloat kHorizontalPadding = 10.0f;
static const CGFloat kVerticalPadding = 10.0f;

@interface TRDraggableView()
{
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

@end

@implementation TRDraggableView

@synthesize delegate;
@synthesize panGestureRecognizer;
@synthesize titleLabel;
@synthesize categoryLabel;
@synthesize imageView;
@synthesize linkLabel;
@synthesize summaryLabel;
@synthesize overlayView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 3;
        titleLabel.font = [UIFont flatFontOfSize:22];
        
        categoryLabel = [[UILabel alloc] init];
        categoryLabel.textAlignment = NSTextAlignmentCenter;
        categoryLabel.textColor = [UIColor whiteColor];
        categoryLabel.numberOfLines = 1;
        categoryLabel.font = [UIFont flatFontOfSize:16];
        
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        linkLabel = [[UILabel alloc] init];
        linkLabel.textAlignment = NSTextAlignmentCenter;
        linkLabel.numberOfLines = 1;
        linkLabel.font = [UIFont flatFontOfSize:16];
        linkLabel.textColor = [UIColor lightGrayColor];
        linkLabel.text = @"Read the whole article";
        linkLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLink:)];
        [linkLabel addGestureRecognizer:tapRecognizer];
        
        summaryLabel = [[UILabel alloc] init];
        summaryLabel.numberOfLines = 0;
        summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        summaryLabel.textAlignment = NSTextAlignmentCenter;
        summaryLabel.font = [UIFont flatFontOfSize:14];
        summaryLabel.textColor = [UIColor grayColor];
        
        self.backgroundColor = [UIColor whiteColor];
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
        [self addSubview:titleLabel];
        [self addSubview:categoryLabel];
        [self addSubview:imageView];
        [self addSubview:linkLabel];
        [self addSubview:summaryLabel];
        
        overlayView = [[TROverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
    }
    return self;
}

-(void)setupView {
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectInset(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), kHorizontalPadding, kVerticalPadding);
    
    categoryLabel.frame = CGRectMake(0, 0, self.frame.size.width, 40.0f);
    categoryLabel.backgroundColor = [UIColor colorFromHexCode:[@[@"#7ecef4", @"#84ccc9", @"#88abda",@"#7dc1dd",@"#b6b8de"] objectAtIndex:arc4random_uniform(4)]];
    
    CGFloat startY = frame.origin.y + 40.0f + kVerticalPadding;

    /*if (_item.thumbnailUrl) {
        imageView.frame = CGRectMake(frame.origin.x, startY, frame.size.width, kImageSize);
        startY += kImageSize + kVerticalPadding;
    } else {
        startY += kVerticalPadding;
    }*/

    CGFloat titleHeight = [self.item.title re_sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(frame.size.width, INFINITY)].height ;
    titleLabel.frame = CGRectMake(frame.origin.x, startY, frame.size.width, titleHeight);

    CGFloat linkHeight = [linkLabel.text re_sizeWithFont:linkLabel.font constrainedToSize:CGSizeMake(frame.size.width, INFINITY)].height;
    linkLabel.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - kVerticalPadding - linkHeight, frame.size.width, linkHeight);
    
    startY += titleHeight + 2*kVerticalPadding;
    summaryLabel.frame = CGRectMake(frame.origin.x, startY, frame.size.width, linkLabel.frame.origin.y - startY - 2*kVerticalPadding);


}

- (void)setItem:(TRFeedItem *)item {
    _item = item;
    titleLabel.text = item.title;
    categoryLabel.text = item.category;
    NSString* summary = [item.summary stringByConvertingHTMLToPlainText];
    summaryLabel.text = summary;
    
    [[TRMediaController sharedInstance] imageFromURL:item.thumbnailUrl success:^(UIImage *image) {
        imageView.image = image;
    } failure:^(NSError *error) {
    }];
    
    [self setNeedsLayout];
}

- (void)openLink:(UITapGestureRecognizer*)tapRecognizer {
    if (self.item.url == nil) {
        return;
    }
    
    TRAppDelegate* appDelegate = (TRAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* navVC = (UINavigationController*)[(REFrostedViewController*)appDelegate.viewController contentViewController];
    SVModalWebViewController* vc = [[SVModalWebViewController alloc] initWithAddress:self.item.url];

    [navVC presentViewController:vc animated:YES completion:nil];
}

- (void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance {
    if (distance > 0) {
        overlayView.mode = TROverlayViewModeRight;
    } else {
        overlayView.mode = TROverlayViewModeLeft;
    }
    
    overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

- (void)afterSwipeAction {
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             overlayView.alpha = 0;
                         }];
    }
}

-(void)rightAction {
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

-(void)leftAction {
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

-(void)rightTapAction {
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

-(void)leftTapAction {
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

@end
