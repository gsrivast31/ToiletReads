//
//  TRHelper.h
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRHelper : NSObject

+ (BOOL)isFilterEnabled:(NSString*)key;
+ (void)enableFilter:(NSString*)key;
+ (void)disableFilter:(NSString*)key;

@end
