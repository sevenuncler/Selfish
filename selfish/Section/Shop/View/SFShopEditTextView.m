//
//  SFShopEditTextView.m
//  selfish
//
//  Created by He on 2017/12/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopEditTextView.h"

@implementation SFShopEditTextView
@synthesize label = _label;
@synthesize textField = _textField;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.label];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 5;
    CGFloat width   = self.size.width;
    CGFloat height  = self.size.height;
    
//    [self.label sizeToFit];
    self.label.size = CGSizeMake(width/5, height);
    self.label.left = 0;
    self.label.centerY = self.size.height / 2;
    
    self.textField.size = CGSizeMake(width - padding - self.label.size.width, height);
    self.textField.left = self.label.right + padding;
    self.textField.centerY = self.label.centerY;
}

- (SUTextField *)textField {
    if(!_textField) {
        _textField = [[SUTextField alloc] init];
        _textField.text = @"XX名称";
        _textField.layer.borderColor  = SELFISH_MAJRO_COLOR.CGColor;
        _textField.layer.borderWidth  = 2.0f;
        _textField.layer.cornerRadius = 5;
    }
    return _textField;
}

- (UILabel *)label {
    if(!_label) {
        _label = [UILabel new];
        _label.text = @"名称";
    }
    return _label;
}

@end
