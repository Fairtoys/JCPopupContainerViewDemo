//
//  UIDevice+ScreenSize.h
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/8.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JCInterfaceOrientation) {
    JCInterfaceOrientationPortrait,
    JCInterfaceOrientationLandscape
};

typedef NS_ENUM(NSUInteger, JCScreenSize) {
    JCScreenSize480x320,
    JCScreenSize568x320,
    JCScreenSize667x375,
    JCScreenSize736x414,
    JCScreenSize812x375
};

static inline NSInteger stateWithOrientationAndScreenSize(JCInterfaceOrientation orientation,JCScreenSize screenSize){
    return (orientation << 1) + screenSize;
}

@interface UIDevice (ScreenSize)
+ (BOOL)jc_is480x320;//iPhone4/4s
+ (BOOL)jc_is568x320;//iPhone5/5s/5c
+ (BOOL)jc_is667x375;//iPhone6/6s
+ (BOOL)jc_is736x414;//iPhone6 Plus/ 6s Plus
+ (BOOL)jc_is812x375;//iPhoneX
@end

NS_ASSUME_NONNULL_END
