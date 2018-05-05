//
//  JCPopupUtils.m
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/3.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import "JCPopupUtils.h"
#import <Masonry.h>
#import <objc/runtime.h>


@interface JCPopContainerView : UIView

@end
@implementation JCPopContainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for (UIView *view in self.subviews) {
        CGPoint pointInView = [self convertPoint:point toView:view];
        if ([view pointInside:pointInView withEvent:event]) {
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end



@interface JCPopupUtils () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *containerView;//整个大的容器

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;//点击事件，点击背景

@property (nonatomic, weak, nullable) __kindof UIView *view;//当前弹出的view

@property (nonatomic, copy, nullable) dispatch_block_t viewWillShowInnerBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidShowInnerBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewWillHideInnerBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidHideInnerBlock;

@end


@implementation JCPopupUtils

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[JCPopContainerView alloc] init];
        [_containerView addGestureRecognizer:self.tapGesture];
    }
    return _containerView;
}
- (UIView *)superView{
    return _containerView.superview;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBackgroundView:)];
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    for (UIView *view in self.containerView.subviews) {
        if (CGRectContainsPoint(view.frame, point)) {
            return NO;
        }
    }
    return YES;
}

- (JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation{
    if (!_layoutAndAnimation) {
        _layoutAndAnimation = [[JCPopupUtilsLayoutAndAnimation alloc] init];
    }
    return _layoutAndAnimation;
}

- (void)onClickBackgroundView:(UITapGestureRecognizer *)sender{
    [self hideView];
}

- (void)showView:(UIView *)view inSuperView:(UIView *)superView{
    if (self.viewWillShowInnerBlock) {
        self.viewWillShowInnerBlock();
    }
    if (self.viewWillShowBlock) {
        self.viewWillShowBlock();
    }
    self.view = view;
    [superView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    [self.containerView addSubview:view];
    
    if (self.layoutAndAnimation.layoutBlock) {
        self.layoutAndAnimation.layoutBlock(self);
    }
    //动画
    BOOL userInteractionEnabled = superView.userInteractionEnabled;
    superView.userInteractionEnabled = NO;
    JCPopupUtilsAnimation *animationForShow = self.layoutAndAnimation.animationForShow;
    if (animationForShow.willAnimations) {
        animationForShow.willAnimations(self);
    }
    [UIView animateWithDuration:animationForShow.duration delay:animationForShow.delay options:animationForShow.options animations:^{
        if (animationForShow.animations) {
            animationForShow.animations(self);
        }
    } completion:^(BOOL finished) {
        
        superView.userInteractionEnabled = userInteractionEnabled;
        if (animationForShow.completion) {
            animationForShow.completion(finished);
        }
        if (self.viewDidShowInnerBlock) {
            self.viewDidShowInnerBlock();
        }
        if (self.viewDidShowBlock) {
            self.viewDidShowBlock();
        }
    }];
}

- (void)hideView{
    
    if (self.viewWillHideInnerBlock) {
        self.viewWillHideInnerBlock();
    }

    if (self.viewWillHideBlock) {
        self.viewWillHideBlock();
    }
    //动画
    UIView *superView = self.containerView.superview;
    BOOL userInteractionEnabled = superView.userInteractionEnabled;
    superView.userInteractionEnabled = NO;
    JCPopupUtilsAnimation *animationForHide = self.layoutAndAnimation.animationForHide;
    if (animationForHide.willAnimations) {
        animationForHide.willAnimations(self);
    }
    [UIView animateWithDuration:animationForHide.duration delay:animationForHide.delay options:animationForHide.options animations:^{
        if (animationForHide.animations) {
            animationForHide.animations(self);
        }
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        self.view = nil;
        [self.containerView removeFromSuperview];
        
        superView.userInteractionEnabled = userInteractionEnabled;
        
        if (self.viewDidHideInnerBlock) {
            self.viewDidHideInnerBlock();
        }
        if (self.viewDidHideBlock) {
            self.viewDidHideBlock();
        }
        
        if (animationForHide.completion) {
            animationForHide.completion(finished);
        }
    }];
}

- (void)relayout{
    if (self.layoutAndAnimation.layoutBlock) {
        self.layoutAndAnimation.layoutBlock(self);
    }
}


@end

@implementation UIView (JCPopupUtils)

- (void)setPopUtils:(JCPopupUtils *)popUtils{
    objc_setAssociatedObject(self, @selector(popUtils), popUtils, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JCPopupUtils *)popUtils{
    JCPopupUtils *_popUtils = objc_getAssociatedObject(self, _cmd);
    if (!_popUtils) {
        _popUtils = [[JCPopupUtils alloc] init];
        self.popUtils = _popUtils;
    }
    return _popUtils;
}

- (void)poputils_setWillShowAnimation:(JCPopupUtilsBlock)animations{
    self.popUtils.layoutAndAnimation.animationForShow.willAnimations = animations;
}

- (void)poputils_setShowAnimation:(JCPopupUtilsBlock)animations{
    self.popUtils.layoutAndAnimation.animationForShow.animations = animations;
}

- (void)poputils_setWillHideAnimation:(JCPopupUtilsBlock)animations{
    self.popUtils.layoutAndAnimation.animationForHide.willAnimations = animations;
}

- (void)poputils_setHideAnimation:(JCPopupUtilsBlock)animations{
    self.popUtils.layoutAndAnimation.animationForHide.animations = animations;
}

- (void)poputils_setLayout:(JCPopupUtilsBlock)layout{
    self.popUtils.layoutAndAnimation.layoutBlock = layout;
}

- (void)poputils_showView:(UIView *)view{
    [self.popUtils showView:view inSuperView:self];
}

- (void)poputils_hideView{
    [self.popUtils hideView];
}

@end

@implementation UIViewController (JCPopupUtils)

- (JCPopupUtils *)popUtils{
    return self.view.popUtils;
}
- (void)poputils_setWillShowAnimation:(JCPopupUtilsBlock)animations{
    self.popUtils.layoutAndAnimation.animationForShow.willAnimations = animations;
}
- (void)poputils_setShowAnimation:(JCPopupUtilsBlock)animations{
    self.popUtils.layoutAndAnimation.animationForShow.animations = animations;
}
- (void)poputils_setWillHideAnimation:(JCPopupUtilsBlock)animations{
    self.popUtils.layoutAndAnimation.animationForHide.willAnimations = animations;
}

- (void)poputils_setHideAnimation:(JCPopupUtilsBlock)animations{
    self.popUtils.layoutAndAnimation.animationForHide.animations = animations;
}

- (void)poputils_setLayout:(JCPopupUtilsBlock)layout{
    self.popUtils.layoutAndAnimation.layoutBlock = layout;
}

- (void)poputils_showController:(UIViewController *)controller{
    __weak typeof(self) weakSelf = self;
    [self.popUtils setViewWillShowInnerBlock:^{
        [weakSelf addChildViewController:controller];
    }];
    [self.popUtils setViewDidShowInnerBlock:^{
        [controller didMoveToParentViewController:weakSelf];
    }];
    [self.popUtils setViewWillHideInnerBlock:^{
        [controller willMoveToParentViewController:nil];
    }];
    [self.popUtils setViewDidHideInnerBlock:^{
        [controller removeFromParentViewController];
    }];
    
    [self.view poputils_showView:controller.view];
}

- (void)poputils_hideController{
    [self.view poputils_hideView];
}

@end



