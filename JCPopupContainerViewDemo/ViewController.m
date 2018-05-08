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
#import "UIView+JCMultipleLayoutSupport.h"
#import "UIDevice+ScreenSize.h"


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
    [self.popUtils setLayoutAndAnimation:layoutAndAnimationRight forState:@(1)];
}

- (IBAction)onClickPopupBtn:(id)sender {
//    MyViewController *controller = [[MyViewController alloc] init];
//    [self poputils_showController:controller];
//    for (JCInterfaceOrientation i = JCInterfaceOrientationPortrait; i <= JCInterfaceOrientationLandscape; i <<= 1) {
//        for (JCScreenSize j = JCScreenSize480x320; j <= JCScreenSize812x375; j <<= 1) {
//            NSInteger state = stateWithOrientationAndScreenSize(i, j);
//            NSLog(@"state %@", @(state));
//        }
//    }
//    for (NSUInteger i = JCScreenSize480x320; i <= JCScreenSize812x375; i++ ) {
//        NSLog(@"i<<1:%@", @((i << 1) + 0));
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self poputils_setStateForCurrentOrientation];
        [self.view jclayout_enumerateSetStateForCurrentOrientation];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

- (BOOL)shouldAutorotate{
    return !self.popUtils.isViewShowing;
}


@end
