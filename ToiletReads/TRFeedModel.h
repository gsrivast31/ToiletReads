//
//  TRFeedModel.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 12/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "MWFeedParser.h"

@protocol TRFeedModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray*)items withError:(NSError*)error;

@end

@interface TRFeedModel : NSObject <MWFeedParserDelegate>

@property (nonatomic, weak) id<TRFeedModelProtocol> delegate;
@property (nonatomic, strong) MWFeedParser* feedParser;
@property (nonatomic, strong) NSMutableArray* feedItems;

- (void)downloadItems;
- (void)restartDownload;

@end
