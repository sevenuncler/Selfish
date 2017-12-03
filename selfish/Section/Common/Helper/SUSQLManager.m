//
//  SUSQLManager.m
//  selfish
//
//  Created by He on 2017/11/29.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUSQLManager.h"
#import <sqlite3.h>
#import <objc/runtime.h>

@implementation SUSQLManager
{
    sqlite3 *_db;
}

+ (instancetype)defaultManager {
    static SUSQLManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)openDB {
    if(_db) {
        NSLog(@"已经打开");
        return;
    }
    //获取文件路径
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *strPath = [str stringByAppendingPathComponent:@"sefish.sqlite"];
    NSLog(@"%@",strPath);
    //打开数据库
    //如果数据库存在就打开,如果不存在就创建一个再打开
    int result = sqlite3_open([strPath UTF8String], &_db);
    //判断
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
}

- (void)createTableWithClass:(Class)clz {
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(clz, &count);
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
    [self createTable:createTableSQL];

}

- (void)createTable:(NSString *)sql {
    if(!_db) {
        [self openDB];
    }
    char *error = NULL;
    int result = sqlite3_exec(_db, [sql UTF8String], nil, nil, &error);
    if(SQLITE_OK == result) {
        NSLog(@"表创建成功:%@", sql);
    }else {
        printf("创建表出错:%s",error);
        NSLog(@"创建失败");
    }
}

- (void)createTable {
    if(!_db) {
        [self openDB];
    }
    NSString *sql = @"create table if not exists 'shop' ('sid' integer primary key autoincrement not null,'name' 'text','type' integer)";
    [self createTable:sql];
}

- (void)insertRow {
    NSString *sql = @"insert into 'shop' (name,type) values ('一人食',0)";
    [self insertRow:sql];
}

- (void)insertRow:(NSString *)sql {
    if(!_db) {
        [self openDB];
    }
    char *error = NULL;
    int result = sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &error);
    if(SQLITE_OK == result) {
        NSLog(@"插入数据成功:%@", sql);
    }else {
        NSLog(@"插入数据失败");
    }
}

- (NSArray *)queryRows {
    NSString *sql = @"select * from 'shop'";
    return [self queryRows:sql];
}

- (NSArray *)queryRows:(NSString *)sql {
    NSMutableArray *result = @[].mutableCopy;
    //2.伴随指针
    sqlite3_stmt *stmt = NULL;
    int code = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &stmt, NULL);
    if(SQLITE_OK == code) {
        NSLog(@"查询成功");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            @autoreleasepool{
                NSMutableDictionary *item = @{}.mutableCopy;
                //sid
                [item setObject:@(sqlite3_column_int(stmt,0)) forKey:@"sid"];
                //name
                [item setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)] forKey:@"name"];
                //type
                [item setObject:@(sqlite3_column_int(stmt, 2)) forKey:@"type"];
                [result addObject:item.copy];
            }
        }
    }else {
        NSLog(@"插入数据失败");
    }
    //关闭
    sqlite3_finalize(stmt);
    return result.copy;
}

//删除数据
- (void)deleteRows{
    //1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"delete from 'shop' where name = '一人食'"];
    [self deleteRows:sqlite];
}

- (void)deleteRows:(NSString *)sql {
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(_db, [sql UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    } else {
        NSLog(@"删除数据失败%s",error);
    }
}

- (void)closeDB {
    int code = sqlite3_close(_db);
    if(SQLITE_OK == code) {
        NSLog(@"关闭数据库成功");
        _db = NULL;
    }else {
        NSLog(@"关闭数据库失败");
    }
}

- (void)dealloc {
    [self closeDB];
}

#pragma mark - Private

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
