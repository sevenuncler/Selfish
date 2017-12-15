//
//  SFAccount.m
//  selfish
//
//  Created by He on 2017/12/15.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFAccount.h"

@implementation SFAccount

    + (void)shopsWithAccountID:(NSString *)aid complection:(Handler)handler {
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlPath = [NSString stringWithFormat:@"%@/account/shops?aid=%@",SELFISH_HOST,aid];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
        request.HTTPMethod = @"GET";
        [[session dataTaskWithRequest:request completionHandler:handler] resume];
    }
    
@end
