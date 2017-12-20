//
//  SFShopFoodListVC.m
//  selfish
//
//  Created by He on 2017/12/20.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopFoodListVC.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const reuseID = @"reuseID";

@interface SFShopFoodListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation SFShopFoodListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self setUpDataBinding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadFoodsData];
    });
}

#pragma mark - Private

- (void)setUpDataBinding {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
}

- (void)loadFoodsData {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/shop/allfoods", SELFISH_HOST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"添加菜品出错: %@", error);
            return;
        }
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if(jsonError) {
            NSLog(@"结果解析错误:%@", jsonError);
            return;
        }
        
        if([result[@"success"] isEqualToString:@"true"]) {
            NSLog(@"商品创建或修改成功%@", result);
            dispatch_semaphore_signal(semaphore);
        }
    }];
    [SVProgressHUD showWithStatus:@"加载数据"];
    [dataTask resume];
    if(dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*15)) == 0) {
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [SVProgressHUD dismissWithDelay:0.25];
    }else {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [SVProgressHUD dismissWithDelay:0.25];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *url = @"Selfish://push/SFShopCustomeFoodVC";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}
#pragma mark - UITableViewDataSource
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count+10;
}

    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.textLabel.text = @"菜肴";
    return cell;
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}


@end
