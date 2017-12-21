//
//  SFShopFoodListVC.m
//  selfish
//
//  Created by He on 2017/12/21.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopFoodListVC.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SFShopFoodListVC ()

@end
static NSString * const reuseID = @"reuseID";
@implementation SFShopFoodListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDataBinding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];
    });
}

- (void)setDataBinding {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID];
    
}

- (void)loadData {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/shop/foods", SELFISH_HOST];
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
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    [dataTask resume];
    if(dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2)) == 0) {
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [self.items addObject:@""];
        [self.items addObject:@""];

        [self.items addObject:@""];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }else {
        [SVProgressHUD showSuccessWithStatus:@"加载失败"];
        [self.items addObject:@""];
        [self.items addObject:@""];
        
        [self.items addObject:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    [SVProgressHUD dismissWithDelay:0.25];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = @"一人食";
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *url = @"Selfish://push/SFShopCustomeFoodVC";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
