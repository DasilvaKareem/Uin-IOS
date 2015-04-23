//
// Copyright (c) 2014 Mixpanel. All rights reserved.

#import <Foundation/Foundation.h>
#import "MPTypeDescription.h"

@interface MPEnumDescription : MPTypeDescription

@property (nonatomic, assign, getter=isFlagsSet, readonly) BOOL flagSet;
@property (nonatomic, copy, readonly) NSString *baseType;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *allValues; // array of NSNumber instances

@end
