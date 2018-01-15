//
//  SFShopDetailVC.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopDetailVC.h"
#import "UIView+Layout.h"
#import "SUTableViewItem.h"
#import "SFShopDetailCoverItem.h"
#import "SFShopDetailTagCell.h"
#import "SFShopDetailMenuCell.h"
#import "SFShopDetailTitleCell.h"
#import "SFShopDetailCoverCell.h"
#import "SFCommentCell.h"
#import "StatusCell.h"
#import "SFCommentListVC.h"
#import "SUImageManager.h"
#import "SFFoodItem.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import "SFCommentItem.h"
#import "SUImageBrowserVC.h"

@interface SFShopDetailVC ()

@end

@implementation SFShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SFShopDetailCoverCell class] forCellReuseIdentifier:@"SFShopDetailCoverCell"];
    [self.tableView registerClass:[SFShopDetailTitleCell class] forCellReuseIdentifier:@"SFShopDetailTitleCell"];
    [self.tableView registerClass:[SFShopDetailMenuCell class] forCellReuseIdentifier:@"SFShopDetailMenuCell"];
    [self.tableView registerClass:[SongViewCell class] forCellReuseIdentifier:@"SongViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"店铺名称";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
    [self loadComments];
}

- (void)loadData {
    // 加载菜单
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/shop/foods?sid=%@", SELFISH_HOST, self.shopItem.sid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"请求出错: %@", error);
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [SVProgressHUD dismissWithDelay:0.25];
            return;
        }
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if(jsonError) {
            NSLog(@"结果解析错误:%@", jsonError);
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [SVProgressHUD dismissWithDelay:0.25];
            return;
        }
        
        if([result[@"success"] isEqualToString:@"true"]) {
            NSArray *content = result[@"content"];
            NSMutableArray *array = [NSMutableArray array];
            [content enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SFFoodItem *item = [SFFoodItem mj_objectWithKeyValues:obj];
                [array addObject:item];
                
            }];
            weakSelf.shopItem.foods = array.copy;
            dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
                    [set addIndex:1];
                    [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];            
        });
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [SVProgressHUD dismissWithDelay:0.25];
    }];
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    [dataTask resume];
    // 加载评论
}

- (void)loadComments {
    if(self.shopItem.sid == nil) {
        return;
    }
    //    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/shop/comments?sid=%@", SELFISH_HOST, self.shopItem.sid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"GET";
    
    __weak typeof(self) weakSelf = self;
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
            NSLog(@"菜单获取成功%@", result);
            NSArray *content = result[@"content"];
            NSMutableArray *array = [NSMutableArray array];
//            weakSelf.commentsSema = dispatch_semaphore_create(-content.count);
            [content enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SFCommentItem *item = [SFCommentItem mj_objectWithKeyValues:obj];
                [array addObject:item];
                [weakSelf itemHeight:item];
            }];
            weakSelf.shopItem.comments = array.copy;
            if(array.count>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
                    [set addIndex:2];
                    [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
        }
//        dispatch_group_notify(weakSelf.group, dispatch_get_main_queue(), ^{
//            [SVProgressHUD showSuccessWithStatus:@"加载成功"];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//            [SVProgressHUD dismissWithDelay:0.25];
//        });
    }];
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    [dataTask resume];
    
    
}

- (void)itemHeight:(SFCommentItem *)item {
    //    static SongStatusView *songStatusView;
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //
    //        songStatusView = [[SongViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"一天时间浪费在了这里"];
    //    });
    dispatch_async(dispatch_get_main_queue(), ^{
        static SongStatusView *songStatusView;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            songStatusView = [[SongStatusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        });
        songStatusView.nameLabel.text = @"德维恩韦德";
        songStatusView.dateLabel.text = @"昨天 22:47";
        songStatusView.contentLabel.text = item.content;
        songStatusView.images         = item.pics.mutableCopy;
        [songStatusView setNeedsLayout];
        [songStatusView layoutIfNeeded];
        item.itemFrame = CGRectMake(0, 0, 0, songStatusView.size.height);
        //计算高度
//        [self.items addObject:item];
    });
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        SUImageBrowserVC *vc = [SUImageBrowserVC new];
        vc.images = self.shopItem.pics.copy;
        if(self.navigationController) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 2 && indexPath.row == 0) {
        SFCommentListVC *vc = [SFCommentListVC new];
        vc.sid = self.shopItem.sid;
        if(self.navigationController) {
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(0 == section) {
        return 2;
    }else if(1 == section) {
        return 1;
    }else if(2 == section) {
        if(self.shopItem.comments && self.shopItem.comments.count>0) {
            return 1;
        }
        return 0;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(0 == indexPath.section) {
        if(0 == indexPath.row) {
            SFShopDetailCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFShopDetailCoverCell" forIndexPath:indexPath];
            if(self.shopItem.pics.count>0) {
                SUImageManager *imageManager = [SUImageManager defaultImageManager];
                [imageManager setImageView:cell.imageView withURL:[NSURL URLWithString:self.shopItem.pics[0]]];
            }
            [cell.picNumberButton setTitle:[NSString stringWithFormat:@"图片(%ld)", self.shopItem.pics.count] forState:UIControlStateNormal];
            return cell;
        }else if(1 == indexPath.row) {
            SFShopDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFShopDetailTitleCell" forIndexPath:indexPath];
            cell.shopNameLabel.text = self.shopItem.name;
            cell.shopAverageCostLabel.text = [NSString stringWithFormat:@"人均:%.2lf", self.shopItem.averageCost];
            return cell;
        }
    }else if(1 == indexPath.section) {
        if(0 == indexPath.row) {
            SFShopDetailMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFShopDetailMenuCell" forIndexPath:indexPath];
            NSMutableString *string = [NSMutableString string];
            [self.shopItem.foods enumerateObjectsUsingBlock:^(SFFoodItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [string appendString:obj.name];
                [string appendString:@" "];
            }];
            cell.menuLabel.text = string;
            return cell;
        }
    }else if(2 == indexPath.section) {
        if(0 == indexPath.row) {
            SongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongViewCell" forIndexPath:indexPath];
            if(self.shopItem.comments && self.shopItem.comments.count>0) {
                SFCommentItem *commentItem = [self.shopItem.comments objectAtIndex:0];
                // 头像
                // 用户名
                // 时间
                // 评论文字
                cell.songStatusView.images = commentItem.pics.copy;
                cell.songStatusView.contentLabel.text = commentItem.content;
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(0 == indexPath.section) {
        if(0 == indexPath.row) {
            return self.view.size.width*0.618;
        }else if(1 == indexPath.row) {
            return 60;
        }
    }else if(1 == indexPath.section) {
        if(0 == indexPath.row) {
            return 50;
        }
    }else if(2 == indexPath.section) {
        if(0 == indexPath.row) {
            if(self.shopItem.comments && self.shopItem.comments.count>0) {
                SFCommentItem *commentItem = [self.shopItem.comments objectAtIndex:0];
                return commentItem.itemFrame.size.height;
            }
            return 0;
        }
    }
    return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

- (NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
