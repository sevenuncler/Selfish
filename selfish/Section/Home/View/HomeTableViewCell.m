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
@interface HomeTableViewCell ()
@end
@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
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
        case HomeTableViewCellStyleVideo:
            [self videoStyleLayout];
            break;
        default:
            [self defaultLayout];
            break;
    }
}

- (void)defaultLayout {
    CGFloat contentViewWidth = self.size.width - 2*PADDING;
    self.contentView.layer.cornerRadius = 15;
    self.contentView.clipsToBounds = YES;
    self.contentView.left = PADDING;
    self.contentView.size = CGSizeMake(contentViewWidth, self.contentView.size.height);
    
    self.subtitleLabel.hidden = YES;
//    [self.subtitleLabel sizeToFit];
//    self.subtitleLabel.left = 0;
//    self.subtitleLabel.top  = PADDING;
    self.titleLabel.hidden = YES;
//    [self.titleLabel sizeToFit];
//    self.titleLabel.left = 0;
//    self.titleLabel.top  = self.subtitleLabel.botton + PADDING;
    
    self.coverImageView.size = CGSizeMake(self.size.width - 2*PADDING, SCREEN_WIDTH + 2*PADDING);
    self.coverImageView.layer.cornerRadius = 15;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.top = self.titleLabel.botton + PADDING;
    self.coverImageView.left = 0;
    
    self.size = CGSizeMake(self.size.width, self.coverImageView.botton);
}

- (void)videoStyleLayout {
    CGFloat contentViewWidth = self.size.width - 2*PADDING;
    self.contentView.layer.cornerRadius = 15;
    self.contentView.clipsToBounds = YES;
    self.contentView.left = PADDING;
    self.contentView.size = CGSizeMake(contentViewWidth, self.contentView.size.height);
    
    self.coverImageView.size = CGSizeMake(contentViewWidth, SCREEN_WIDTH + 2*PADDING);
    self.coverImageView.top = 0;
    self.coverImageView.left = 0;
    
    self.subtitleLabel.hidden = NO;
    [self.subtitleLabel sizeToFit];
    self.subtitleLabel.left = 0;
    self.subtitleLabel.top  = self.coverImageView.botton + PADDING;
    
    self.titleLabel.hidden = NO;
    [self.titleLabel sizeToFit];
    self.titleLabel.left = 0;
    self.titleLabel.top  = self.subtitleLabel.botton + PADDING;
    
    self.size = CGSizeMake(self.size.width, self.titleLabel.botton + PADDING);
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
