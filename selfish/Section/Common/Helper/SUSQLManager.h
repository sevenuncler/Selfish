//
//  SUSQLManager.h
//  selfish
//
//  Created by He on 2017/11/29.
//  Copyright © 2017年 He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUSQLManager : NSObject
+ (instancetype)defaultManager;
- (void)createTable;
- (void)insertRow;
- (NSArray *)queryRows;
- (void)deleteRows;

- (void)createTable:(NSString *)sql;
- (void)insertRow:(NSString *)sql;
- (NSArray *)queryRows:(NSString *)sql;
- (void)deleteRows:(NSString *)sql;
@end
