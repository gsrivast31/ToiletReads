//
//  TRHelper.m
//  ToiletReads
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "TRHelper.h"

@implementation TRHelper

+ (BOOL)isFilterEnabled:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)enableFilter:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
}

+ (void)disableFilter:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
}

@end
