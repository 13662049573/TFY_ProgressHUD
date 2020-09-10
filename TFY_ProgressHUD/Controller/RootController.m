//
//  RootController.m
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2020/9/9.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "RootController.h"
#import "TFY_ProgressBOX.h"

/***线程****/
#define TFY_queueGlobalStart dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
// 当所有队列执行完成之后
#define TFY_group_notify dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

#define TFY_queueMainStart dispatch_async(dispatch_get_main_queue(), ^{

#define TFY_QueueStartAfterTime(time) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){

#define TFY_queueEnd  });

@interface RootController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic, copy)NSArray *array;
@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blueColor;
    
    self.array = @[@"加载中...",@"加载成功",@"加载失败",@"提示",@"成功时间自定义",@"失败时间自定义",@"提示自定义",@"加载中自定义时间",@"显示文本多",@"纯文不显示"];
   
   [self.view addSubview:self.tableView];
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
    NSString *string = self.array[indexPath.row];
    if (indexPath.row == 0) {
        [TFY_ProgressBOX showWithStatus:string];
        TFY_QueueStartAfterTime(4)
        [TFY_ProgressBOX dismiss];
        TFY_queueEnd
    } else if (indexPath.row == 1) {
        [TFY_ProgressBOX showSuccessWithStatus:string];
    } else if (indexPath.row == 2) {
        [TFY_ProgressBOX showErrorWithStatus:string];
    } else if (indexPath.row == 3) {
        [TFY_ProgressBOX showPromptWithStatus:string];
    } else if (indexPath.row == 4) {
        [TFY_ProgressBOX showSuccessWithStatus:string duration:5];
    } else if (indexPath.row == 5) {
        [TFY_ProgressBOX showErrorWithStatus:string duration:4];
    } else if (indexPath.row == 6) {
        [TFY_ProgressBOX showPromptWithStatus:string duration:6];
    } else if (indexPath.row == 7) {
        [TFY_ProgressBOX showWithStatus:string duration:1];
    } else if (indexPath.row == 8) {
        [TFY_ProgressBOX showWithStatus:@"按时发哪里芬兰芬兰芬兰拉发哪里是你法拉盛纽芬兰范聪聪我饿哦发哪里能否IE李女士你疯了你疯了你放哪发哪里发哪款窝囊废蓝风铃爱上你的来看德里克哪款辽宁大连" duration:1];
    } else if (indexPath.row == 9) {
        [TFY_ProgressBOX showTextWithStatus:@"爱上克利夫兰法拉利发那份饭卡不开放把控部分卡布卡杯咖啡吧"];
    } else if (indexPath.row == 10) {
        
    }
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
