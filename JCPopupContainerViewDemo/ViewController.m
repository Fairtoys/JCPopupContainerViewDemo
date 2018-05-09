//
//  ViewController.m
//  JCPopupContainerViewDemo
//
//  Created by huajiao on 2018/5/3.
//  Copyright © 2018年 huajiao. All rights reserved.
//

#import "ViewController.h"
#import "JCPopupUtils.h"
#import "MyViewController.h"
#import <Masonry.h>
#import "JCPopupUtilsLayoutAndAnimation+DefaultLayout.h"
#import "JCPopupUtilsLayoutAndAnimationFromBottom.h"
#import "JCPopupUtilsLayoutAndAnimationFromRight.h"
#import "JCPopupUtilsLayoutAndAnimationSystemAlert.h"
#import "JCViewMultipleLayout.h"
#import "UIDevice+ScreenSize.h"
#import "JCPopupUtils+JCOrientationAndScreenSizeSupport.h"
#import "JCViewMultipleLayout+JCOrientationAndScreenSizeSupport.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintY;
@property (weak, nonatomic) IBOutlet UIButton *popBt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPopBtnLayouts];
    [self setupPopupUtils];
}

- (void)setupPopBtnLayouts{
    __weak typeof(self) weakSelf = self;
    [self.popBt.jclayout_viewLayout setLayoutNormal:^{
        weakSelf.constraintY.constant = -100;
    }];
    
}

- (void)setupPopupUtils{
    
//    JCPopupUtilsLayoutAndAnimationFromBottom *layoutAndAnimation = [[JCPopupUtilsLayoutAndAnimationFromBottom alloc] init];
//    layoutAndAnimation.height = 300;
//    self.popUtils.layoutAndAnimationForPortrait = layoutAndAnimation;
    
    JCPopupUtilsLayoutAndAnimationSystemAlert *layoutAnimationAlert = [[JCPopupUtilsLayoutAndAnimationSystemAlert alloc] init];
//    self.popUtils.layoutAndAnimationForPortrait = layoutAnimationAlert;
    self.popUtils.layoutAndAnimationNormal = layoutAnimationAlert;
    JCPopupUtilsLayoutAndAnimationFromRight *layoutAndAnimationRight = [[JCPopupUtilsLayoutAndAnimationFromRight alloc] init];
    layoutAndAnimationRight.width = 200;
//    [self.popUtils setLayoutAndAnimation:layoutAndAnimationRight forState:@(1)];
    [self.popUtils setLayoutAndAnimation:layoutAndAnimationRight forOrientationAndScreenSize:JCInterfaceOrientationLandscape];
}

- (IBAction)onClickPopupBtn:(id)sender {
    MyViewController *controller = [[MyViewController alloc] init];
    [self poputils_showController:controller];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self poputils_setStateForCurrentOrientationAndScreenSize];
        [self.view jclayout_enumerateSetStateForCurrentOrientationAndScreenSize];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

- (BOOL)shouldAutorotate{
    return !self.popUtils.isViewShowing;
}


@end
