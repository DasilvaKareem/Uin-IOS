//
// Copyright (c) 2014 Mixpanel. All rights reserved.

#import <Foundation/Foundation.h>
#import "MPABTestDesignerMessage.h"

@interface MPAbstractABTestDesignerMessage : NSObject <MPABTestDesignerMessage>

@property (nonatomic, copy, readonly) NSString *type;

+ (instancetype)messageWithType:(NSString *)type payload:(NSDictionary *)payload;

- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithType:(NSString *)type payload:(NSDictionary *)payload NS_DESIGNATED_INITIALIZER;

- (void)setPayloadObject:(id)object forKey:(NSString *)key;
- (id)payloadObjectForKey:(NSString *)key;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *payload;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *JSONData;

@end
