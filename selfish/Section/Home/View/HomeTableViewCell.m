//
//  HomeTableViewCell.m
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIView+Layout.h"
#import "Macros.h"

#define TITLE_FONT      22.f
#define SUBTITLE_FONT   11.f
//布局参数
#define CORNER_RADIUS   10.f
#define PADDING         20.f

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subtitleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUpSubViews];
}

- (void)setUpSubViews {
    switch (self.cellType) {
        case HomeTableViewCellStyleDefault:
            [self defaultLayout];
            break;
        default:
            [self defaultLayout];
            break;
    }
}

- (void)defaultLayout {
    [self.subtitleLabel sizeToFit];
    self.subtitleLabel.left = PADDING;
    self.subtitleLabel.top  = PADDING;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.left = PADDING;
    self.titleLabel.top  = self.subtitleLabel.botton + PADDING;
    
    self.coverImageView.size = CGSizeMake(SCREEN_WIDTH - 2*PADDING, SCREEN_WIDTH + 2*PADDING);
    self.coverImageView.layer.cornerRadius = 15;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.top = self.titleLabel.botton + PADDING;
    self.coverImageView.left = PADDING;
    
    self.size = CGSizeMake(self.size.width, self.coverImageView.botton);
    
}

#pragma mark - Getter && Setter

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"Today";
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
        _coverImageView.image = [UIImage imageNamed:@"image"];
    }
    return _coverImageView;
}

@end
