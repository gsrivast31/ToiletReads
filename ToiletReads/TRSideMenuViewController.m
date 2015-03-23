//
//  TRSideMenuViewController.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRSideMenuViewController.h"
#import "TRFiltersViewController.h"
#import "TRSavedArticleViewController.h"
#import "REFrostedViewController.h"
#import "TRAppDelegate.h"

#import <MessageUI/MessageUI.h>
#import "UAAppReviewManager.h"

@interface TRSideMenuViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation TRSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:39/255.0f green:30/255.0f blue:43/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 80.0f)];
        view;
    });
    self.view.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:50.0/255.0 blue:71.0/255.0 alpha:1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0) {
        NSArray* array = @[@"Home", @"Saved Articles", @"Topics"];
        cell.textLabel.text = array[indexPath.row];
    } else if (indexPath.section == 1) {
        NSArray* array = @[@"Give feedback", @"Suggest to friend", @"Rate this app"];
        cell.textLabel.text = array[indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:195.0/255.0 green:187.0/255.0 blue:198.0/255.0 alpha:1];
    cell.textLabel.font = [UIFont flatFontOfSize:16];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TRAppDelegate* appDelegate = (TRAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* navVC = (UINavigationController*)[(REFrostedViewController*)appDelegate.viewController contentViewController];
    [(REFrostedViewController*)appDelegate.viewController hideMenuViewController];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [navVC popToRootViewControllerAnimated:NO];
        } else if (indexPath.row == 1) {
            [navVC pushViewController:[[TRSavedArticleViewController alloc] init] animated:NO];
        } else {
            [navVC pushViewController:[[TRFiltersViewController alloc] init] animated:NO];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                [mailController setMailComposeDelegate:self];
                [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
                [mailController setSubject:@"ToiletStories Support"];
                [mailController setToRecipients:@[@"gaurav.sri87@gmail.com"]];
                [mailController setMessageBody:[NSString stringWithFormat:@"%@\n\n", NSLocalizedString(@"Here's my feedback:", @"A default message shown to users when contacting support for help")] isHTML:NO];
                if(mailController) {
                    [navVC presentViewController:mailController animated:YES completion:nil];
                }
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                    message:NSLocalizedString(@"This device hasn't been setup to send emails.", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        } else if (indexPath.row == 1) {
            if([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                [mailController setMailComposeDelegate:self];
                [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
                [mailController setSubject:@"Checkout this:ToiletStories"];
                if(mailController) {
                    [navVC presentViewController:mailController animated:YES completion:nil];
                }
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                    message:NSLocalizedString(@"This device hasn't been setup to send emails.", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            
        } else {
            [UAAppReviewManager rateApp];
        }
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"GENERAL";
    } else {
        return @"FEEDBACK";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView*) view;
        UIView* content = castView.contentView;
        content.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:62.0/255.0 blue:82.0/255.0 alpha:1];
        castView.textLabel.textColor = [UIColor colorWithRed:195.0/255.0 green:187.0/255.0 blue:198.0/255.0 alpha:1];
        castView.textLabel.font = [UIFont flatFontOfSize:14];
    }
}

#pragma mark - MFMailComposeViewDelegate methods
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    if (result == MFMailComposeResultSent) {
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
