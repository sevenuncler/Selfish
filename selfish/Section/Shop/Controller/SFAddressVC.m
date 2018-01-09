//
//  SFAddressVC.m
//  selfish
//
//  Created by He on 2018/1/9.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SFAddressVC.h"

@interface SFAddressVC ()

@end

@implementation SFAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@".json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSArray *addresses = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%@ %@", addresses, error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
