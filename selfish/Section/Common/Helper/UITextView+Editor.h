//
//  UITextView+Editor.h
//  selfish
//
//  Created by fanghe on 17/12/20.
//  Copyright © 2017年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Editor)

- (NSInteger)currentLineOfCursor;
- (NSInteger)indexOfLineAtBegin:(NSInteger)lineNum;
- (NSInteger)indexOfLineAtEnd:(NSInteger)lineNum;

@end
