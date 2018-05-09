//
//  JCPopupUtilsLayoutAndAnimationSystemAlert.m
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/7.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import "JCPopupUtilsLayoutAndAnimationSystemAlert.h"
#import "JCPopupUtils.h"
#import <Masonry.h>

@implementation JCPopupUtilsLayoutAndAnimationSystemAlert


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setLayoutBlock:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
            thePopUtils.containerView.backgroundColor = [UIColor greenColor];
            [thePopUtils.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(thePopUtils.containerView);
                make.size.mas_equalTo(CGSizeMake(200, 200));
            }];
        }];
        
        [self.animationForShow setWillAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
            thePopUtils.containerView.alpha = 0;
            CGFloat height = CGRectGetMidY(thePopUtils.superView.bounds) + 200 / 2;
            thePopUtils.view.transform = CGAffineTransformMakeTranslation(0, height);
        }];
        
        [self.animationForShow setAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
            thePopUtils.containerView.alpha = 1;
            thePopUtils.view.transform = CGAffineTransformIdentity;
        }];
        
        [self.animationForHide setAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
            thePopUtils.containerView.alpha = 0;
            CGFloat height = CGRectGetMidY(thePopUtils.superView.bounds) + 200 / 2;
            thePopUtils.view.transform = CGAffineTransformMakeTranslation(0, height);
        }];
    }
    return self;
}

@end
