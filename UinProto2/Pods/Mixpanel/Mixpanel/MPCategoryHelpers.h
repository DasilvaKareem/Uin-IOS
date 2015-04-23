#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface UIView (MPHelpers)

@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIImage *mp_snapshotImage;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIImage *mp_snapshotForBlur;
@property (NS_NONATOMIC_IOSONLY, readonly) int mp_fingerprintVersion;

@end

