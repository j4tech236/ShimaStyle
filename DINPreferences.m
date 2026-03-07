#import "DINPreferences.h"

static NSString *const kPrefsDomain = @"com.34306.shimastyle";

@implementation DINPreferences

+ (instancetype)sharedInstance {
    static DINPreferences *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DINPreferences alloc] init];
        [instance reloadPreferences];
    });
    return instance;
}

- (void)reloadPreferences {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:
        @"/var/jb/var/mobile/Library/Preferences/com.34306.shimastyle.plist"];

    _enabled = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : YES;
    _notificationEnabled = prefs[@"notificationEnabled"] ? [prefs[@"notificationEnabled"] boolValue] : YES;
    _customBackgroundEnabled = prefs[@"customBackgroundEnabled"] ? [prefs[@"customBackgroundEnabled"] boolValue] : NO;
    _customBackgroundColorHex = prefs[@"customBackgroundColorHex"] ?: @"#1C1C1E";
    _customBackgroundImagePath = prefs[@"customBackgroundImagePath"];
    _backgroundOpacity = prefs[@"backgroundOpacity"] ? [prefs[@"backgroundOpacity"] floatValue] : 1.0;
    _dismissDuration = prefs[@"dismissDuration"] ? [prefs[@"dismissDuration"] doubleValue] : 5.0;
    _notificationStyle = prefs[@"notificationStyle"] ? [prefs[@"notificationStyle"] integerValue] : 0;
}

- (UIColor *)customBackgroundColor {
    NSString *hex = _customBackgroundColorHex;
    if (!hex || hex.length < 7) return [UIColor colorWithRed:0.11 green:0.11 blue:0.12 alpha:1.0];

    unsigned int rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];

    return [UIColor colorWithRed:((rgbValue >> 16) & 0xFF) / 255.0
                           green:((rgbValue >> 8) & 0xFF) / 255.0
                            blue:(rgbValue & 0xFF) / 255.0
                           alpha:_backgroundOpacity];
}

@end
