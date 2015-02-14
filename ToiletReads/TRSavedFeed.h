//
//  TRSavedFeed.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 13/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TRSavedFeed : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * link;

@end
