//
//  UIView+JCLayoutForOrientation.m
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/8.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import "UIView+JCMultipleLayoutSupport.h"
#import <objc/runtime.h>

@interface JCViewLayout ()

@property (nonatomic, strong) NSMutableDictionary <id <NSCopying>, dispatch_block_t> *layoutsForState;

@property (nonatomic, copy, nullable) dispatch_block_t layout;

@end

@implementation JCViewLayout

- (NSMutableDictionary<id<NSCopying>,dispatch_block_t> *)layoutsForState{
    if (!_layoutsForState) {
        _layoutsForState = [NSMutableDictionary dictionary];
    }
    return _layoutsForState;
}

- (void)setLayout:(dispatch_block_t)layout forState:(id<NSCopying>)state{
    self.layoutsForState[state] = layout;
    
    [self setLayoutForState:self.state];
}

- (dispatch_block_t)layoutForState:(id<NSCopying>)state{
    return self.layoutsForState[state];
}

- (void)setLayoutNormal:(dispatch_block_t)layoutNormal{
    if (!_state) {
        _state = NSStringFromSelector(@selector(layoutNormal));
    }
    [self setLayout:layoutNormal forState:NSStringFromSelector(@selector(layoutNormal))];
}

- (dispatch_block_t)layoutNormal{
    return [self layoutForState:NSStringFromSelector(_cmd)];
}

- (void)setState:(id<NSCopying>)state{
    if (_state == state) {
        return ;
    }
    
    _state = state;
    
    [self setLayoutForState:state];
}

- (void)setLayoutForState:(id <NSCopying>)state{
    dispatch_block_t layout = [self layoutForState:state] ?: self.layoutNormal;
    if (!layout) {
        return ;
    }
    self.layout = layout;
}

- (void)setLayout:(dispatch_block_t)layout{
    if (_layout == layout) {
        return ;
    }
    _layout = layout;
    
    if (layout) {
        layout();
    }
}



@end

@implementation JCViewLayout (OrientationSupport)

- (void)setLayoutForPortrait:(dispatch_block_t)layoutForPortrait{
    [self setLayout:layoutForPortrait forState:@(UIInterfaceOrientationPortrait)];
}

- (dispatch_block_t)layoutForPortrait{
    return [self layoutForState:@(UIInterfaceOrientationPortrait)];
}

- (void)setLayoutForLandscape:(dispatch_block_t)layoutForLandscape{
    [self setLayout:layoutForLandscape forState:@(UIInterfaceOrientationLandscapeLeft)];
}

- (dispatch_block_t)layoutForLandscape{
    return [self layoutForState:@(UIInterfaceOrientationLandscapeLeft)];
}

- (void)setStateForCurrentOrientation{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.state = @(UIInterfaceOrientationLandscapeLeft);
    }else{
        self.state = @(UIInterfaceOrientationPortrait);
    }
}


@end


@implementation UIView (JCMultipleLayoutSupport)
- (void)setJclayout_viewLayout:(JCViewLayout *)jclayout_viewLayout{
    objc_setAssociatedObject(self, @selector(jclayout_viewLayout), jclayout_viewLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JCViewLayout *)jclayout_viewLayout{
    JCViewLayout *_viewlayout = objc_getAssociatedObject(self, _cmd);
    if (!_viewlayout) {
        _viewlayout = [[JCViewLayout alloc] init];
        [self setJclayout_viewLayout:_viewlayout];
    }
    return _viewlayout;
}

- (void)jclayout_enumerateSetState:(id <NSCopying>)state{
    [self.jclayout_viewLayout setState:state];
    for (UIView *subview in self.subviews) {
        [subview jclayout_enumerateSetState:state];
    }
}

- (void)jclayout_enumerateSetStateForCurrentOrientation{
    [self.jclayout_viewLayout setStateForCurrentOrientation];
    
    for (UIView *subview in self.subviews) {
        [subview jclayout_enumerateSetStateForCurrentOrientation];
    }
}

- (void)jclayout_setLayoutForPortrait:(dispatch_block_t)layoutForPortrait{
    self.jclayout_viewLayout.layoutForPortrait = layoutForPortrait;
}
- (void)jclayout_setLayoutForLandscape:(dispatch_block_t)layoutForLandscape{
    self.jclayout_viewLayout.layoutForLandscape = layoutForLandscape;
}

@end
