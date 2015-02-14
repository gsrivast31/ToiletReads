//
//  TRFeedModel.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 12/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRFeedModel.h"
#import "TRFeedItem.h"

@implementation TRFeedModel

- (void)downloadItems {
    NSURL* feedURL = [NSURL URLWithString:FEED_URL];
    self.feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    
    self.feedParser.delegate = self;
    self.feedParser.feedParseType = ParseTypeFull;
    self.feedParser.connectionType = ConnectionTypeAsynchronously;
    
    [self.feedParser parse];
}

- (void)restartDownload {
    [self.feedParser stopParsing];
    [self.feedItems removeAllObjects];
    [self.feedParser parse];
}

#pragma mark MWFeedParserDelegate

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    if (self.delegate) {
        [self.delegate itemsDownloaded:nil withError:error];
    }
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    TRFeedItem* feedItem = [[TRFeedItem alloc] init];
    feedItem.title = item.title;
    feedItem.url = item.link;
    feedItem.category = item.category;
    feedItem.summary = item.summary;
    feedItem.date = item.date;
    
    if (item.enclosures && [item.enclosures count]) {
        feedItem.thumbnailUrl = [(NSDictionary*)[item.enclosures objectAtIndex:0] valueForKey:@"url"];
    }
    
    [self.feedItems addObject:feedItem];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    if (self.delegate) {
        NSArray* items = [self.feedItems sortedArrayUsingDescriptors:
                          [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];

        [self.delegate itemsDownloaded:items withError:nil];
    }
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
    self.feedItems = [[NSMutableArray alloc] init];
}

@end
