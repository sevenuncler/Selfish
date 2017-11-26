//
//  SFCommentCell.h
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCommentCell : UITableViewCell
@property(nonatomic,strong) UIButton    *avatorButton;
@property(nonatomic,strong) UILabel     *nameLabel;
@property(nonatomic,strong) UILabel     *timeLabel;
@property(nonatomic,strong) UITextView  *contentTextView;

@end
