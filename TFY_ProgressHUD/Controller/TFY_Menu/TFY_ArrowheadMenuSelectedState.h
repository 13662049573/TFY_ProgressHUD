//
//  TFY_ArrowheadMenuSelectedState.h
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/22.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "TFY_BaseMenuController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ArrowheadMenuSelectedState : TFY_BaseMenuController
/**
 是否允许多选，默认是单选
 */
@property (nonatomic, assign) BOOL allowsMultipleSelection;

#pragma mark- 默认风格

/**
 默认UI风格创建菜单

  normalTitleArray 非选中状态下，菜单单元标题
  selectedTitleArray 选中状态下，菜单单元标题
  normalIconArray 非选中状态下，菜单单元图标，存放image的名字字符串
  selectedIconArray 选中状态下，菜单单元图标，存放image的名字字符串
  normalTitleColor 非选中状态下，菜单单元字体颜色
  selectedTitleColor 选中状态下，菜单单元字体颜色
  placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
 @return 返回菜单对象
 */
- (instancetype _Nullable)initDefaultArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *>  *_Nonnull)normalTitleArray selectedTitle:(NSArray<NSString *>  *_Nonnull)selectedTitleArray normalIcon:(NSArray<NSString *>  *_Nullable)normalIconArray selectedIcon:(NSArray<NSString *>  *_Nullable)selectedIconArray menuNormalTitleColor:(UIColor * _Nullable)normalTitleColor menuSelectedTitleColor:(UIColor * _Nullable)selectedTitleColor menuPlacements:(MenuPlacements)placements;

#pragma mark- 自定义风格
/**
 自定义UI风格创建菜单，根据自己风格设置菜单UI元素，菜单每个单元的非选中状态下字体颜色相同，菜单每个单元的选中状态下字体颜色也相同

  normalTitleArray 非选中状态下，菜单单元标题
  selectedTitleArray 选中状态下，菜单单元标题
  normalIconArray 非选中状态下，菜单单元图标，存放image的名字字符串
  selectedIconArray 选中状态下，菜单单元图标，存放image的名字字符串
  normalTitleColor 非选中状态下，菜单单元字体颜色
  selectedTitleColor 选中状态下，菜单单元字体颜色
  size 菜单单元格的大小（宽和高）
  font 菜单单元格标题字体
  menuBackColor 菜单背景颜色
  separatorColor 菜单单元分割线颜色
  interval 菜单距离触发菜单的控件的距离，可为负数
  arrowStyle 菜单箭头的风格，尖角和圆角两种
  placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
  animation 菜单弹出动画
 @return 返回菜单对象
 */
- (instancetype _Nullable)initCustomArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *>  *_Nonnull)normalTitleArray selectedTitle:(NSArray<NSString *>  *_Nonnull)selectedTitleArray normalIcon:(NSArray<NSString *>  *_Nullable)normalIconArray selectedIcon:(NSArray<NSString *>  *_Nullable)selectedIconArray menuNormalTitleColor:(UIColor * _Nonnull)normalTitleColor menuSelectedTitleColor:(UIColor * _Nonnull)selectedTitleColor  menuUnitSize:(CGSize)size menuFont:(UIFont * _Nonnull)font menuBackColor:(UIColor *_Nonnull)menuBackColor menuSegmentingLineColor:(UIColor *_Nonnull)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation;

/**
 自定义UI风格创建菜单，根据自己风格设置菜单UI元素，菜单每个单元的非选中状态下字体颜色不相同，菜单每个单元的选中状态下字体颜色也不相同
 
  normalTitleArray 非选中状态下，菜单单元标题
  selectedTitleArray 选中状态下，菜单单元标题
  normalIconArray 非选中状态下，菜单单元图标，存放image的名字字符串
  selectedIconArray 选中状态下，菜单单元图标，存放image的名字字符串
  normalTitleColorArray 非选中状态下，菜单单元字体颜色
  selectedTitleColorArray 选中状态下，菜单单元字体颜色
  size 菜单单元格的大小（宽和高）
  font 菜单单元格标题字体
  menuBackColor 菜单背景颜色
  separatorColor 菜单单元分割线颜色
  interval 菜单距离触发菜单的控件的距离，可为负数
  arrowStyle 菜单箭头的风格，尖角和圆角两种
  placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
  animation 菜单弹出动画
 @return 返回菜单对象
 */
- (instancetype _Nullable)initCustomArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *>  *_Nonnull)normalTitleArray selectedTitle:(NSArray<NSString *>  *_Nonnull)selectedTitleArray normalIcon:(NSArray<NSString *>  *_Nullable)normalIconArray selectedIcon:(NSArray<NSString *>  *_Nullable)selectedIconArray menuNormalTitleColorArray:(NSArray<UIColor *>  *_Nonnull)normalTitleColorArray menuSelectedTitleColorArray:(NSArray<UIColor *>  *_Nonnull)selectedTitleColorArray  menuUnitSize:(CGSize)size menuFont:(UIFont * _Nonnull)font menuBackColor:(UIColor *_Nonnull)menuBackColor menuSegmentingLineColor:(UIColor *_Nonnull)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation;


/**
 菜单展示API
 
  sender 触发菜单的控件
 */
- (void)presentMenuView:(NSObject *_Nonnull)sender;

/**
 菜单项消除选中状态

  tag 菜单的tag标志值
 */
- (void)whenClickedUncheckOwnStatus:(NSInteger)tag;


@end

NS_ASSUME_NONNULL_END
