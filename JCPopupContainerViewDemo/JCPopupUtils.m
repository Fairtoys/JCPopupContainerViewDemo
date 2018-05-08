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
#import "JCPopupUtilsLayoutAndAnimation.h"

@interface JCPopupUtils () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableDictionary <id <NSCopying>, JCPopupUtilsLayoutAndAnimation *> *layoutAnimationsForState;

@property (nonatomic, strong) UIView *containerView;//整个大的容器
@property (nonatomic, strong) UIView *backgroundView;//当view的大小不填满整个containerView时，用来设置背景色
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;//点击事件，点击背景

@property (nonatomic, weak, nullable) __kindof UIView *view;//当前弹出的view

@property (nonatomic, copy, nullable) dispatch_block_t viewWillShowInnerBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidShowInnerBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewWillHideInnerBlock;
@property (nonatomic, copy, nullable) dispatch_block_t viewDidHideInnerBlock;
- (void)relayout;//会调用layoutAndAnimation中的layoutblock来重新布局
@property (nonatomic, weak) JCPopupUtilsLayoutAndAnimation *layoutAndAnimation;//保存显示动画和隐藏动画,可继承此类来写自定义的布局和动画，然后设置此property, 或者给此类实现分类，来实现自定义布局和动画
@end

@implementation JCPopupUtils

- (NSMutableDictionary<id <NSCopying> ,JCPopupUtilsLayoutAndAnimation *> *)layoutAnimationsForState{
    if (!_layoutAnimationsForState) {
        _layoutAnimationsForState = [NSMutableDictionary dictionary];
    }
    return _layoutAnimationsForState;
}

- (void)setLayoutAndAnimationNormal:(JCPopupUtilsLayoutAndAnimation *)layoutAndAnimationNormal{
    //如果当前状态没有，则设置默认状态
    if (!_state) {
        _state = NSStringFromSelector(@selector(layoutAndAnimationNormal));
    }
    [self setLayoutAndAnimation:layoutAndAnimationNormal forState:NSStringFromSelector(@selector(layoutAndAnimationNormal))];
}

- (JCPopupUtilsLayoutAndAnimation *)layoutAndAnimationNormal{
    return [self layoutAndAnimationForState:NSStringFromSelector(_cmd)];
}

- (void)setLayoutAndAnimation:(nullable __kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation forState:(id <NSCopying>)state{
    self.layoutAnimationsForState[state] = layoutAndAnimation;
    
    [self layoutForState:self.state];
}

- (nullable __kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimationForState:(id <NSCopying>)state{
    return self.layoutAnimationsForState[state];
}

- (void)setState:(id<NSCopying>)state{
    if (_state == state) {
        return ;
    }
    _state = state;
    
    [self layoutForState:state];
}

- (void)layoutForState:(id <NSCopying>)state{
    JCPopupUtilsLayoutAndAnimation *layoutAndAnimation = self.layoutAnimationsForState[state] ?: self.layoutAndAnimationNormal;
    if (!layoutAndAnimation) {
        return ;
    }
    
    self.layoutAndAnimation = layoutAndAnimation;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [_containerView addSubview:self.backgroundView];
        [_containerView addGestureRecognizer:self.tapGesture];
    }
    return _containerView;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
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

- (void)setLayoutAndAnimation:(__kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation{
    if (_layoutAndAnimation == layoutAndAnimation) {
        return ;
    }
    _layoutAndAnimation = layoutAndAnimation;
    
    [self relayout];
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
    if (_view.superview) {
        if (_layoutAndAnimation.layoutBlock) {
            _layoutAndAnimation.layoutBlock(self);
        }
    }
}

- (BOOL)isViewShowing{
    return _view.superview;
}

@end

@implementation JCPopupUtils (OrientationSupport)

- (void)setLayoutAndAnimationForPortrait:(__kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation{
    [self setLayoutAndAnimation:layoutAndAnimation forState:@(UIInterfaceOrientationPortrait)];
}

- (JCPopupUtilsLayoutAndAnimation *)layoutAndAnimationForPortrait{
    return [self layoutAndAnimationForState:@(UIInterfaceOrientationPortrait)];
}

- (void)setLayoutAndAnimationForLandscape:(__kindof JCPopupUtilsLayoutAndAnimation *)layoutAndAnimation{
    [self setLayoutAndAnimation:layoutAndAnimation forState:@(UIInterfaceOrientationLandscapeLeft)];
}

- (JCPopupUtilsLayoutAndAnimation *)layoutAndAnimationForLandscape{
    return [self layoutAndAnimationForState:@(UIInterfaceOrientationLandscapeLeft)];
}

- (void)setStateForCurrentOrientation{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.state = @(UIInterfaceOrientationLandscapeLeft);
    }else{
        self.state = @(UIInterfaceOrientationPortrait);
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

- (void)poputils_showView:(UIView *)view{
    [self.popUtils showView:view inSuperView:self];
}

- (void)poputils_hideView{
    [self.popUtils hideView];
}

- (void)poputils_setStateForCurrentOrientation{
    [self.popUtils setStateForCurrentOrientation];
}

@end

@implementation UIViewController (JCPopupUtils)

- (JCPopupUtils *)popUtils{
    return self.view.popUtils;
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

- (void)poputils_setStateForCurrentOrientation{
    [self.view poputils_setStateForCurrentOrientation];
}

@end