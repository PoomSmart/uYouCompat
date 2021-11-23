#import <UIKit/UIKit.h>

@interface UIColor (MyPrivate)
@property (getter=_systemColorName, setter=_setSystemColorName:, nonatomic, retain) NSString *systemColorName;
@end

@interface UIDeviceRGBColor : UIColor
@end

@interface UICachedDeviceRGBColor : UIDeviceRGBColor
@end

@interface UIDeviceWhiteColor : UIColor
@end

@interface UICachedDeviceWhiteColor : UIDeviceWhiteColor
@end

#define onceColor(colorName, r, g, b, a) \
    static UIColor *color = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        color = [[objc_getClass("UICachedDeviceRGBColor") alloc] initWithRed:r green:g blue:b alpha:a]; \
        [color _setSystemColorName:colorName]; \
    }); \
    return color

#define onceColorWhite(w, a) \
    static UIColor *color = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        color = [[objc_getClass("UICachedDeviceWhiteColor") alloc] initWithWhite:w alpha:a]; \
    }); \
    return color

%hook UIColor

+ (UIColor *)_systemColorWithName:(NSString *)name {
    UIColor *color = nil;
    @try {
        color = %orig(name);
    } @catch (NSException *e) {}
    return color;
}

%new
+ (UIColor *)systemBackgroundColor {
    onceColorWhite(0, 1);
}

%new
+ (UIColor *)labelColor {
    onceColor(@"labelColor", 1, 1, 1, 1);
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