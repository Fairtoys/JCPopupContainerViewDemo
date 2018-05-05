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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.popUtils.layoutAndAnimation setToDefaultLayoutAndAnimation];
    
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
        if (size.width > size.height) {
            [self.popUtils.layoutAndAnimation setToHorizontalLayoutAndAnimation];
        }else{
            [self.popUtils.layoutAndAnimation setToDefaultLayoutAndAnimation];
        }
        [self.popUtils relayout];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}


@end
