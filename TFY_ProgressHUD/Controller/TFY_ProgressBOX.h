//
//  TFY_ProgressBOX.h
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/9.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ProgressBOXType){
    ProgressBOX_ERROR = 0,  // 错误信息
    ProgressBOX_SUCCESS,    // 成功信息
    ProgressBOX_PROMPT,     // 提示信息
    ProgressBOX_LOADING,     //加载圈
    ProgressBOX_DISMISS,    //关闭
    ProgressBOX_TEXT,        //只有文本显示
};

typedef NS_ENUM(NSInteger, ProgressViewStyle) {
    /** 百分百和文字 默认 */
    ProgressBOX_percentAndText = 0,
    /** 百分百和圆环 */
    ProgressBOX_percentAndRing,
    /** 圆环 */
    ProgressBOX_Ring,
    /** 扇形 */
    ProgressBOX_Sector,
    /** 长条形 */
    ProgressBOX_Rectangle,
    /** 球 */
    ProgressBOX_ball,
};

NS_ASSUME_NONNULL_BEGIN

@interface TFY_Timer : NSObject
/**
  start 开始时间
  interval 间隔多少秒执行下一次
  repeats 是否开启循环执行
  async 选择主线程还是子线程执行
 */
+ (NSString *)timerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(void))completion;

/**
 target 那个对象需要执行
 selector 执行方法
 start 开始时间
 interval 间隔多少秒执行下一次
 repeats 是否开启循环执行
 async 选择主线程还是子线程执行
 */
+ (NSString *)timerWithTarget:(id)target
                     selector:(SEL)selector
                    StartTime:(NSTimeInterval)start
                     interval:(NSTimeInterval)interval
                      repeats:(BOOL)repeats
                    mainQueue:(BOOL)async;

/**取消定时器，通过上面返回ID*/
+ (void)cancel:(NSString *)timerID;

@end

typedef NS_ENUM(NSUInteger, TFY_BOXMaskType) {
    //允许与底层视图交互
    TFY_BOXMaskType_None,
    //不允许与底层视图交互。
    TFY_BOXMaskType_Clear,
    //不允许与底层视图、背景进行交互。
    TFY_BOXMaskType_Dimmed
};

@interface TFY_ProgressBOX : UIView
/**
 *  交互类型
 */
@property (nonatomic, assign) TFY_BOXMaskType maskType;
/**
 * 加载模式选择
 */
@property (nonatomic, assign) ProgressViewStyle ProgressViewStyle;
/**
 下载进度,内部按1.0计算
 */
@property (nonatomic, assign) CGFloat progress;
/**
 宽度 默认10
 */
@property (nonatomic, assign) CGFloat progressWidth;
/**
 进度条View背景颜色
 */
@property(nonatomic,strong) UIColor *progressViewBgColor;
/**
 进度条颜色
 */
@property(nonatomic,strong) UIColor *progressBarColor;
/**
 * 展示有加载圈的文字提示
 */
+ (void)showWithStatus:(NSString*)content;
+ (void)showWithStatus:(NSString*)content duration:(NSTimeInterval)duration;
+ (void)showWithAttributedContent:(NSAttributedString *)attributedString;
/**
 *  展示成功的状态  string 传字符串
 */
+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
/**
 *  展示失败的状态 string 字符串
 */
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
/**
 *  展示提示信息  string 字符串
 */
+ (void)showPromptWithStatus:(NSString *)string;
+ (void)showPromptWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
/**
 *  只显示文本，没有任何多余的显示
 */
+ (void)showTextWithStatus:(NSString *)string;
+ (void)showTextWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
/**
 * 带有百分百和文字
 */

/**
 * 关闭提示框 
 */
+ (void)dismiss;
@end

@interface PromptView : UIView

- (void)StatusContentString:(NSString *_Nullable)content AttributedString:(NSAttributedString *_Nullable)attributedString Status:(ProgressBOXType)status;

/**
 下载进度,内部按1.0计算
 */
@property (nonatomic, assign) CGFloat progress;
/**
 宽度 默认10
 */
@property (nonatomic, assign) CGFloat progressWidth;

/** 进度条View背景颜色 */
@property(nonatomic,strong) UIColor *progressViewBgColor;
/** 进度条颜色 */
@property(nonatomic,strong) UIColor *progressBarColor;

@property (nonatomic, assign) ProgressViewStyle ProgressViewStyle;

@end

NS_ASSUME_NONNULL_END
