//
//  HomeTableViewCell.m
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "HomeTableViewCell.h"

#define TITLE_FONT      20.f
#define SUBTITLE_FONT   11.f
//布局参数
#define CORNER_RADIUS   10.f
#define PADDING         20.f

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpSubViews {
    switch (self.cellType) {
        case HomeTableViewCellStyleDefault:
            break;
        default:
            break;
    }
}

#pragma mark - Getter && Setter

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"忍术的奥义";
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if(!_subtitleLabel) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.font = [UIFont systemFontOfSize:SUBTITLE_FONT];
        _subtitleLabel.textColor = [UIColor blackColor];
        _subtitleLabel.text = @"今日主题";
    }
    return _subtitleLabel;
}

- (UIImageView *)coverImageView {
    if(!_coverImageView) {
        _coverImageView = [UIImageView new];
        
    }
    return _coverImageView;
}

@end
