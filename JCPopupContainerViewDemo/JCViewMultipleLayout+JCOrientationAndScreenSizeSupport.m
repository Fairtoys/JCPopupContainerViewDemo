//
//  JCViewMultipleLayout+JCOrientationAndScreenSizeSupport.m
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/9.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import "JCViewMultipleLayout+JCOrientationAndScreenSizeSupport.h"

@implementation JCViewMultipleLayout (JCOrientationAndScreenSizeSupport)

- (void)setStateForCurrentOrientationAndScreenSize{
    self.state = @(stateForCurrentOrientationAndCurrentScreenSize());
}
- (void)setLayout:(dispatch_block_t)layout forOrientationAndScreenSize:(JCInterfaceOrientation)orientationAndScreenSize{
    //1.只传方向，不传尺寸，那么给当前尺寸的对应方向加上state
    //2.只传尺寸，不传方向，那么给当前尺寸的所有方向加上state
    //3.又传方向，又传尺寸，则给相应的尺寸和方向
    
    JCInterfaceOrientation inputOrientations = (JCInterfaceOrientationAll & orientationAndScreenSize);
    JCScreenSize inputScreenSizes = (JCScreenSizeAll & orientationAndScreenSize) ;
    JCScreenSize theScreenSize = currentScreenSize();
    
    if (inputOrientations && !inputScreenSizes) {
        for (JCInterfaceOrientation orientation = JCInterfaceOrientationPortrait; orientation <= JCInterfaceOrientationLandscape; orientation <<= 1) {
            if (orientation & inputOrientations) {
                [self setLayout:layout forStateInt:orientation | theScreenSize];
            }
        }
        return ;
    }
    
    if (!inputOrientations && inputScreenSizes) {
        for (JCInterfaceOrientation orientation = JCInterfaceOrientationPortrait; orientation <= JCInterfaceOrientationLandscape; orientation <<= 1) {
            if (theScreenSize & inputScreenSizes) {
                [self setLayout:layout forStateInt:orientation | theScreenSize];
            }
        }
        return ;
    }
    
    if (inputOrientations && inputScreenSizes) {
        for (JCInterfaceOrientation orientation = JCInterfaceOrientationPortrait; orientation <= JCInterfaceOrientationLandscape; orientation <<= 1) {
            if ((orientation & inputOrientations) && (theScreenSize & inputScreenSizes)) {
                [self setLayout:layout forStateInt:orientation | theScreenSize];
            }
        }
        return ;
    }
}

@end

@implementation UIView (JCViewMultipleLayoutOrientationAndScreenSizeSupport)

- (void)jclayout_setStateForCurrentOrientationAndScreenSize{
    JCViewMultipleLayout *_viewlayout = self.jclayout_viewLayoutOrNilIfNotCreated;
    [_viewlayout setStateForCurrentOrientationAndScreenSize];
}

- (void)jclayout_enumerateSetStateForCurrentOrientationAndScreenSize{
    [self jclayout_setStateForCurrentOrientationAndScreenSize];
    
    for (UIView *subview in self.subviews) {
        [subview jclayout_enumerateSetStateForCurrentOrientationAndScreenSize];
    }
}

- (void)jclayout_setLayout:(nullable dispatch_block_t)layout forOrientationAndScreenSize:(JCInterfaceOrientation)orientationAndScreenSize{
    [self.jclayout_viewLayout setLayout:layout forOrientationAndScreenSize:orientationAndScreenSize];
}

@end
