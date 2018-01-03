//
//  SUAdvancedScrollView.h
//  selfish
//
//  Created by He on 2018/1/2.
//  Copyright © 2018年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUAdvancedScrollView : UIScrollView
@property(nonatomic,assign) CGFloat thresholdOffset;
@property(nonatomic,weak)   UIView  *targetView;
@property(nonatomic,weak)   UIView  *sourceView;
@end
