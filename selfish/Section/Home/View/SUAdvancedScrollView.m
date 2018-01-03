//
//  SUAdvancedScrollView.m
//  selfish
//
//  Created by He on 2018/1/2.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SUAdvancedScrollView.h"

@implementation SUAdvancedScrollView

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if(![self isOver]) {
//        [super touchesMoved:touches withEvent:event];
//    }
//}

//- (UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
//    if([self isOver]) {
//        return [super hitTest:point withEvent:event];
//    }else {
//        return self;
//    }
//}

- (BOOL)isOver {
    return YES;
    if(self.targetView && self.sourceView) {
        CGRect rect = [self.sourceView convertRect:self.targetView.bounds toView:self.targetView];
        NSLog(@"%lf", rect.origin.y);
        if(rect.origin.y <= self.thresholdOffset) {
            return YES;
        }
    }
    return NO;
}


@end
