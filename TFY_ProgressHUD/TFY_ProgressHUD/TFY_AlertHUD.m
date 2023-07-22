//
//  TFY_AlertHUD.m
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2023/7/22.
//  Copyright © 2023 恋机科技. All rights reserved.
//

#import "TFY_AlertHUD.h"
#import "TFY_ProgressHUD.h"
#import <UIKit/UIKit.h>

@interface TFY_AlertHUD ()
{
    TFY_ProgressHUD *_hud;
}
@end

@implementation TFY_AlertHUD

+ (TFY_AlertHUD *)shareInstance{
    static TFY_AlertHUD * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[TFY_AlertHUD alloc]init];
    });
    return macro;
}

-(UIImage *)tfy_fileImage:(NSString *)fileImage {
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"TFY_ProgressHUD" ofType:@"bundle"] stringByAppendingPathComponent:fileImage]];
}

#pragma mark - HUD
- (void)setHudTextAttibute{
    _hud.detailsLabelFont = [UIFont systemFontOfSize:15];
}
- (void)showIndeterminate{
    [self showIndeterminateWithStatus:nil];
}
- (void)showIndeterminateWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [TFY_ProgressHUD showHUDAddedTo:[self lastWindow] animated:YES];
    if (status) {
        _hud.detailsLabelText = status;
    }else{
        _hud.detailsLabelText = @"请稍等...";
    }
    [self setHudTextAttibute];
}
- (void)showSuccessWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [TFY_ProgressHUD showHUDAddedTo:[self lastWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = ProgressHUDModeCustomView;
    UIImage *image = [[self tfy_fileImage:@"lg_hud_success"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
    [self setHudTextAttibute];
    [_hud hide:YES afterDelay:2.0f];
}
- (void)showErrorWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [TFY_ProgressHUD showHUDAddedTo:[self lastWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = ProgressHUDModeCustomView;
    UIImage *image = [[self tfy_fileImage:@"lg_hud_error"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
     [self setHudTextAttibute];
    [_hud hide:YES afterDelay:2.0f];
}
- (void)showErrorWithError:(NSError *)error{
    NSString *errorDesc = error.localizedDescription;
    if (!errorDesc || errorDesc.length == 0) {
        errorDesc = @"未知错误";
    }
    [self showErrorWithStatus:errorDesc];
}
- (void)showInfoWithStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [TFY_ProgressHUD showHUDAddedTo:[self lastWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = ProgressHUDModeCustomView;
    UIImage *image = [[self tfy_fileImage:@"lg_hud_warning"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _hud.customView = [[UIImageView alloc] initWithImage:image];
    _hud.detailsLabelText = status;
     [self setHudTextAttibute];
    [_hud hide:YES afterDelay:2.0f];
}
- (void)showStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [TFY_ProgressHUD showHUDAddedTo:[self lastWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = ProgressHUDModeText;
    _hud.detailsLabelText = status;
     [self setHudTextAttibute];
    _hud.yOffset = ([UIScreen mainScreen].bounds.size.height -64)/2 - 100;
    [_hud hide:YES afterDelay:2.0f];
}
- (void)showRedStatus:(NSString *)status{
    if (_hud) {
        [self hide];
    }
    _hud = [TFY_ProgressHUD showHUDAddedTo:[self lastWindow] animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.mode = ProgressHUDModeText;
    _hud.detailsLabelText = status;
    _hud.detailsLabelColor = [UIColor redColor];
     [self setHudTextAttibute];
    _hud.yOffset = ([UIScreen mainScreen].bounds.size.height -64)/2 - 100;
    [_hud hide:YES afterDelay:2.0f];
}

- (void)showBarDeterminateWithProgress:(CGFloat)progress{
    [self showBarDeterminateWithProgress:progress status:@"上传中..."];
}

- (void)showBarDeterminateWithProgress:(CGFloat)progress status:(NSString *)status{
    if (_hud && _hud.mode != ProgressHUDModeDeterminateHorizontalBar) {
        [self hide];
    }
    if (!_hud) {
        _hud = [TFY_ProgressHUD showHUDAddedTo:[self lastWindow] animated:YES];
        _hud.detailsLabelText = status;
        _hud.mode = ProgressHUDModeDeterminateHorizontalBar;
    }
    _hud.progress = progress;
    _hud.detailsLabelText = status;
    if (progress >= 1) {
        _hud.detailsLabelText = @"已完成";
        [self hide];
    }
}

- (void)hide{
    [_hud hide:YES];
    _hud = nil;
}

BOOL TFY_IsIpad(void){
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

UIColor *TFY_Color(NSInteger hex){
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
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

@end
