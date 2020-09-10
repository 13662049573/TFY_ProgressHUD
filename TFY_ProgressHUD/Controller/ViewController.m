//
//  ViewController.m
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2019/5/22.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "ViewController.h"
#import "TFY_ProgressHMB.h"
#import "RootController.h"

#define LM_QueueStartAfterTime(time) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){

#define LM_queueEnd  });

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,PopupMenuDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy)NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左边显示" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemClick:)];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"进入界面" style:UIBarButtonItemStyleDone target:self action:@selector(rootViewClick)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"右边显示" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 200, 300, 40);
    [btn setTitle:@"展开" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(dismissClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.contentView.backgroundColor = [UIColor cyanColor];
    
    self.array = @[@"菊花提示",@"菊花提示交互",@"请求成功",@"成功时间自定义",@"失败",@"失败加时间",@"提示",@"提示加时间",@"纯文本显示",@"淡入淡出",@"收缩",@"底部弹出",@"顶部弹出",@"中心弹出",@"背景渐变",@"自定义视图"];
    
    [self.view addSubview:self.tableView];

}

- (void)rootViewClick {
    [self.navigationController pushViewController:[RootController new] animated:YES];
}

- (void)leftBarButtonItemClick:(UIBarButtonItem *)item {
   [TFY_PopupMenu showAtPoint:CGPointMake(44, 88) titles:@[@"测试1",@"测试2",@"测试3",@"测试4"] icons:@[@"sep_auther",@"liwu",@"myvotebiao",@"sep_beijing"] menuWidth:140 delegate:self];

}

- (void)rightBarButtonItemClick:(UIBarButtonItem *)item {
    [TFY_PopupMenu showAtPoint:CGPointMake([UIScreen mainScreen].bounds.size.width-44, 88) titles:@[@"测试1",@"测试2",@"测试3",@"测试4"] icons:@[@"sep_auther",@"liwu",@"myvotebiao",@"sep_beijing"] menuWidth:140 otherSettings:^(TFY_PopupMenu * _Nonnull popupMenu) {
        popupMenu.type =  PopupMenuTypeDark;
        popupMenu.delegate = self;
    }];
}

- (void)tfy_PopupMenu:(TFY_PopupMenu *)PopupMenu didSelectedAtIndex:(NSInteger)index {
    [TFY_ProgressHUD dismissSuperPopupIn:self.contentView animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self btnClick:indexPath];
}

-(void)btnClick:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [TFY_ProgressHUD showWithStatus:@"提示按时发动机号开发八十块的部分科室的本开放式包开发不舍得恐怖富士康"];
        
    }
    else if (indexPath.row==1){
        [TFY_ProgressHUD showWithStatus:@"限制交互提示框" maskType:TFY_PopupMaskType_Dimmed];
        LM_QueueStartAfterTime(4)
        [TFY_ProgressHUD dismiss];
        LM_queueEnd
    }
    else if (indexPath.row==2){
        [TFY_ProgressHUD showSuccessWithStatus:@"爱上大开杀戒档卡户"];
    }
    else if (indexPath.row==3){
        [TFY_ProgressHUD showSuccessWithStatus:@"按加号发了疯哈佛" duration:3];
    }
    else if (indexPath.row==4){
        [TFY_ProgressHUD showErrorWithStatus:@"尽快发货伐啦回复啦回复了"];
    }
    else if (indexPath.row==5){
        [TFY_ProgressHUD showErrorWithStatus:@"lxiuasnla" duration:4];
        
    }
    else if (indexPath.row==6){
        [TFY_ProgressHUD showPromptWithStatus:@"发举案说法开发"];
    }
    else if (indexPath.row==7){
        [TFY_ProgressHUD showPromptWithStatus:@"就会发回复拉回来发了疯" duration:1];
    }
    else if (indexPath.row==8){
        [TFY_ProgressHUD showTextWithStatus:@"按时缴费卡就恢复开机按喝咖啡就爱看昂首阔步饭卡比方说八分部包括和不堪罚款把空间分布卡部分看卡包饭卡吧卡级别发空间吧科技部发空间不付款吧饭卡吧饭卡吧饭卡"];
    }
    else if (indexPath.row==9){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_FadeIn dismissType:TFY_PopupDismissType_FadeOut maskType:TFY_PopupMaskType_Clear];
        [popView show];
        
    }
    else if (indexPath.row==10){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_ShrinkIn dismissType:TFY_PopupDismissType_ShrinkOut maskType:TFY_PopupMaskType_Clear];
        [popView showWithDuration:2];
    }
    else if (indexPath.row==11){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_SlideInFromBottom dismissType:TFY_PopupDismissType_SlideOutToBottom maskType:TFY_PopupMaskType_Dimmed];
        [popView showWithDuration:2];
    }
    else if (indexPath.row==12){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_SlideInFromTop dismissType:TFY_PopupDismissType_SlideOutToTop maskType:TFY_PopupMaskType_None];
        [popView showWithDuration:2];
    }
    else if (indexPath.row==13){
        TFY_ProgressHUD *popView = [TFY_ProgressHUD popupWithContentView:self.contentView showType:TFY_PopupShowType_BounceIn dismissType:TFY_PopupDismissType_BounceOut maskType:TFY_PopupMaskType_None];
        [popView showWithDuration:2];
    }
    else if (indexPath.row==14){
        TFY_ProgressHUD *popview = [[TFY_ProgressHUD alloc]initWithFrame:UIScreen.mainScreen.bounds];
        popview.contentView = self.contentView;
        popview.showType = TFY_PopupShowType_GrowIn;
        popview.dismissType = TFY_PopupDismissType_GrowOut;
        popview.showInDuration = 2;
        [popview show];
    } else if(indexPath.row==15) {
        UIView *bbbb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        bbbb.backgroundColor = UIColor.redColor;
        TFY_ProgressHUD *popview = [TFY_ProgressHUD popupWithContentView:bbbb];
        popview.showType = TFY_PopupShowType_GrowIn;
        popview.dismissType = TFY_PopupDismissType_GrowOut;
        [popview showWithDuration:2];
    }
    
}

-(void)dismissClick:(UIButton *)btn{
    [TFY_PopupMenu showRelyOnView:btn titles:@[@"测试1",@"测试2",@"测试3",@"测试4"] icons:@[@"sep_auther",@"liwu",@"myvotebiao",@"sep_beijing"] menuWidth:140 otherSettings:^(TFY_PopupMenu * _Nonnull popupMenu) {
        popupMenu.delegate = self;
    }];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
@end
