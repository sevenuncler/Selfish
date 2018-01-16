//
//  SFShopTypeViewModel.m
//  selfish
//
//  Created by He on 2018/1/15.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SFShopTypeViewModel.h"

@implementation SFShopTypeViewModel

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"类型";
}

- (NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
@end
