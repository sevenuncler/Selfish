//
//  HomeViewModel.h
//  selfish
//
//  Created by He on 2017/11/22.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface HomeViewModel : NSObject <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) RACSubject *selectedIndexSignal;
@end
