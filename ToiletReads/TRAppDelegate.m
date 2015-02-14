//
//  TRAppDelegate.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRAppDelegate.h"
#import "REFrostedViewController.h"
#import "TRSideMenuViewController.h"
#import "TRNavigationController.h"
#import "TRViewController.h"

#import "UAAppReviewManager.h"

@interface TRAppDelegate () <REFrostedViewControllerDelegate>

@end

@implementation TRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Initialise Appirater
    [UAAppReviewManager setAppID:APP_ID];
    [UAAppReviewManager setDaysUntilPrompt:2];
    [UAAppReviewManager setUsesUntilPrompt:5];
    [UAAppReviewManager setSignificantEventsUntilPrompt:-1];
    [UAAppReviewManager setDaysBeforeReminding:3];
    [UAAppReviewManager setReviewMessage:NSLocalizedString(@"If you find ToiletStories useful you can help support further development by leaving a review on the App Store. It'll only take a minute!", nil)];

    TRSideMenuViewController* sideVC = [[TRSideMenuViewController alloc] init];
    TRNavigationController* navVC = [[TRNavigationController alloc] initWithRootViewController:[[TRViewController alloc] init]];
    
    REFrostedViewController* mainVC = [[REFrostedViewController alloc] initWithContentViewController:navVC menuViewController:sideVC];
    mainVC.direction = REFrostedViewControllerDirectionLeft;
    mainVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    mainVC.liveBlur = YES;
    mainVC.delegate = self;
    mainVC.blurSaturationDeltaFactor = 3.0f;
    mainVC.blurRadius = 10.0f;
    mainVC.limitMenuViewSize = YES;

    CGFloat menuWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 340.0f : 280.0f;
    mainVC.menuViewSize = CGSizeMake(menuWidth, self.window.frame.size.height);

    self.viewController = mainVC;

    self.window.rootViewController = mainVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupDefaultConfigurationValues];
    [self setupStyling];
    
    // Let UAAppReviewManager know our application has launched
    [UAAppReviewManager showPromptIfNecessary];
    return YES;
}

#pragma mark - Logic
- (void)setupDefaultConfigurationValues {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              kTechnologyString: @YES,
                                                              kFoodString: @YES,
                                                              kTravelString: @YES,
                                                              kHistoryString: @YES,
                                                              kMythologyString: @YES,
                                                              kMoviesString: @YES,
                                                              kSportsString: @YES,
                                                              kMiscString: @YES }];
    
}

- (void)setupStyling {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:252.0/255.0 green:214.0/255.0 blue:123.0/255.0 alpha:1]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont flatFontOfSize:17],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UAAppReviewManager showPromptIfNecessary];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
