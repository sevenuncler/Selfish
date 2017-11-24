//
//  HomeViewHeader.m
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "HomeViewHeader.h"
#import "UIView+Layout.h"

#define TITLE_FONT      22.f
#define SUBTITLE_FONT   11.f
#define PADDING         20.f
@implementation HomeViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.subtitleLabel sizeToFit];
    self.subtitleLabel.left = PADDING;
    self.subtitleLabel.top  = PADDING;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.left = PADDING;
    self.titleLabel.top  = self.subtitleLabel.botton + PADDING;
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


@end
