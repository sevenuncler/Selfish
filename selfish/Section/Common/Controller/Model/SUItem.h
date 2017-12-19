//
//  SUItem.h
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


typedef void(^Handler)(NSData * data, NSURLResponse * response, NSError * error);
@interface SUItem : NSObject
@property(nonatomic,assign) CGRect itemFrame;
    
    - (void)addWithComplection:(Handler)handler;
    - (void)delete;
    - (void)update;
    - (void)queryByID:(NSString *)sid complection:(Handler)handler;
    - (void)queryWithComplection:(Handler)handler;
@end
