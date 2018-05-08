//
//  UIView+JCLayoutForOrientation.h
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/8.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



/**
 给UIView添加不同状态下的不同布局回调
 */
@interface JCViewLayout : NSObject

/**
 设置在state状态下的布局回调

 @param layout 回调
 @param state 状态
 */
- (void)setLayout:(dispatch_block_t)layout forState:(id <NSCopying>)state;

/**
 获取在state下的回调

 @param state 状态
 @return 布局回调
 */
- (dispatch_block_t)layoutForState:(id <NSCopying>)state;

/**
 默认的布局回调，如果没有设置其他状态的回调，则会默认调用此状态来布局
 */
@property (nonatomic, copy, nullable) dispatch_block_t layoutNormal;

/**
 当前状态，设置state会有可能重新布局
 */
@property (nonatomic, strong) id <NSCopying> state;

@end

@interface JCViewLayout (OrientationSurport)

/**
 根据当前的横竖屏来设置横竖屏下的布局
 */
- (void)setStateForCurrentOrientation;

/**
 竖屏下的布局
 */
@property (nonatomic, copy, nullable) dispatch_block_t layoutForPortrait;

/**
 横屏下的布局
 */
@property (nonatomic, copy, nullable) dispatch_block_t layoutForLandscape;
@end

@interface UIView (JCLayoutForOrientation)

@property (nonatomic, strong) JCViewLayout * jclayout_viewLayout;

/**
 会调用自己的 jclayout_viewLayout来布局，然后遍历子view，布局子view

 @param state 状态
 */
- (void)jclayout_enumerateSetState:(id <NSCopying>)state;

/**
 调用 自己的setStateForCurrentOrientation， 并遍历子view，也调用setStateForCurrentOrientation
 */
- (void)jclayout_enumerateSetStateForCurrentOrientation;


/**
 self.jclayout_viewLayout.layoutForPortrait = layoutForPortrait;

 @param layoutForPortrait 竖屏布局
 */
- (void)jclayout_setLayoutForPortrait:(nullable dispatch_block_t)layoutForPortrait;


/**
 self.jclayout_viewLayout.layoutForLandscape = layoutForLandscape;

 @param layoutForLandscape 横屏布局
 */
- (void)jclayout_setLayoutForLandscape:(nullable dispatch_block_t)layoutForLandscape;

@end

NS_ASSUME_NONNULL_END
