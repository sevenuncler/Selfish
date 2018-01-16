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
    switch (component) {
        case 0:
            return self.items.count;
        case 1:
            return self.items[self.currentIdx].subTypes.count;
        default:
            break;
    }
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.items[row].name;
        case 1:
            return self.items[self.currentIdx].subTypes[row].name;
        default:
            break;
    }
    return @"类型";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.currentIdx  = row;
            [pickerView reloadComponent:1];
            break;
        case 1:
            if(self.complectionHandler) {
                self.complectionHandler(self.items[self.currentIdx], row);
            }
            break;
        default:
            break;
    }
    
}

- (NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
@end
