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
@property(nonatomic,strong) SFShopFoodPicView *foodPicView;
@property(nonatomic,strong) SFShopFoodCustomeViewModel *foodPicViewModel;
@property(nonatomic, strong) UIButton             *submitButton;
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
            return 100;
        }else if(1 == indexPath.row) {
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseTableViewCell forIndexPath:indexPath];
    
    // Configure the cell...
    if(0 == indexPath.section) {
        if(0 == indexPath.row) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88)];
            textField.placeholder = @"  简单描述食物";
            cell.myContentView = textField;
        }else if(1 == indexPath.row) {
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
        _submitButton.botton = self.view.size.height;
    }
    return _submitButton;
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

@end
