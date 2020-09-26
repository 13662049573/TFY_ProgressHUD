//
//  TFY_ArrowheadMenu.h
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/22.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "TFY_BaseMenuController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ArrowheadMenu : TFY_BaseMenuController
#pragma mark- 自定义风格

/**
 自定义UI风格创建菜单，根据自己风格设置菜单UI元素

  titleArray 菜单单元标题
  iconArray 菜单单元图标，存放image的名字字符串
  size 菜单单元格的大小（宽和高）
  font 菜单标题字体
  fontColor 菜单字体颜色
  menuBackColor 菜单背景颜色
  separatorColor 菜单单元分割线颜色
  interval 菜单距离触发菜单的控件的距离，可为负数
  arrowStyle 菜单箭头的风格，尖角和圆角两种
  placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
  animation 菜单弹出动画
 @return 返回菜单对象
 */
- (instancetype _Nullable)initCustomArrowheadMenuWithTitle:(NSArray<NSString *>  *_Nonnull)titleArray icon:(NSArray<NSString *>  *_Nullable)iconArray menuUnitSize:(CGSize)size menuFont:(UIFont * _Nullable)font menuFontColor:(UIColor * _Nullable)fontColor menuBackColor:(UIColor *_Nullable)menuBackColor menuSegmentingLineColor:(UIColor *_Nullable)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation;

#pragma mark- 默认风格

/**
 默认UI风格菜单,快速创建菜单
 
  titleArray 菜单单元标题
  iconArray 菜单单元图标，存放image的名字字符串
  placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
 @return 返回菜单对象
 */
- (instancetype _Nullable)initDefaultArrowheadMenuWithTitle:(NSArray<NSString *>  *_Nonnull)titleArray icon:(NSArray<NSString *>  *_Nullable)iconArray menuPlacements:(MenuPlacements)placements;


/**
 菜单展示API

  sender 触发菜单的控件
 */
- (void)presentMenuView:(NSObject *_Nonnull)sender;
@end

NS_ASSUME_NONNULL_END
