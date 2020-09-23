//
//  TFY_CenterMenu.h
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/22.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "TFY_BaseMenuController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CenterMenu : TFY_BaseMenuController
#pragma mark- 默认风格
- (instancetype _Nullable)initDefaultCenterMenuWithTitle:(NSArray<NSString *>  *_Nonnull)titleArray icon:(NSArray<NSString *>  *_Nullable)iconArray;

#pragma mark- 自定义风格
- (instancetype _Nullable)initCustomCenterMenuWithTitle:(NSArray<NSString *>  *_Nonnull)titleArray icon:(NSArray<NSString *>  *_Nullable)iconArray menuUnitSize:(CGSize)size  menuCornerRadius:(CGFloat)menuRoundedRadius menuFont:(UIFont * _Nullable)font menuFontColor:(UIColor * _Nullable)fontColor menuBackColor:(UIColor *_Nullable)menuBackColor menuSegmentingLineColor:(UIColor *_Nullable)separatorColor menuMaskColor:(UIColor *_Nullable)menuMaskColor;
@end

NS_ASSUME_NONNULL_END
