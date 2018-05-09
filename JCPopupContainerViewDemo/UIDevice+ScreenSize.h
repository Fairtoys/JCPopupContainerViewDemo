//
//  UIDevice+ScreenSize.h
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/8.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

@interface UIDevice (ScreenSize)
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
