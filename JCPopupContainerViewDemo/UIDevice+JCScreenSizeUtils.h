//
//  UIDevice+ScreenSize.h
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/8.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 此枚举包含了屏幕方向和屏幕尺寸

 - JCInterfaceOrientationPortrait: 竖屏
 - JCInterfaceOrientationLandscape: 横屏
 - JCScreenSizeUnknown: 不知道什么尺寸
 - JCScreenSize480x320_4: 4,4s的屏
 - JCScreenSize568x320_5: 5,5s,5c的屏
 - JCScreenSize667x375_6: 6,6s,7,8的屏
 - JCScreenSize736x414_6p: 6p,6sp,7p,8p的屏
 - JCScreenSize812x375_X: iPhoneX的屏
 - JCInterfaceOrientationAll: 横竖屏
 - JCScreenSizeAll: 所有尺寸
 */
typedef NS_OPTIONS(NSUInteger, JCInterfaceOrientation) {
    JCInterfaceOrientationPortrait  = 1 << 0,
    JCInterfaceOrientationLandscape = 1 << 1,
    JCScreenSizeUnknown             = 1 << 2,
    JCScreenSize480x320_4           = 1 << 3,
    JCScreenSize568x320_5           = 1 << 4,
    JCScreenSize667x375_6           = 1 << 5,
    JCScreenSize736x414_6p          = 1 << 6,
    JCScreenSize812x375_X           = 1 << 7,
    JCInterfaceOrientationAll       = (JCInterfaceOrientationPortrait | JCInterfaceOrientationLandscape),
    JCScreenSizeAll                 = (JCScreenSize480x320_4 | JCScreenSize568x320_5 | JCScreenSize667x375_6 | JCScreenSize736x414_6p | JCScreenSize812x375_X)
};

typedef JCInterfaceOrientation JCScreenSize;

static inline JCInterfaceOrientation currentInterfaceOrientation(){
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return JCInterfaceOrientationLandscape;
    }
    return JCInterfaceOrientationPortrait;
}

@interface UIDevice (JCScreenSizeUtils)
+ (BOOL)jc_is480x320;//iPhone4/4s
+ (BOOL)jc_is568x320;//iPhone5/5s/5c
+ (BOOL)jc_is667x375;//iPhone6/6s
+ (BOOL)jc_is736x414;//iPhone6 Plus/ 6s Plus
+ (BOOL)jc_is812x375;//iPhoneX
@end

static inline JCScreenSize currentScreenSize(){
    if ([UIDevice jc_is480x320]) {
        return JCScreenSize480x320_4;
    }
    if ([UIDevice jc_is568x320]) {
        return JCScreenSize568x320_5;
    }
    if ([UIDevice jc_is667x375]) {
        return JCScreenSize667x375_6;
    }
    if ([UIDevice jc_is736x414]) {
        return JCScreenSize736x414_6p;
    }
    if ([UIDevice jc_is812x375]) {
        return JCScreenSize812x375_X;
    }
    return JCScreenSizeUnknown;
}

static inline NSInteger stateForCurrentOrientationAndCurrentScreenSize(){
    return currentInterfaceOrientation() | currentScreenSize();
}


NS_ASSUME_NONNULL_END
