//
//  SUImageBrowserVC.h
//  selfish
//
//  Created by fanghe on 18/1/13.
//  Copyright © 2018年 He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUImageBrowserVC : UIViewController
@property(nonatomic,strong) NSMutableArray *images;
@property(nonatomic,assign) NSInteger      currentIndex;
@end
