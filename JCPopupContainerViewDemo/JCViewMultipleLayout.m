//
//  UIView+JCLayoutForOrientation.m
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/8.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import "JCViewMultipleLayout.h"
#import <objc/runtime.h>
#import "UIDevice+ScreenSize.h"

@interface JCViewMultipleLayout ()

@property (nonatomic, strong) NSMutableDictionary <id <NSCopying>, dispatch_block_t> *layoutsForState;

@property (nonatomic, copy, nullable) dispatch_block_t layout;

@end

@implementation JCViewMultipleLayout

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
- (void)setLayout:(dispatch_block_t)layout forStateInt:(NSInteger)state{
    [self setLayout:layout forState:@(state)];
}

- (dispatch_block_t)layoutForState:(id<NSCopying>)state{
    return self.layoutsForState[state];
}
- (dispatch_block_t)layoutForStateInt:(NSInteger)state{
    return [self layoutForState:@(state)];
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


@implementation UIView (JCMultipleLayoutSupport)
- (void)setJclayout_viewLayout:(JCViewMultipleLayout *)jclayout_viewLayout{
    objc_setAssociatedObject(self, @selector(jclayout_viewLayout), jclayout_viewLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JCViewMultipleLayout *)jclayout_viewLayout{
    JCViewMultipleLayout *_viewlayout = objc_getAssociatedObject(self, _cmd);
    if (!_viewlayout) {
        _viewlayout = [[JCViewMultipleLayout alloc] init];
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

@end
