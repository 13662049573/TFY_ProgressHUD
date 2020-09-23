//
//  TFY_BaseMenuController.m
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/22.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "TFY_BaseMenuController.h"

@interface TFY_BaseMenuController ()

@end

@implementation TFY_BaseMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark- 1.重写init方法，定义modalPresentationStyle
- (instancetype)init {
    self = [super init];
    if (self) {
        // VC的默认modalPresentationStyle是UIModalPresentationFullScreen，必须重新设置modal样式，否则推出来的VC不会是透明的
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    
    return self;
}

#pragma mark- 2.实现菜单推出方法
- (void)presentMenuView {
    // 获取根式控制器rootViewController，并将rootViewController设置为当前主控制器（防止菜单弹出时，部分被导航栏或标签栏遮盖）
    UIWindow *window = [self lastWindow];
    UIViewController *rootVC = [self getTheLatestViewController:window.rootViewController];
    rootVC.definesPresentationContext = YES;
    // 当前主控制器推出菜单栏
    if (rootVC.presentedViewController == nil) {
        [rootVC presentViewController:self animated:NO completion:nil];
    }
}
//递归返回最上面的presentedViewController
- (UIViewController *)getTheLatestViewController:(UIViewController *)vc {
    if (vc.presentedViewController == nil) {
        return vc;
    }
    return [self getTheLatestViewController:vc.presentedViewController];
}

- (UIWindow*)lastWindow {
    NSEnumerator  *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;

        BOOL windowIsVisible = !window.hidden&& window.alpha>0;

        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);

        BOOL windowKeyWindow = window.isKeyWindow;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}
#pragma mark- 3.菜单移除方法
- (void)removeMenuView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark- 4.点击菜单栏View，消失（根据需求，看虚不需要）
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeMenuView];// 移除菜单
}


@end
