//
//  SFCommentListVC.m
//  selfish
//
//  Created by He on 2017/12/28.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFCommentListVC.h"
#import "SFCommentItem.h"
#import "StatusCell.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SUImageBrowserVC.h"

@interface SFCommentListVC ()
@property(nonatomic,strong) dispatch_semaphore_t commentsSema;
@property(nonatomic,strong) dispatch_group_t group;
@end

static NSString * const reuseID = @"reuseID";
@implementation SFCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataBinding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadComments];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dataBinding {
    [self.tableView registerClass:[SongViewCell class] forCellReuseIdentifier:reuseID];
}

- (void)loadComments {
    if(self.sid == nil) {
        return;
    }
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"%@/shop/comments?sid=%@", SELFISH_HOST, self.sid];
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
            weakSelf.commentsSema = dispatch_semaphore_create(-content.count);
            [content enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                SFCommentItem *item = [SFCommentItem mj_objectWithKeyValues:obj];
                [strongSelf itemHeight:item];
            }];
        }
        dispatch_group_notify(weakSelf.group, dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"加载成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            [SVProgressHUD dismissWithDelay:0.25];
        });
    }];
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    [dataTask resume];
    
    
}

#pragma mark - Private

- (void)itemHeight:(SFCommentItem *)item {
//    static SongStatusView *songStatusView;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        songStatusView = [[SongViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"一天时间浪费在了这里"];
//    });
    dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_group_enter(self.group);
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
        [self.items addObject:item];
        dispatch_group_leave(self.group);
        });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCommentItem *item = [self.items objectAtIndex:indexPath.row];
    CGFloat height = item.itemFrame.size.height;
    return height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    SFCommentItem *item = [self.items objectAtIndex:indexPath.row];
    cell.songStatusView.images = item.pics.mutableCopy;
    cell.songStatusView.contentLabel.text = item.content;
    cell.songStatusView.nameLabel.text = item.content;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    __weak typeof(cell) weakCell = cell;
    [[tapGR rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        __strong typeof(weakCell) strongCell = weakCell;
        SUImageBrowserVC *vc = [SUImageBrowserVC new];
        vc.images = strongCell.songStatusView.images.copy;
        if(self.navigationController) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [cell.songStatusView.contentView addGestureRecognizer:tapGR];
    [cell.songStatusView setNeedsLayout];
    
    return cell;
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

- (dispatch_group_t)group {
    if(!_group) {
        _group =  dispatch_group_create();
    }
    return _group;
}

@end
