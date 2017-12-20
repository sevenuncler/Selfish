//
//  SFShopCustomeFoodVC.m
//  selfish
//
//  Created by He on 2017/12/2.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopCustomeFoodVC.h"
#import "SFShopFoodPicView.h"
#import "SFShopFoodCustomeViewModel.h"
#import "SFShopCustomeFoodRowView.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface SFShopCustomeFoodVC ()
@property(nonatomic,strong) SFShopFoodPicView           *foodPicView;
@property(nonatomic,strong) SFShopFoodCustomeViewModel  *foodPicViewModel;
@property(nonatomic,strong) UIButton                    *submitButton;
@property(nonatomic,strong) UITextField                 *titleTF;
@property(nonatomic,strong) UITextField                 *descTF;
@end


static NSString * const reuseTableViewCell = @"SUTableViewCell";
@implementation SFShopCustomeFoodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SUTableViewCell class] forCellReuseIdentifier:reuseTableViewCell];
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView addSubview:self.submitButton];
    [self setUpDataBinding];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpDataBinding {
    self.foodPicViewModel = [SFShopFoodCustomeViewModel new];
    self.foodPicView.picsCollectionView.dataSource  = self.foodPicViewModel;
    self.foodPicView.picsCollectionView.delegate    = self.foodPicViewModel;
}

#pragma mark - Table view Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(0 == indexPath.section) {
        if(0 == indexPath.row) {
            return 44;
        }else if(1 == indexPath.row) {
            return 100;
        }else if(2 == indexPath.row) {
            return 250;
        }
    }else if(1 == indexPath.section) {
        
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(0 == section) {
        return 15;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 3;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseTableViewCell forIndexPath:indexPath];
    
    // Configure the cell...
    if(0 == indexPath.section) { // 标题
        if(0 == indexPath.row) {
            UITextField *titleTF = [[UITextField alloc] initWithFrame:cell.bounds];
            cell.myContentView = titleTF;
            titleTF.placeholder = @"  标题";
            self.titleTF = titleTF;
        }
        if(1 == indexPath.row) { // 描述
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88)];
            textField.placeholder = @"  简单描述食物";
            self.descTF = textField;
            cell.myContentView = textField;
        }else if(2 == indexPath.row) {
            cell.myContentView = self.foodPicView;
        }
    }else if(1 == indexPath.section) {
        if(0 == indexPath.row) {
            SFShopCustomeFoodRowView *foodRowView = [[SFShopCustomeFoodRowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            cell.myContentView = foodRowView;
        }else if(1 == indexPath.row) {
            SFShopCustomeFoodRowView *foodRowView = [[SFShopCustomeFoodRowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            cell.myContentView = foodRowView;
        }
    }
    
    return cell;
}
    
#pragma mark - Action

- (void)handleSubmitAction:(id)sender {
    NSDictionary *form = [self generateForm];
    if(form) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *url = [NSString stringWithFormat:@"%@/food", SELFISH_HOST];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
        request.HTTPMethod = @"POST";
        request.HTTPBody   = [NSJSONSerialization dataWithJSONObject:form options:NSJSONWritingPrettyPrinted error:nil];
        
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
                NSLog(@"商品创建或修改成功:%@", result);
            }else {
                NSLog(@"请求失败:%@", result);
            }
        }];
        [dataTask resume];
    }
}

- (NSDictionary *)generateForm {
    id sid = [[NSUserDefaults standardUserDefaults] valueForKey:@"sid"];
    NSDictionary *json = @{
                           @"shop_sid" : sid,
                           @"name"     : self.titleTF.text,
                           @"tags"     : self.descTF.text,
//                           @"pics"     : self.foodPicViewModel.pics
                           };
    return json;
}

- (SFShopFoodPicView *)foodPicView {
    if(!_foodPicView) {
        _foodPicView = [[SFShopFoodPicView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    }
    return _foodPicView;
}

- (UIButton *)submitButton {
    if(!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"创建" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _submitButton.size = CGSizeMake(self.view.size.width, 44);
        _submitButton.left = 0;
        _submitButton.botton = self.view.size.height- 100;
        [_submitButton addTarget:self action:@selector(handleSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
