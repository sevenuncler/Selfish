//
//  SFShopTypeViewModel.h
//  selfish
//
//  Created by He on 2018/1/15.
//  Copyright © 2018年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFShopTypeViewModel : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,strong) NSMutableArray *items;
@end
