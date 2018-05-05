//
//  JCPopupUtilsLayoutAndAnimation+DefaultLayout.m
//  JCPopupContainerViewDemo
//
//  Created by Cerko on 2018/5/5.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import "JCPopupUtilsLayoutAndAnimation+DefaultLayout.h"
#import "JCPopupUtils.h"
#import <Masonry.h>

@implementation JCPopupUtilsLayoutAndAnimation (DefaultLayout)

- (void)setToDefaultLayoutAndAnimation{
    [self setLayoutBlock:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
        [thePopUtils.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(thePopUtils.containerView);
            make.height.mas_equalTo(200);
        }];
    }];
    
    [self.animationForShow setWillAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
       thePopUtils.view.transform = CGAffineTransformMakeTranslation(0, 200);
    }];
    
    [self.animationForShow setAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
       thePopUtils.view.transform = CGAffineTransformIdentity;
    }];
    
    [self.animationForHide setWillAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
        
    }];
    
    [self.animationForHide setAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
        thePopUtils.view.transform = CGAffineTransformMakeTranslation(0, 200);
    }];
}

- (void)setToHorizontalLayoutAndAnimation{
    [self setLayoutBlock:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
        [thePopUtils.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.equalTo(thePopUtils.containerView);
            make.width.mas_equalTo(200);
        }];
    }];
    
    [self.animationForShow setWillAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
        thePopUtils.view.transform = CGAffineTransformMakeTranslation(200, 0);
    }];
    
    [self.animationForShow setAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
        thePopUtils.view.transform = CGAffineTransformIdentity;
    }];
    
    [self.animationForHide setAnimations:^(__kindof JCPopupUtils * _Nonnull thePopUtils) {
        thePopUtils.view.transform = CGAffineTransformMakeTranslation(200, 0);
    }];

}

@end
