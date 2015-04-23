//
// Copyright (c) 2014 Mixpanel. All rights reserved.

#import <Foundation/Foundation.h>

@interface MPObjectSerializerContext : NSObject

- (instancetype)initWithRootObject:(id)object NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL hasUnvisitedObjects;

- (void)enqueueUnvisitedObject:(NSObject *)object;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) NSObject *dequeueUnvisitedObject;

- (void)addVisitedObject:(NSObject *)object;
- (BOOL)isVisitedObject:(NSObject *)object;

- (void)addSerializedObject:(NSDictionary *)serializedObject;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *allSerializedObjects;

@end
