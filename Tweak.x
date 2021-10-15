#import <UIKit/UIKit.h>

@interface UIDeviceWhiteColor : UIColor
@end

@interface UICachedDeviceWhiteColor : UIDeviceWhiteColor
@end

#define onceColorWhite(w, a) \
    static UIColor *color = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        color = [[objc_getClass("UICachedDeviceWhiteColor") alloc] initWithWhite:w alpha:a]; \
    }); \
    return color

%hook UIColor

%new
+ (UIColor *)systemBackgroundColor {
    onceColorWhite(0, 1);
}

%end

%hook UIViewController

%new
- (void)setModalInPresentation:(BOOL)presentation {}

%end

// I know what you're thinking. Yes, I do have a tweak to add compat layer for +systemImageNamed but
// It doesn't look like iOS 13+ Assets.car works on iOS 12 :/
%hook UIImage

%new
+ (UIImage *)systemImageNamed:(NSString *)name {
    return [self imageNamed:name];
}

%new
+ (UIImage *)systemImageNamed:(NSString *)name withConfiguration:(id)configuration {
    return [self imageNamed:name];
}

%end