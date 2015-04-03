//
//  TRViewController.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRViewController.h"
#import "TRDraggableBackgroundView.h"
#import "TRNavigationController.h"
#import "MBProgressHUD.h"
#import "RTSpinKitView.h"
#import "TRMessageView.h"

@interface TRViewController () <TRFeedDelegate>
{
    RTSpinKitView* spinner;
}

@end

@implementation TRViewController

@synthesize draggableBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addDraggableView];
    
    self.title = @"TOILET STORIES";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBarIconListMenu"] style:UIBarButtonItemStylePlain target:(TRNavigationController *)self.navigationController action:@selector(showMenu)];

    UIBarButtonItem* exportItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ListMenuIconExport"] style:UIBarButtonItemStylePlain target:self action:@selector(shareCard)];
    UIBarButtonItem* refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    self.navigationItem.rightBarButtonItems = @[refreshItem, exportItem];
}

- (void)shareCard {
    NSString* link = [draggableBackground currentArticleLink];
    if (link == nil) {
        return;
    }
    
    NSString* text = [NSString stringWithFormat:@"Hey! I found out this interesting article %@ on this app %@.\n", link, APP_NAME];
    
    NSString* shareText = [@"\nYou can find more such articles on this app. Download it from " stringByAppendingString:APP_URL];
    NSArray* objectsToShare = @[text, shareText];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self.navigationController presentViewController:activityVC animated:YES completion:nil];
}

- (void)addDraggableView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat viewHeight = (screenRect.size.height - navigationBarHeight - statusBarHeight);
    
    draggableBackground = [[TRDraggableBackgroundView alloc] initWithFrame:CGRectMake(0, navigationBarHeight + statusBarHeight, self.view.frame.size.width, viewHeight)];
    draggableBackground.delegate = self;
    [self.view addSubview:draggableBackground];
    [draggableBackground downloadItems];
}

- (void)refresh {
    if (draggableBackground != nil) {
        [draggableBackground removeFromSuperview];
        draggableBackground = nil;
    }
    if (self.messageView != nil) {
        [self.messageView removeFromSuperview];
        self.messageView = nil;
    }
    
    [self addDraggableView];
    
}

#pragma mark TRFeedDownloadDelegate

- (void)downloadStarted {
    if (spinner == nil) {
        spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:[UIColor whiteColor]];
    }
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.square = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = spinner;
    hud.color = [UIColor clearColor];
    hud.labelText = NSLocalizedString(@"Loading", @"Loading");
    
    [spinner startAnimating];
}

- (void)downloadFinishedWithError:(NSError *)error {
    [spinner stopAnimating];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (error != nil) {
        [self showMessage:@"Failed to load the feeds. Check your internet connection and try again."];
    }
}

- (void)itemsFinished {
    [self showMessage:@"Nothing to show"];
}

#pragma mark

- (void)showMessage:(NSString*)text {
    if (self.messageView == nil) {
        self.messageView = [[TRMessageView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.messageView];
        [self.messageView setLabelText:text];
    } else {
        [self.messageView setLabelText:text];
    }
}

@end
