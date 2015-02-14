//
//  TRFeedItem.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 12/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

@interface TRFeedItem : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* thumbnailUrl;
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) NSDate* date;

@end
