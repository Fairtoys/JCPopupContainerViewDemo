//
//  JCPopupUtils+OrientationSupport.m
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/9.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import "JCPopupUtils+JCOrientationAndScreenSizeSupport.h"

@implementation JCPopupUtils (JCOrientationAndScreenSizeSupport)
- (void)setStateForCurrentOrientationAndScreenSize{
    self.state = @(stateForCurrentOrientationAndCurrentScreenSize());
}

- (void)setLayoutAndAnimation:(nullable __kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation forOrientationAndScreenSize:(JCInterfaceOrientation)orientationAndScreenSize{
    //1.只传方向，不传尺寸，那么给当前尺寸的对应方向加上state
    //2.只传尺寸，不传方向，那么给当前尺寸的所有方向加上state
    //3.又传方向，又传尺寸，则给相应的尺寸和方向
    NSLog(@"JCInterfaceOrientationAll:%@ ,orientationAndScreenSize:%@  &:%@", @(JCInterfaceOrientationAll), @(orientationAndScreenSize), @((JCInterfaceOrientationAll & orientationAndScreenSize)));
    JCInterfaceOrientation inputOrientations = (JCInterfaceOrientationAll & orientationAndScreenSize);
    JCScreenSize inputScreenSizes = (JCScreenSizeAll & orientationAndScreenSize) ;
    JCScreenSize theScreenSize = currentScreenSize();
    
    if (inputOrientations && !inputScreenSizes) {
        for (JCInterfaceOrientation orientation = JCInterfaceOrientationPortrait; orientation <= JCInterfaceOrientationLandscape; orientation <<= 1) {
            if (orientation & inputOrientations) {
                [self setLayoutAndAnimation:layoutAndAnimation forStateInt:orientation | theScreenSize ];
            }
        }
        return ;
    }
    
    if (!inputOrientations && inputScreenSizes) {
        for (JCInterfaceOrientation orientation = JCInterfaceOrientationPortrait; orientation <= JCInterfaceOrientationLandscape; orientation <<= 1) {
            [self setLayoutAndAnimation:layoutAndAnimation forStateInt:orientation | theScreenSize ];
        }
        return ;
    }
    
    if (inputOrientations && inputScreenSizes) {
        for (JCInterfaceOrientation orientation = JCInterfaceOrientationPortrait; orientation <= JCInterfaceOrientationLandscape; orientation <<= 1) {
            if ((orientation & inputOrientations) && (theScreenSize & inputScreenSizes)) {
                [self setLayoutAndAnimation:layoutAndAnimation forStateInt:orientation | theScreenSize ];
            }
        }
        return ;
    }
}
@end


@implementation UIView (JCOrientationAndScreenSizeSupport)

- (void)poputils_setStateForCurrentOrientationAndScreenSize{
    [self.popUtils setStateForCurrentOrientationAndScreenSize];
}

@end

@implementation UIViewController (JCOrientationAndScreenSizeSupport)
- (void)poputils_setStateForCurrentOrientationAndScreenSize{
    [self.view poputils_setStateForCurrentOrientationAndScreenSize];
}

@end
