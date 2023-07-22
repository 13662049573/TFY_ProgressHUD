//
//  ViewController.m
//  TFY_ProgressHUD
//
//  Created by 田风有 on 2019/5/22.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "ViewController.h"
#import "TFY_ProgressHMB.h"

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

    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"右边显示" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
    self.navigationItem.rightBarButtonItem = item2;
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 200, 300, 40);
    [btn setTitle:@"展开" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(dismissClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.contentView.backgroundColor = [UIColor cyanColor];
    
    self.array = @[@"菊花提示",@"菊花提示交互",@"请求成功",@"成功时间自定义",@"失败",@"失败加时间",@"提示",@"提示加时间",@"进度条"];
    
    [self.view addSubview:self.tableView];

}

- (void)leftBarButtonItemClick:(UIBarButtonItem *)item {
   [TFY_PopupMenu showAtPoint:CGPointMake(44, 64) titles:@[@"测试1",@"测试2",@"测试3",@"测试4"] icons:@[@"sep_auther",@"liwu",@"myvotebiao",@"sep_beijing"] menuWidth:140 delegate:self];

}

- (void)rightBarButtonItemClick:(UIBarButtonItem *)item {
    [TFY_PopupMenu showAtPoint:CGPointMake([UIScreen mainScreen].bounds.size.width-44, 64) titles:@[@"测试1",@"测试2",@"测试3",@"测试4"] icons:@[@"sep_auther",@"liwu",@"myvotebiao",@"sep_beijing"] menuWidth:140 otherSettings:^(TFY_PopupMenu * _Nonnull popupMenu) {
        popupMenu.type =  PopupMenuTypeDark;
        popupMenu.delegate = self;
    }];
}

- (void)tfy_PopupMenu:(TFY_PopupMenu *)PopupMenu didSelectedAtIndex:(NSInteger)index {
    
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
    switch (indexPath.row) {
        case 0:
            [TFYAlert showIndeterminate];
            LM_QueueStartAfterTime(4)
            [TFYAlert hide];
            LM_queueEnd
            break;
        case 1:
            [TFYAlert showIndeterminateWithStatus:@"埃里克法律可能否拉拉发货了看法和浪费哈来划分"];
            LM_QueueStartAfterTime(4)
            [TFYAlert hide];
            LM_queueEnd
            break;
        case 2:
            [TFYAlert showSuccessWithStatus:@"安居客联发科本菲卡"];
            break;
        case 3:
            [TFYAlert showErrorWithStatus:@"阿里客服哪里看能否"];
            break;
        case 4:
            [TFYAlert showInfoWithStatus:@"阿里客服哪里看能否"];
            break;
        case 5:
            [TFYAlert showStatus:@"阿里客服哪里看能否"];
            break;
        case 6:
            [TFYAlert showRedStatus:@"阿里客服哪里看能否"];
            break;
        case 7:
            [TFYAlert showBarDeterminateWithProgress:0.8];
            LM_QueueStartAfterTime(4)
            [TFYAlert hide];
            LM_queueEnd
            break;
        case 8:
        {
            __block CGFloat progress = 0.1;
           [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                progress+=0.1;
                [TFYAlert showBarDeterminateWithProgress:progress status:[NSString stringWithFormat:@"完成%.0f",progress*100]];
                if (progress >= 1) {
                    [TFYAlert hide];
                    [timer invalidate];
                }
            }];
        }
            break;
        default:
            break;
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
