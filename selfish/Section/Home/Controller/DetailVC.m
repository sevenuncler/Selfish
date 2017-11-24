//
//  DetailVC.m
//  selfish
//
//  Created by He on 2017/11/24.
//  Copyright © 2017年 He. All rights reserved.
//

#import "DetailVC.h"
#import "Macros.h"

@interface DetailVC ()

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topImageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImageView *)topImageView {
    if(!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/0.8)];
        _topImageView.image = [UIImage imageNamed:@"image"];
    }
    return _topImageView;
}

@end
