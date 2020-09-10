//
//  TFY_ProgressBOX.h
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/9.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface NSString (BOX)
/**
 * 根据字体、行数、行间距和指定的宽度constrainedWidth计算文本占据的size lineSpacing 行间距 constrainedWidth 文本指定的宽度
 */
- (CGSize)tfy_textSizeWithFont:(UIFont *)font numberOfLines:(NSInteger)numberOfLines lineSpacing:(CGFloat)lineSpacing constrainedWidth:(CGFloat)constrainedWidth;
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

//交互类型
@property (nonatomic, assign) TFY_BOXMaskType maskType;

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
 * 关闭提示框 
 */
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
