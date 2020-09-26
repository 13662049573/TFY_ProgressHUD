//
//  TFY_BaseMenuController.h
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/22.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+DrawGraphics.h"

NS_ASSUME_NONNULL_BEGIN

// 菜单展示位置单例
typedef NS_ENUM(NSInteger, MenuPlacements) {
    ShowAtTop = 0,
    ShowAtLeft,
    ShowAtBottom,
    ShowAtRight
};

// 菜单展示动画单例
typedef NS_ENUM(NSInteger, MenuShowAnimationStyle) {
    ShowAnimationDefault = 0,// 没有动画
    ShowAnimationZoom// 缩放动画
};

// 弹窗箭头的样式
typedef NS_ENUM(NSUInteger, MenuArrowStyle) {
    MenuArrowStyleRound = 0, // 圆角箭头
    MenuArrowStyleTriangle// 菱角箭头
};

@class TFY_BaseMenuController;
// 协议
@protocol TFY_BaseMenuControllerDelegate <NSObject>

@optional

/**
 使用不带选中状态的菜单需要实现的协议方法

 tag 被点击的菜单单元标志值
 title 被点击的菜单单元标题
 */
- (void)menu:(TFY_BaseMenuController *)menu didClickedItemUnitWithTag:(NSInteger)tag andItemUnitTitle:(NSString *)title;

/**
 使用带选中状态的菜单需要实现的协议方法

 tag 被点击的菜单单元标志值
 title 被点击的菜单单元标题
 state 菜单单元点击后的状态
 */
- (void)menu:(TFY_BaseMenuController *)menu didClickedMenuItemUnitWithTag:(NSInteger)tag andItemUnitTitle:(NSString *)title itemiUnitPostClickState :(BOOL)state;

@end

// 菜单箭头高度
static CGFloat const ARROWHEIGHT = 10.f;
// 菜单圆润度
static CGFloat const MENUCORNERRADIUS = 5.f;


@interface TFY_BaseMenuController : UIViewController
/** 菜单弹出方法 */
- (void)presentMenuView;

/** 菜单移除方法 */
- (void)removeMenuView;

/** 代理对象 */
@property (nonatomic, weak) id<TFY_BaseMenuControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
