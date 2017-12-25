//
//  SUTextField.m
//  selfish
//
//  Created by He on 2017/12/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUTextField.h"

@implementation SUTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectInset(bounds, 5, 5);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectInset(bounds, 5, 5);
    return inset;
}

@end
