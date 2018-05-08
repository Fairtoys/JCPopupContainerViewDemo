//
//  JCPopupUtils.h
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/3.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JCPopupUtilsLayoutAndAnimation;
/**
 弹出框工具
 */
@interface JCPopupUtils : NSObject

@property (nonatomic, assign) UIInterfaceOrientation orientation;//设置orientation后，会设置相应的布局和动画，如果当前已经显示了该view，则会重新layout

@property (nonatomic, strong) __kindof JCPopupUtilsLayoutAndAnimation *layoutAndAnimationForPortrait;//保存显示动画和隐藏动画,可继承此类来写自定义的布局和动画，然后设置此property, 或者给此类实现分类，来实现自定义布局和动画, 竖屏布局，如果横屏布局没有设置的话，则会使用竖屏布局来布局

@property (nonatomic, strong, nullable) __kindof JCPopupUtilsLayoutAndAnimation *layoutAndAnimationForLandscape;//横屏布局，没有的话用竖屏布局来代替

@property (nonatomic, readonly) UIView *containerView;//整个大的容器,填满superView，放subView
@property (nonatomic, readonly) UIView *backgroundView;//当view的大小不填满整个containerView时，用来设置背景色
@property (nonatomic, weak, readonly, nullable) __kindof UIView *view;//当前弹出的view
@property (nonatomic, readonly, nullable) __kindof UIView *superView;//当前的容器SuperView
@property (nonatomic, readonly, getter = isViewShowing) BOOL viewShowing;//当前是否正在显示中


@property (nonatomic, copy, nullable) dispatch_block_t viewWillShowBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidShowBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewWillHideBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidHideBlock;
#pragma mark - views
- (void)showView:(UIView *)view inSuperView:(UIView *)superView;
- (void)hideView;
- (void)relayoutUsingCurrentOrientation;//判断当前的屏幕方向，来设置对应的布局
@end

@interface UIView (JCPopupUtils)

@property (nonatomic, strong) JCPopupUtils *popUtils;
/**
 在此视图上显示一个View

 @param view view
 */
- (void)poputils_showView:(UIView *)view;

/**
 隐藏当前显示的view
 */
- (void)poputils_hideView;

/**
 [self.popUtils relayoutUsingCurrentOrientation]
 */
- (void)poputils_relayoutPopupViewUsingCurrentOrientation;

@end

@interface UIViewController (JCPopupUtils)

@property (nonatomic, readonly) JCPopupUtils *popUtils;
/**
 在此视图上显示一个Controller
 
 @param controller controller
 */
- (void)poputils_showController:(UIViewController *)controller;

/**
 隐藏当前显示的controller
 */
- (void)poputils_hideController;

/**
 [self.popUtils relayoutUsingCurrentOrientation]
 */
- (void)poputils_relayoutPopupViewUsingCurrentOrientation;
@end


NS_ASSUME_NONNULL_END
