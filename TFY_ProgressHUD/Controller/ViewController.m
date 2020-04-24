//
//  ViewController.m
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2019/5/22.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "ViewController.h"
#import "TFY_PromptpopupHeader.h"

#define LM_QueueStartAfterTime(time) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){

#define LM_queueEnd  });

@interface ViewController ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 200, 300, 40);
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.contentView.backgroundColor = [UIColor cyanColor];
    
    self.view.backgroundColor = [UIColor cyanColor];
    NSArray *arr = @[@"菊花提示",@"菊花提示交互",@"请求成功",@"成功时间自定义",@"失败",@"失败加时间",@"提示",@"提示加时间",@"淡入淡出",@"收缩",@"底部弹出",@"顶部弹出",@"中心弹出",@"背景渐变"];
    for (NSInteger i = 0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 60+i*60, [UIScreen mainScreen].bounds.size.width, 50);
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
        [TFY_ProgressHUD showWithStatus:@"提示按时发动机号开发八十块的部分科室的本开放式包开发不舍得恐怖富士康"];
        
    }
    else if (btn.tag==1){
        [TFY_ProgressHUD showWithStatus:@"限制交互提示框" maskType:TFY_PopupMaskType_Dimmed];
        LM_QueueStartAfterTime(4)
        [TFY_ProgressHUD dismiss];
        LM_queueEnd
    }
    else if (btn.tag==2){
        [TFY_ProgressHUD showSuccessWithStatus:@"爱上大开杀戒档卡户"];
    }
    else if (btn.tag==3){
        [TFY_ProgressHUD showSuccessWithStatus:@"按加号发了疯哈佛" duration:3];
    }
    else if (btn.tag==4){
        [TFY_ProgressHUD showErrorWithStatus:@"尽快发货伐啦回复啦回复了"];
    }
    else if (btn.tag==5){
        [TFY_ProgressHUD showErrorWithStatus:@"lxiuasnla" duration:4];
        
    }
    else if (btn.tag==6){
        [TFY_ProgressHUD showPromptWithStatus:@"发举案说法开发"];
    }
    else if (btn.tag==7){
        [TFY_ProgressHUD showPromptWithStatus:@"就会发回复拉回来发了疯" duration:1];
    }
    else if (btn.tag==8){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_FadeIn dismissType:TFY_PopupDismissType_FadeOut maskType:TFY_PopupMaskType_Clear];
        [popView show];
        
    }
    else if (btn.tag==9){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_ShrinkIn dismissType:TFY_PopupDismissType_ShrinkOut maskType:TFY_PopupMaskType_Clear];
        [popView showWithDuration:2];
    }
    else if (btn.tag==10){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_SlideInFromBottom dismissType:TFY_PopupDismissType_SlideOutToBottom maskType:TFY_PopupMaskType_Dimmed];
        [popView showWithDuration:2];
    }
    else if (btn.tag==11){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_SlideInFromTop dismissType:TFY_PopupDismissType_SlideOutToTop maskType:TFY_PopupMaskType_None];
        [popView showWithDuration:2];
    }
    else if (btn.tag==12){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_BounceIn dismissType:TFY_PopupDismissType_BounceOut maskType:TFY_PopupMaskType_None];
        [popView showWithDuration:2];
    }
    else if (btn.tag==13){
        TFY_ProgressHUD *popview = [[TFY_ProgressHUD alloc]initWithFrame:UIScreen.mainScreen.bounds];
        popview.contentView = self.contentView;
        popview.showType = TFY_PopupShowType_GrowIn;
        popview.dismissType = TFY_PopupDismissType_GrowOut;
        popview.showInDuration = 2;
        [popview show];
    }
    
}

-(void)dismissClick{
    [TFY_ProgressHUD dismissSuperPopupIn:self.contentView animated:YES];
}
@end
