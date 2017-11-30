//
//  SFShopDetailVC.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopDetailVC.h"
#import "SUTableViewItem.h"
#import "SFShopDetailCoverItem.h"
#import "UIView+Layout.h"
#import "SFShopDetailTagCell.h"
#import "SFShopDetailMenuCell.h"
#import "SFShopDetailTitleCell.h"
#import "SFShopDetailCoverCell.h"
#import "SFCommentCell.h"
#import "StatusCell.h"

@interface SFShopDetailVC ()

@end

@implementation SFShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SFShopDetailCoverCell class] forCellReuseIdentifier:@"SFShopDetailCoverCell"];
    [self.tableView registerClass:[SFShopDetailTitleCell class] forCellReuseIdentifier:@"SFShopDetailTitleCell"];
    [self.tableView registerClass:[SFShopDetailMenuCell class] forCellReuseIdentifier:@"SFShopDetailMenuCell"];
    [self.tableView registerClass:[SongViewCell class] forCellReuseIdentifier:@"SongViewCell"];
    
    self.title = @"店铺名称";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData {
//    {
//        SUTableViewItem *tableViewItem = [SUTableViewItem new];
//
//        SFShopDetailCoverItem *coverItem = [SFShopDetailCoverItem new];
//        coverItem.pics= self.shopItem.pics.copy;
//        coverItem.itemFrame = CGRectMake(0, 0, self.view.size.width, self.view.size.width*0.618);
//
//    }
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
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(0 == indexPath.section) {
        if(0 == indexPath.row) {
            SFShopDetailCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFShopDetailCoverCell" forIndexPath:indexPath];
            return cell;
        }else if(1 == indexPath.row) {
            SFShopDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFShopDetailTitleCell" forIndexPath:indexPath];
            return cell;
        }
    }else if(1 == indexPath.section) {
        if(0 == indexPath.row) {
            SFShopDetailMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFShopDetailMenuCell" forIndexPath:indexPath];
            return cell;
        }
    }else if(2 == indexPath.section) {
        if(0 == indexPath.row) {
            SongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongViewCell" forIndexPath:indexPath];
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
            return 55;
        }
    }else if(2 == indexPath.section) {
        if(0 == indexPath.row) {
            return 700;
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
