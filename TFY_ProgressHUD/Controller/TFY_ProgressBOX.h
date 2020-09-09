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


@interface TFY_ProgressBOX : UIView
/**
 * 展示有加载圈的文字提示
 */
+ (void)showWithStatus:(NSString*)content;
/**
 * 关闭提示框 
 */
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
