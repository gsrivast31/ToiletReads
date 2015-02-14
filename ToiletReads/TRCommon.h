//
//  TRCommon.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#ifndef ToiletReads_TRCommon_h
#define ToiletReads_TRCommon_h

typedef NS_ENUM(NSUInteger, TRNewsType) {
    TRTechnology,
    TRFood,
    TRTravel,
    TRHistory,
    TRMythology,
    TRMovies,
    TRSports,
    TRMiscellaneous
};


static NSString* const kTechnologyString = @"Technology";
static NSString* const kFoodString = @"Food";
static NSString* const kTravelString = @"Travel";
static NSString* const kHistoryString = @"History";
static NSString* const kMythologyString = @"Mythology";
static NSString* const kMoviesString = @"Movies";
static NSString* const kSportsString = @"Sports";
static NSString* const kMiscString = @"Miscellaneous";

static NSString* const APP_NAME = @"Toilet Reads";
static NSString* const APP_ID = @"";
static NSString* const FEED_URL = @"https://algoist.wordpress.com/feed/";

#endif
