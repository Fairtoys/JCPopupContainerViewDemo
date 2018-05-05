//
//  JCPopupUtils.h
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/3.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCPopupUtilsLayoutAndAnimation.h"

NS_ASSUME_NONNULL_BEGIN
/**
 弹出框工具
 */
@interface JCPopupUtils : NSObject

@property (nonatomic, strong) JCPopupUtilsLayoutAndAnimation *layoutAndAnimation;//保存显示动画和隐藏动画,可继承此类来写自定义的布局和动画，然后设置此property, 或者给此类实现分类，来实现自定义布局和动画
@property (nonatomic, readonly) UIView *containerView;//整个大的容器,填满superView，放subView
@property (nonatomic, weak, readonly, nullable) __kindof UIView *view;//当前弹出的view
@property (nonatomic, readonly, nullable) __kindof UIView *superView;//当前的容器SuperView

@property (nonatomic, copy, nullable) dispatch_block_t viewWillShowBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidShowBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewWillHideBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidHideBlock;
#pragma mark - views
- (void)showView:(UIView *)view inSuperView:(UIView *)superView;
- (void)hideView;
- (void)relayout;//会调用layoutAndAnimation中的layoutblock来重新布局

@end

@interface UIView (JCPopupUtils)

/**
 在此视图上显示一个View

 @param view view
 */
- (void)poputils_showView:(UIView *)view;

/**
 隐藏当前显示的view
 */
- (void)poputils_hideView;

#pragma mark - view animations and layout block start
@property (nonatomic, strong) JCPopupUtils *popUtils;
- (void)poputils_setWillShowAnimation:(nullable JCPopupUtilsBlock)animations;
- (void)poputils_setShowAnimation:(nullable JCPopupUtilsBlock)animations;
- (void)poputils_setWillHideAnimation:(nullable JCPopupUtilsBlock)animations;
- (void)poputils_setHideAnimation:(nullable JCPopupUtilsBlock)animations;
- (void)poputils_setLayout:(nullable JCPopupUtilsBlock)layout;
#pragma mark - view animations and layout block end

@end

@interface UIViewController (JCPopupUtils)
- (void)poputils_showController:(UIViewController *)controller;
- (void)poputils_hideController;

#pragma mark - controller animations and layout block start
@property (nonatomic, readonly) JCPopupUtils *popUtils;
- (void)poputils_setWillShowAnimation:(nullable JCPopupUtilsBlock)animations;
- (void)poputils_setShowAnimation:(nullable JCPopupUtilsBlock)animations;
- (void)poputils_setWillHideAnimation:(nullable JCPopupUtilsBlock)animations;
- (void)poputils_setHideAnimation:(nullable JCPopupUtilsBlock)animations;
- (void)poputils_setLayout:(nullable JCPopupUtilsBlock)layout;
#pragma mark - controller animations and layout block end


@end


NS_ASSUME_NONNULL_END
