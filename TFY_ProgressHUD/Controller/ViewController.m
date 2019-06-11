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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    NSArray *arr = @[@"文字提示",@"文字加枚举类型",@"枚举类型",@"展示成功的状态",@"成功加时间设计",@"失败提示",@"失败加时间",@"提示",@"提示加时间"];
    for (NSInteger i = 0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 64+i*60, [UIScreen mainScreen].bounds.size.width, 50);
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
        [TFY_ProgressHUD showWithStatus:@"提示" maskType:ProgressHUDMaskTypeGradient];
        [TFY_ProgressHUD dismissWithError:@"阿噶几发件方；阿发" afterDelay:1.3];
    }
    else if (btn.tag==2){
        [TFY_ProgressHUD showWithMaskType:ProgressHUDMaskTypeNone];
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
    
    
    
}

-(void)hpv{
    [TFY_ProgressHUD dismissWithError:@"按时发啦发啦"];
}
@end
