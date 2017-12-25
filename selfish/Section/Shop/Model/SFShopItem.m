//
//  SFShopItem.m
//  selfish
//
//  Created by He on 2017/11/26.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopItem.h"
#import <MJExtension/MJExtension.h>
#import "SUSQLManager.h"
#import <objc/runtime.h>

@implementation SFShopItem


- (NSString *)stringOfTag {
    NSMutableString *string = [NSMutableString string];
    [self.tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:obj];
        [string appendString:@","];
    }];
    return string.copy;
}

- (void)add {
        
}
    
- (void)delete {
        
}
    
    - (void)update {
        
    }
    
    + (void)queryByAccountID:(NSString *)aid complection:(Handler)handler {
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlPath = [NSString stringWithFormat:@"%@/shop/query?account_aid=%@",SELFISH_HOST,aid];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
        request.HTTPMethod = @"GET";
       [[session dataTaskWithRequest:request completionHandler:handler] resume];
    }
    
    - (void)query {
        
    }

+ (void)createItemWithDictionary:(NSDictionary *)json {
//    SFShopItem *item = [SFShopItem mj_objectWithKeyValues:json];
//    SUSQLManager *defaultManager = [SUSQLManager defaultManager];
}

- (void)createTable {
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    for(int i=0; i<count; i++) {
        objc_property_t property = propertyList[i];
        const char *name = property_getName(property);
        NSString *type = [self getPropertyType:property];
        type = [self getCTypeWithType:type];
        [keyValues setValue:type forKey:[NSString stringWithUTF8String:name]];
    }
    NSString *className = NSStringFromClass([self class]);
    NSString *tableID   = [NSString stringWithFormat:@"%@id", [[className substringToIndex:1] lowercaseString]];
    NSMutableString *createTableSQL = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT", className, tableID];
    [keyValues enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if(![key isEqualToString:tableID]) {
            [createTableSQL appendString:[NSString stringWithFormat:@", '%@' %@", key, obj]];
        }
    }];
    [createTableSQL appendString:@")"];
    SUSQLManager *manager = [SUSQLManager defaultManager];
    [manager createTable:createTableSQL];
}

- (NSString *)getPropertyType:(objc_property_t)property {
    const char *attribute = property_getAttributes(property);
    NSString *attr = [NSString stringWithUTF8String:attribute];
    NSArray *contents = [attr componentsSeparatedByString:@","];
    NSString *type = contents[0];
    type = [type substringWithRange:NSMakeRange(3, type.length-4)];
    return type;
}

- (NSString *)getCTypeWithType:(NSString *)type {
    NSString *cType = nil;
    if([type isEqualToString:@"NSString"]) {
        cType = @"text";
    }else if([type isEqualToString:@"NSInteger"]) {
        cType = @"int";
    }
    return cType;
}


@end
