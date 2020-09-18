//
//  TFY_ProgressBOX.m
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/9.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "TFY_ProgressBOX.h"

#define   NotificationCenter [NSNotificationCenter defaultCenter]
//屏幕高
#define   TFY_HUD_Height [UIScreen mainScreen].bounds.size.height
//屏幕宽
#define   TFY_HUD_Width  [UIScreen mainScreen].bounds.size.width
/**
 * 是否是竖屏
 */
#define TFY_HUD_isPortrait      ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||  [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown ) ?YES:NO

//对应屏幕比例宽
#define TFY_HUD_DEBI_width(width)    width *(TFY_HUD_isPortrait ?(375/TFY_HUD_Width):(TFY_HUD_Height/375))

#define TFY_HUD_DEBI_height(height)  height *(TFY_HUD_isPortrait ?(667/TFY_HUD_Height):(TFY_HUD_Width/667))

#define TFY_HUD_GET_MAIN_STARE  dispatch_async(dispatch_get_main_queue(), ^{

#define TFY_HUD_GET_MAIN_END   });

@implementation TFY_Timer
static int i = 0;
// 创建保存timer的容器
static NSMutableDictionary *timers;
dispatch_semaphore_t sem;

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers = [NSMutableDictionary dictionary];
        sem = dispatch_semaphore_create(1);
    });
}

+ (NSString *)timerWithTarget:(id)target selector:(SEL)selector StartTime:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats mainQueue:(BOOL)async{
    if (!target || !selector) {
        return nil;
    }
    return [self timerWithStartTime:start interval:interval repeats:repeats mainQueue:async completion:^{
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector withObject:nil afterDelay:start];
        }
    }];
}

+ (NSString *)timerWithStartTime:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats mainQueue:(BOOL)async completion:(void (^)(void))completion {
    if (!completion || start < 0 ||  interval <= 0) {
        return nil;
    }
    // 创建定时器
    dispatch_queue_t queue = !async ? dispatch_queue_create("gcd.timer.queue", NULL) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue );
    // 设置时间,从什么时候开始，间隔多少，下面相当于2s后开始，每隔一秒一次
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    NSString *timerId = [NSString stringWithFormat:@"%d",i++];
    timers[timerId]=timer;
    dispatch_semaphore_signal(sem);
    // 回调
    dispatch_source_set_event_handler(timer, ^{
        if (completion) {
            completion();
        }
        // 不重复执行就取消timer
        if (!repeats) {
            [self cancel:timerId];
        }
    });
    dispatch_resume(timer);
    return timerId;
}

+ (void)cancel:(NSString *)timerID{
    if (!timerID || timerID.length <= 0) {
        return;
    }
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers[timerID];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers removeObjectForKey:timerID];
    }
    dispatch_semaphore_signal(sem);
}


@end

#pragma mark ------------- ------------- ------------- TFY_ProgressBOX  ------------------ ------------- -------------

@interface TFY_ProgressBOX ()
@property (nonatomic,  strong) PromptView *containerView;
@property (nonatomic,  copy) NSString *timeID;
//当背景被触摸时，弹出窗口会消失。
@property (nonatomic, assign) BOOL shouldDismissOnBackgroundTouch;
//当内容视图被触摸时，弹出窗口会消失默认no
@property (nonatomic, assign) BOOL shouldDismissOnContentTouch;
@end


@implementation TFY_ProgressBOX
static TFY_ProgressBOX *sharedInstance_;

#pragma mark ------------- ------------- -------------  基本数据 ------------------ ------------- -------------

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [NotificationCenter removeObserver:self];
}

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [super allocWithZone:zone];
    });
    return sharedInstance_;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[TFY_ProgressBOX alloc] init];
    });
    return sharedInstance_;
}

- (id)copyWithZone:(NSZone *)zone {
    return sharedInstance_;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = UIColor.clearColor;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        
        self.shouldDismissOnBackgroundTouch = NO;
        self.shouldDismissOnContentTouch = YES;
        self.maskType = TFY_BOXMaskType_Dimmed;
        
        [NotificationCenter addObserver:self selector:@selector(didChangeStatusbarOrientation:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
        [self addSubview:self.containerView];
    }
    return self;
}

- (void)didChangeStatusbarOrientation:(NSNotification *)notification {
    [self updateInterfaceOrientation];
}

- (void)updateInterfaceOrientation {
    self.frame = [[TFY_ProgressBOX sharedInstance] lastWindow].bounds;
    self.containerView.center = self.center;
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
#pragma mark ------------- ------------- -------------  方法实现 ------------------ ------------- -------------
/**
 * 展示有加载圈的文字提示
 */
+ (void)showWithStatus:(NSString*)content {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:content AttributedString:nil Status:ProgressBOX_LOADING];
    [box show:LONG_MAX];
}

+ (void)showWithStatus:(NSString*)content duration:(NSTimeInterval)duration {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:content AttributedString:nil Status:ProgressBOX_LOADING];
    [box show:duration];
}
/**
 * 展示有加载圈的文字提示 attributedString
 */
+ (void)showWithAttributedContent:(NSAttributedString *)attributedString{
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:nil AttributedString:attributedString Status:ProgressBOX_LOADING];
    [box show:1.5];
}

/**
 *  展示成功的状态  string 传字符串
 */
+ (void)showSuccessWithStatus:(NSString*)string {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:string AttributedString:nil Status:ProgressBOX_SUCCESS];
    [box show:1.5];
}
/**
 *  展示成功的状态 string   传字符串  duration 设定显示时间
 */
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:string AttributedString:nil Status:ProgressBOX_SUCCESS];
    [box show:duration];
}
/**
 *  展示失败的状态 string 字符串
 */
+ (void)showErrorWithStatus:(NSString *)string {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:string AttributedString:nil Status:ProgressBOX_ERROR];
    [box show:1.5];
}

+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:string AttributedString:nil Status:ProgressBOX_ERROR];
    [box show:duration];
}
/**
 *  展示提示信息  string 字符串
 */
+ (void)showPromptWithStatus:(NSString *)string {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:string AttributedString:nil Status:ProgressBOX_PROMPT];
    [box show:1.5];
}

+ (void)showPromptWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:string AttributedString:nil Status:ProgressBOX_PROMPT];
    [box show:duration];
}
/**
 *  只显示文本，没有任何多余的显示
 */
+ (void)showTextWithStatus:(NSString *)string {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:string AttributedString:nil Status:ProgressBOX_TEXT];
    [box show:1.5];
}

+ (void)showTextWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    TFY_ProgressBOX *box = [TFY_ProgressBOX new];
    [box.containerView StatusContentString:string AttributedString:nil Status:ProgressBOX_TEXT];
    [box show:duration];
}

- (void)show:(NSTimeInterval)time{
    [[self lastWindow] addSubview:self];
    __weak typeof(self) weakSelf = self;
    TFY_HUD_GET_MAIN_STARE
    __strong typeof(weakSelf) strongSelf = weakSelf;
    strongSelf.containerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    strongSelf.containerView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        strongSelf.containerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        strongSelf.containerView.alpha =1;
    } completion:^(BOOL finished) {
        self.timeID = [TFY_Timer timerWithTarget:self selector:@selector(dismis) StartTime:time interval:1 repeats:NO mainQueue:YES];
    }];
    TFY_HUD_GET_MAIN_END
}

+ (void)dismiss {
    NSString *time = [TFY_ProgressBOX sharedInstance].timeID;
    [TFY_Timer cancel:time];
    [[TFY_ProgressBOX sharedInstance] dismis];
}

- (void)dismis {
    [self.containerView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark ------------- ------------- -------------  懒加载 ------------------ ------------- -------------

- (PromptView *)containerView {
    if (!_containerView) {
        _containerView = [[PromptView alloc] initWithFrame:CGRectMake(0, 0, TFY_HUD_DEBI_width(100), TFY_HUD_DEBI_width(100))];
        _containerView.center = self.center;
    }
    return _containerView;
}

#pragma mark ------------- ------------- -------------  触摸屏事件处理 ------------------ ------------- -------------

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        if (self.shouldDismissOnBackgroundTouch) {
            [[TFY_ProgressBOX sharedInstance] dismis];
        }
        return self.maskType == TFY_BOXMaskType_None ? nil : hitView;
    } else {
        if ([hitView isDescendantOfView:self.containerView] && self.shouldDismissOnContentTouch) {//subview是否是superView的子视图
            [[TFY_ProgressBOX sharedInstance] dismis];
        }
        return hitView;
    }
}


@end

@interface PromptView ()
@property (nonatomic,  strong) UIActivityIndicatorView *spinnerView;
@property (nonatomic,  strong) UIImageView *imageView;
@property (nonatomic,  strong) UILabel *stringLabel;
/** 百分百文字 */
@property (nonatomic, strong) UILabel *percentTextLabel;
/** 长条样式view */
@property (nonatomic, strong) UIView *rectangleView;

@end

@implementation PromptView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin);
        self.clipsToBounds = YES;
        
        self.progressBarColor = [UIColor whiteColor];
        self.progressViewBgColor = UIColor.whiteColor;
       
        self.progressWidth = 5;
        self.ProgressViewStyle = ProgressBOX_percentAndText;
        
        [self addSubview:self.spinnerView];
        [self addSubview:self.imageView];
        [self addSubview:self.stringLabel];
        [self addSubview:self.percentTextLabel];
    }
    return self;
}

- (UIActivityIndicatorView *)spinnerView {
    if (!_spinnerView) {
        _spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinnerView.hidesWhenStopped = YES;
        _spinnerView.bounds = CGRectMake(0, 0, 37, 37);
    }
    return _spinnerView;
}
- (UIImageView *)imageView {
    if (!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _imageView.hidden = YES;
    }
    return _imageView;
}

- (UILabel *)stringLabel {
    if (!_stringLabel) {
        _stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stringLabel.textColor = [UIColor whiteColor];
        _stringLabel.backgroundColor = [UIColor clearColor];
        _stringLabel.adjustsFontSizeToFitWidth = YES;
        _stringLabel.textAlignment = NSTextAlignmentCenter;
        _stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _stringLabel.font = [UIFont boldSystemFontOfSize:16];
        _stringLabel.shadowColor = [UIColor blackColor];
        _stringLabel.shadowOffset = CGSizeMake(0, -1);
        _stringLabel.numberOfLines = 0;
    }
    return _stringLabel;
}

-(UILabel *)percentTextLabel{
    if (!_percentTextLabel) {
        _percentTextLabel = [[UILabel alloc]init];
        _percentTextLabel.text = @"0%";
        _percentTextLabel.textColor = _progressBarColor;
        _percentTextLabel.font = [UIFont systemFontOfSize:13];
        _percentTextLabel.textAlignment = NSTextAlignmentCenter;
        _percentTextLabel.frame = self.bounds;
    }
    return _percentTextLabel;
}


- (void)StatusContentString:(NSString *)content AttributedString:(NSAttributedString *)attributedString Status:(ProgressBOXType)status{
    TFY_HUD_GET_MAIN_STARE
        UIImage *image;
        if(status == ProgressBOX_ERROR){
            image = [self tfy_fileImage:@"my_error" fileName:nil];
        }
        if(status == ProgressBOX_SUCCESS) {
            image = [self tfy_fileImage:@"my_success" fileName:nil];
        }
        if(status == ProgressBOX_PROMPT) {
            image = [self tfy_fileImage:@"my_prompt" fileName:nil];
        }
        if (status == ProgressBOX_LOADING){
            self.imageView.hidden = YES;
            [self.spinnerView startAnimating];
        }
        if (status == ProgressBOX_TEXT) {
            self.imageView.hidden = YES;
            [self.spinnerView stopAnimating];
        }
        if (status!=ProgressBOX_LOADING && status!=ProgressBOX_TEXT) {
            self.imageView.hidden = NO;
            [self.spinnerView stopAnimating];
            if ([image isKindOfClass:[UIImage class]]) {
                self.imageView.image = image;
            } else {
                self.imageView.hidden = YES;
                [self.spinnerView startAnimating];
            }
        }
       [self setStatusContentString:content AttributedString:attributedString Status:status];
    TFY_HUD_GET_MAIN_END
}

- (void)setStatusContentString:(NSString *)content AttributedString:(NSAttributedString *)attributedString Status:(ProgressBOXType)status{
    CGFloat hudWidth = TFY_HUD_DEBI_width(100);
    CGFloat hudHeight = TFY_HUD_DEBI_width(100);
    CGFloat labelH = TFY_HUD_DEBI_width(66);
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    if(content!=nil || ![content isEqualToString:@""]) {
        
        CGSize stringSize = [self sizeWithText:content maxSize:CGSizeMake(TFY_HUD_Width-hudWidth, TFY_HUD_DEBI_width(150)) fontSize:self.stringLabel.font];
        
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        hudHeight = TFY_HUD_DEBI_width(80) + stringHeight;
        if (status == ProgressBOX_TEXT) {
            labelH = 24;
            hudHeight = stringHeight+48;
        }
    
        if (stringWidth > hudWidth)
            hudWidth = ceil(stringWidth / 2) * 2;
        
        if (hudHeight > TFY_HUD_DEBI_width(100)) {
            labelRect = CGRectMake(12, labelH, hudWidth, stringHeight);
            hudWidth += 24;
        } else {
            hudWidth += 24;
            labelRect = CGRectMake(0, labelH, hudWidth, stringHeight);
        }
    }
    
    self.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    
    if(content!=nil || ![content isEqualToString:@""])
        self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, TFY_HUD_DEBI_width(36));
    else
        self.imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    
    self.stringLabel.hidden = NO;
    
    if (content.length>0) {
        self.stringLabel.text = content;
    } else {
        self.stringLabel.attributedText = attributedString;
    }
    
    self.stringLabel.frame = labelRect;
    
    if(content!=nil || ![content isEqualToString:@""])
        self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.bounds)/2)+0.5, TFY_HUD_DEBI_width(40.5));
    else
        self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.bounds)/2)+0.5, ceil(self.bounds.size.height/2)+0.5);
}



-(UIImage *)tfy_fileImage:(NSString *)fileImage fileName:(NSString *)fileName {
    return [UIImage imageWithContentsOfFile:[[[[NSBundle mainBundle] pathForResource:@"TFY_ProgressHUD" ofType:@"bundle"] stringByAppendingPathComponent:fileName] stringByAppendingPathComponent:fileImage]];
}

//计算文字的大小
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(UIFont *)font {
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return nameSize;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (_progress>0) {
        self.imageView.hidden = self.spinnerView.hidden = YES;
    }
    if (self.ProgressViewStyle == ProgressBOX_percentAndText || self.ProgressViewStyle == ProgressBOX_percentAndRing) {
        
      self.percentTextLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
        
    }else if (self.ProgressViewStyle ==ProgressBOX_Ring) {
        
        
    }else  if (self.ProgressViewStyle ==ProgressBOX_Sector) {

        
    }else if(self.ProgressViewStyle ==ProgressBOX_Rectangle){
        
        CGFloat margin = 2 + 1;
        CGFloat maxWidth = self.bounds.size.width - margin * 2;
        CGFloat heigth = self.bounds.size.height - margin * 2;
        self.rectangleView.frame = CGRectMake(margin, margin, maxWidth * progress, heigth);
        
    }else if(self.ProgressViewStyle ==ProgressBOX_ball){
        
        self.percentTextLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
    }
    
    if (_progress >= 1.0) {
        [self removeFromSuperview];
    } else {
        [self setNeedsDisplay];
    }
}

-(void)setProgressWidth:(CGFloat)progressWidth{
    _progressWidth = progressWidth;
    [self setNeedsDisplay];
}

-(void)setProgressViewBgColor:(UIColor *)progressViewBgColor{
    _progressViewBgColor = progressViewBgColor;
}
-(void)setProgressBarColor:(UIColor *)progressBarColor{
    _progressBarColor = progressBarColor;
}

-(void)setProgressViewStyle:(ProgressViewStyle)ProgressViewStyle {
    _ProgressViewStyle = ProgressViewStyle;
    switch (_ProgressViewStyle) {
            /** 百分百和文字 默认 */
        case ProgressBOX_percentAndText:
        {
            [self percentTextLabel];
            self.stringLabel.hidden = NO;
        }
            break;
            
            /** 百分百和圆环 */
        case ProgressBOX_percentAndRing:
        {
            [self percentTextLabel];
        }
            break;
            
            /** 圆环 */
        case ProgressBOX_Ring:
        {
            
        }
            break;
            
            /** 扇形 */
        case ProgressBOX_Sector:
        {
            self.backgroundColor = UIColor.blueColor;
        }
            break;
            
            /** 长方形 */
        case ProgressBOX_Rectangle:
        {
            self.backgroundColor = UIColor.redColor;
            
            /********************************* 长条形样式 ********************************/
            //底部边框
            UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
            borderView.layer.cornerRadius = self.bounds.size.height * 0.5;
            borderView.layer.masksToBounds = YES;
            borderView.backgroundColor = _progressViewBgColor;
            borderView.layer.borderColor = [UIColor.whiteColor CGColor];
            borderView.layer.borderWidth = 2;
            
            [self addSubview:borderView];
            //进度
            UIView *rectangleView = [[UIView alloc] init];
            rectangleView.backgroundColor = _progressBarColor;
            rectangleView.layer.cornerRadius = (self.bounds.size.height - (2 + 1) * 2) * 0.5;
            rectangleView.layer.masksToBounds = YES;
            [self addSubview:rectangleView];
            
            self.rectangleView = rectangleView;
            
            /********************************* 长条形样式 ********************************/
        }
            break;
            
            /** 球 */
        case ProgressBOX_ball:
        {
          [self percentTextLabel];
        }
            break;
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    switch (self.ProgressViewStyle) {
        case ProgressBOX_percentAndText:
        {
            [self progressbox_percentAndText:rect];
        }
            break;
            
        case ProgressBOX_percentAndRing:
        {
            [self progressbox_percentAndRing:rect];
            
        }
            break;
            
        case ProgressBOX_Ring:
        {
             [self progressbox_Ring:rect];
        }
            break;
            
        case ProgressBOX_Sector:
        {
             [self progressbox_Sector:rect];
        }
            break;
            
        case ProgressBOX_Rectangle:
        {
            
        }
            break;
            
        case ProgressBOX_ball:
        {
            [self progressbox_ball:rect];
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - 百分百和文字 (默认)
-(void)progressbox_percentAndText:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.25 + 15;
    [_progressBarColor set];
    //设置圆环的宽度
    CGContextSetLineWidth(ctx, _progressWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
    //半径
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.3 - 15;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
    CGFloat FrameWidth = self.bounds.size.width;
    self.percentTextLabel.frame = CGRectMake(0, yCenter-10, FrameWidth, 20);
}

#pragma mark - 百分百和圆环
-(void)progressbox_percentAndRing:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    [_progressBarColor set];
    
    //设置圆环的宽度
    CGContextSetLineWidth(ctx, _progressWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
    //半径
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.4 - 15;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);

    CGFloat FrameWidth = self.bounds.size.width;
    self.percentTextLabel.frame = CGRectMake(0, yCenter-10, FrameWidth, 20);
    
}


#pragma mark - 圆环
-(void)progressbox_Ring:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    [_progressBarColor set];
    
    //设置圆环的宽度
    CGContextSetLineWidth(ctx, _progressWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
    //半径
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.4 - 15;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
  
}


#pragma mark - 扇形
-(void)progressbox_Sector:(CGRect)rect{
    

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - 15;
    //背景遮罩
    [_progressViewBgColor set];
    
    CGFloat lineW = MAX(rect.size.width, rect.size.height) * 0.5;
    CGContextSetLineWidth(context, lineW);
    CGContextAddArc(context, xCenter, yCenter, radius + lineW * 0.5 + 5, 0, M_PI * 2, 1);
    CGContextStrokePath(context);

    //进程圆(圆环)
//    [_progressViewBgColor set];
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, xCenter, yCenter);
    CGContextAddLineToPoint(context, xCenter, 0);
    CGFloat endAngle = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001;
    CGContextAddArc(context, xCenter, yCenter, radius, - M_PI * 0.5, endAngle, 1);
    CGContextFillPath(context);
    
    
}

#pragma mark - 球形
-(void)progressbox_ball:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    [_progressBarColor set];
    
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - 15;
    
    //画椭圆
    CGFloat w = radius * 2;
//    CGFloat w = radius * 2 + 10;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    [[UIColor grayColor] set];
    CGFloat startAngle = M_PI * 0.5 - self.progress * M_PI;
    CGFloat endAngle = M_PI * 0.5 + self.progress * M_PI;
    CGContextAddArc(ctx, xCenter, yCenter, radius, startAngle, endAngle, 0);
    CGContextFillPath(ctx);
    
    CGFloat FrameWidth = self.bounds.size.width;
    self.percentTextLabel.frame = CGRectMake(0, yCenter-10, FrameWidth, 20);

}


@end
