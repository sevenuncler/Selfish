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
#import "SFFoodItem.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>


#define boundary  @"comsevenunclerselfishxxx"

@interface SFShopCustomeFoodVC ()
@property(nonatomic,strong) SFShopFoodPicView           *foodPicView;
@property(nonatomic,strong) SFShopFoodCustomeViewModel  *foodPicViewModel;
@property(nonatomic,strong) UIButton                    *submitButton;
@property(nonatomic,strong) UITextField                 *titleTF;
@property(nonatomic,strong) UITextField                 *descTF;
@property(nonatomic,strong) dispatch_group_t            group;
@property(nonatomic,strong) dispatch_queue_t            queue;
@property(atomic,strong)    NSMutableArray              *formPics;
@property(nonatomic,strong) SFFoodItem                  *foodItem;
@end


static NSString * const reuseTableViewCell = @"SUTableViewCell";
@implementation SFShopCustomeFoodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SUTableViewCell class] forCellReuseIdentifier:reuseTableViewCell];
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView addSubview:self.submitButton];
    [self setUpDataBinding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadFood];
    });
}

- (void)loadFood {
    if(self.fid) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *url = [NSString stringWithFormat:@"%@/food/query?fid=%@", SELFISH_HOST, self.fid];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
        request.HTTPMethod = @"GET";
        
        __weak typeof(self) weakSelf = self;
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error) {
                NSLog(@"请求出错: %@", error);
                return;
            }
            NSError *jsonError;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if(jsonError) {
                NSLog(@"结果解析错误:%@", jsonError);
                return;
            }
            
            if([result[@"success"] isEqualToString:@"true"]) {
                NSLog(@"获取成功%@", result);
                NSArray *content = result[@"content"];
                if(content.count>0) {
                    SFFoodItem *foodItem = [SFFoodItem mj_objectWithKeyValues:content[0]];
                    weakSelf.foodItem = foodItem;
                    dispatch_semaphore_signal(semaphore);
                }
            }
        }];
        [SVProgressHUD showWithStatus:@"加载数据中..."];
        [dataTask resume];
        if(dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5)) == 0) {
            [SVProgressHUD showSuccessWithStatus:@"加载成功"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //填充表单
                [self.foodPicViewModel addImages:self.foodItem.pics.mutableCopy];
                self.titleTF.text = self.foodItem.name;
                self.descTF.text  = self.foodItem.desc;
                [self.tableView reloadData];
                [self.foodPicView.picsCollectionView reloadData];
            });
        }else {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            
            [self dismissViewControllerAnimated:YES completion:nil];

        }
        [SVProgressHUD dismissWithDelay:0.25];
    }
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
            
            cell.myContentView = self.titleTF;
            
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
    if(self.formPics == nil) {
        self.formPics = [NSMutableArray array];
    }else {
        [self.formPics removeAllObjects];
    }
    NSDictionary *form = [self generateForm];
    // 1. 获取需要上传的图片上传
    // 2. 根据上传的图片地址重新赋值表单中URL
    // 3. 表单提交
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
                NSLog(@"商品创建或修改成功%@", result);
            }
        }];
        [dataTask resume];
    }else {
        [SVProgressHUD showErrorWithStatus:@"创建失败，请检查网络"];
        [SVProgressHUD dismissWithDelay:0.5];
    }
}

- (NSDictionary *)generateForm {
//    NSMutableArray *imageDatas = @[].mutableCopy;
    __weak typeof(self) weakSelf = self;
    

 

    [self.foodPicViewModel.pics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImage class]]) {
            UIImage *image = obj;
            NSData *data = UIImagePNGRepresentation(image);
//            [imageDatas addObject:data];
//            *stop = YES;
            [weakSelf uploadImage:data];
        }else if([obj isKindOfClass:[NSString class]]) {
            
            [weakSelf.formPics addObject:obj];
        }
        if(idx == self.foodPicViewModel.pics.count - 2) {
            *stop = YES;
        }
    }];
    
    if( dispatch_group_wait(self.group, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5)) == 0 ) {
        id sid = [[NSUserDefaults standardUserDefaults] valueForKey:@"sid"];
        NSDictionary *json = @{
                               @"shop_sid" : sid,
                               @"name"     : self.titleTF.text,
                               @"tags"     : self.descTF.text,
                               @"pics"     : self.formPics
                               };
        return json;
    }else {
        [SVProgressHUD showErrorWithStatus:@"上传超时了"];
        [SVProgressHUD dismissWithDelay:0.5];
    }
    
    return nil;
}

- (void)uploadImage:(NSData *)data {
//    NSData *bodyData = [self generateBody:data];
    __weak typeof(self) weakSelf = self;
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *url = [NSString stringWithFormat:@"%@/food/upload", SELFISH_HOST];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [request addValue:[NSString stringWithFormat:@"multipart/from-data;boundary=%@", boundary] forHTTPHeaderField:@"content-type"];
    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"POST";
//        NSDictionary *form = @{
//                               @"image":data
//                               };
//        request.HTTPBody   = bodyData;

        dispatch_group_enter(self.group);

        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error) {
                NSLog(@"请求出错: %@", error);
                return;
            }
            NSError *jsonError;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if(jsonError) {
                NSLog(@"结果解析错误:%@", jsonError);
                return;
            }
            
            if([result[@"success"] isEqualToString:@"true"]) {
                NSDictionary *content = result[@"content"];
                NSString *url = content[@"url"];
                if(url) {
                    [weakSelf.formPics addObject:url];
                }
                NSLog(@"商品创建或修改成功%@", result);
                [SVProgressHUD showSuccessWithStatus:@"上传成功了"];
                [SVProgressHUD dismissWithDelay:0.25];
                dispatch_group_leave(self.group);
            }

        }];
        [uploadTask resume];

}

- (NSData *)generateBody:(NSData *)imageData {
    //创建可变字符串
    NSMutableString *bodyStr = [NSMutableString string];

    
    //2 stutas
    [bodyStr appendFormat:@"--%@\r\n",boundary];//\n:换行 \n:切换到行首
    [bodyStr appendFormat:@"Content-Disposition: form-data; name=\"name\""];
    [bodyStr appendFormat:@"\r\n\r\n"];
    [bodyStr appendFormat:@"%@\r\n",@"xxx"];
    
    //3 pic
    /*
     --AaB03x
     Content-disposition: form-data; name="pic"; filename="file"
     Content-Type: application/octet-stream
     */
    [bodyStr appendFormat:@"--%@\r\n",boundary];
    [bodyStr appendFormat:@"Content-disposition: form-data; name=\"image\"; filename=\"filename\""];
    [bodyStr appendFormat:@"\r\n"];
    [bodyStr appendFormat:@"Content-Type: Multipart/form-data"];
    [bodyStr appendFormat:@"\r\n\r\n"];
    
    
    NSMutableData *bodyData = [NSMutableData data];
    
    //(1)startData
    NSData *startData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:startData];
    
    //(2)pic

    [bodyData appendData:imageData];
    
    //(3)--Str--
    NSString *endStr = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
    NSData *endData = [endStr dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:endData];
    
    
    return bodyData;

}

#pragma mark - Getter & Setter

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

- (dispatch_queue_t)queue {
    if(!_queue) {
        _queue = dispatch_queue_create("com.sevenuncle.upload", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}

- (dispatch_group_t)group {
    if(!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}

- (UITextField *)titleTF {
    if(!_titleTF) {
        UITextField *titleTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        titleTF.placeholder = @"  标题";
        self.titleTF = titleTF;
    }
    return _titleTF;
}



@end
