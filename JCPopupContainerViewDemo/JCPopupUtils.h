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

#pragma mark - layoutAndAnimations
/**
 在不同的state设置不同的布局，当设置state时，会根据该状态去取相应的布局类

 @param layoutAndAnimation 布局和动画类
 @param state 对应的状态
 */
- (void)setLayoutAndAnimation:(nullable __kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation forState:(id <NSCopying>)state;

/**
 获取对应的状态下的 LayoutAnimation

 @param state 状态
 @return JCPopupUtilsLayoutAndAnimation
 */
- (nullable __kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimationForState:(id <NSCopying>)state;
@property (nonatomic, strong) id <NSCopying> state;//当前状态，设置此状态有可能会重新调用layout

@property (nonatomic, strong, nullable) JCPopupUtilsLayoutAndAnimation *layoutAndAnimationNormal;//如果对应的state下的JCPopupUtilsLayoutAndAnimation都不存在的话，那么会使用此layout来做默认的布局

#pragma mark - views
@property (nonatomic, readonly) UIView *containerView;//整个大的容器,填满superView，放subView
@property (nonatomic, readonly) UIView *backgroundView;//当view的大小不填满整个containerView时，用来设置背景色
@property (nonatomic, weak, readonly, nullable) __kindof UIView *view;//当前弹出的view
@property (nonatomic, readonly, nullable) __kindof UIView *superView;//当前的容器SuperView
@property (nonatomic, readonly, getter = isViewShowing) BOOL viewShowing;//当前是否正在显示中

#pragma mark - callbacks
@property (nonatomic, copy, nullable) dispatch_block_t viewWillShowBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidShowBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewWillHideBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidHideBlock;

#pragma mark - views util
- (void)showView:(UIView *)view inSuperView:(UIView *)superView;
- (void)hideView;
- (void)relayout;//强制使用当前的layout来调用布局block

@end


/**
 横竖屏的支持
 */
@interface JCPopupUtils (OrientationSupport)
- (void)setStateForCurrentOrientation;//判断当前的屏幕方向，来设置对应的布局
- (void)setLayoutAndAnimationForLandscape:(nullable __kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation;
- (void)setLayoutAndAnimationForPortrait:(nullable __kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation;
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
- (void)poputils_setStateForCurrentOrientation;

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
- (void)poputils_setStateForCurrentOrientation;
@end


NS_ASSUME_NONNULL_END
