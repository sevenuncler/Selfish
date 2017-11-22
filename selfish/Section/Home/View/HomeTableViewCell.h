//
//  HomeTableViewCell.h
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomeTableViewCellStyle){
    HomeTableViewCellStyleDefault,
    HomeTableViewCellStyleVideo
} ;

@interface HomeTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel         *titleLabel;        //主标题
@property(nonatomic,strong) UILabel         *subtitleLabel;     // 副标题
@property(nonatomic,strong) UIImageView     *coverImageView;    //封面
@property(nonatomic,assign) HomeTableViewCellStyle cellType;    //排列类型
@end
