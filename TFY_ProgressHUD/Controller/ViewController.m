//
//  ViewController.m
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2019/5/22.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "ViewController.h"
#import "TFY_ProgressHUD.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    self.contentView.backgroundColor = [UIColor cyanColor];
    
    self.view.backgroundColor = [UIColor cyanColor];
    NSArray *arr = @[@"文字提示",@"文字加枚举类型",@"枚举类型",@"展示成功的状态",@"成功加时间设计",@"失败提示",@"失败加时间",@"提示",@"提示加时间",@"淡入淡出",@"收缩",@"底部弹出",@"顶部弹出",@"中心弹出"];
    for (NSInteger i = 0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 40+i*60, [UIScreen mainScreen].bounds.size.width, 50);
        btn.backgroundColor = [UIColor orangeColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

-(void)btnClick:(UIButton *)btn{
    if (btn.tag==0) {
        [TFY_ProgressHUD showWithStatus:@"提示！"];
        [self performSelector:@selector(hpv) withObject:nil afterDelay:1.5];
    }
    else if (btn.tag==1){
        [TFY_ProgressHUD showWithStatus:@"提示" maskType:PopupMaskType_Gradient];
        [TFY_ProgressHUD dismissWithError:@"阿噶几发件方；阿发" afterDelay:1.3];
    }
    else if (btn.tag==2){
        [TFY_ProgressHUD showWithMaskType:PopupMaskType_None];
        [TFY_ProgressHUD dismissWithSuccess:@"关闭" afterDelay:1.5];
    }
    else if (btn.tag==3){
        [TFY_ProgressHUD showSuccessWithStatus:@"陈哥哥哥"];
    }
    else if (btn.tag==4){
        [TFY_ProgressHUD showSuccessWithStatus:@"按加号发了疯哈佛" duration:1.5];
    }
    else if (btn.tag==5){
        [TFY_ProgressHUD showErrorWithStatus:@"尽快发货伐啦回复啦回复了"];
    }
    else if (btn.tag==6){
        [TFY_ProgressHUD showErrorWithStatus:@"lxiuasnla" duration:2];
    }
    else if (btn.tag==7){
        [TFY_ProgressHUD showPromptWithStatus:@"发举案说法开发"];
    }
    else if (btn.tag==8){
        [TFY_ProgressHUD showPromptWithStatus:@"就会发回复拉回来发了疯" duration:1];
    }
    else if (btn.tag==9){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:PopupShowType_FadeIn dismissType:PopupDismissType_FadeOut maskType:PopupMaskType_Clear dismissOnBackgroundTouch:NO dismissOnContentTouch:YES];
        [popView show];
        
    }
    else if (btn.tag==10){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:PopupShowType_ShrinkIn dismissType:PopupDismissType_ShrinkOut maskType:PopupMaskType_None dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
        [popView showWithDuration:2];
    }
    else if (btn.tag==11){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:PopupShowType_SlideInFromBottom dismissType:PopupDismissType_SlideOutToBottom maskType:PopupMaskType_None dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
        [popView showWithDuration:2];
    }
    else if (btn.tag==12){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:PopupShowType_SlideInFromTop dismissType:PopupDismissType_SlideOutToTop maskType:PopupMaskType_None dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
        [popView showWithDuration:2];
    }
    else if (btn.tag==13){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:PopupShowType_BounceIn dismissType:PopupDismissType_BounceOut maskType:PopupMaskType_None dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
           [popView showWithDuration:2];
    }
    
}

-(void)hpv{
    [TFY_ProgressHUD dismissWithError:@"按时发啦发啦"];
}
@end
