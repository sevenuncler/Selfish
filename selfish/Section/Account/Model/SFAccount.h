//
//  SFAccount.h
//  selfish
//
//  Created by He on 2017/12/15.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SUItem.h"

@interface SFAccount : SUItem

+ (void)shopsWithAccountID:(NSString *)aid complection:(Handler)handler;
    
@end
