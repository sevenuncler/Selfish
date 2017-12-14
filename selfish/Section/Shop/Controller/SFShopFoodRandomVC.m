//
//  SFShopFoodRandomVC.m
//  selfish
//
//  Created by He on 2017/12/3.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFShopFoodRandomVC.h"
#import <CoreMotion/CoreMotion.h>

@interface SFShopFoodRandomVC ()
@property(nonatomic,strong) UIView                  *containerView;
@property(nonatomic,strong) CMMotionManager         *motionManager;
@property(nonatomic,strong) UIDynamicAnimator       *dynamicAnimator;
@property(nonatomic,strong) UIDynamicItemBehavior   *dynamicItemBehavior;
@property(nonatomic,strong) UIGravityBehavior       *gravityBehavior;
@property(nonatomic,strong) UICollisionBehavior     *collisionBehavior;
@end

@implementation SFShopFoodRandomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    [self createDynamic];
    [self useGyroPush];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self createItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigator];
    [self performSelector:@selector(pushInFood) withObject:nil afterDelay:0.75];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)setUpNavigator {
    self.title = @"试一试手气";
    
  
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(handleBackAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    CGFloat naviHeight = self.navigationController.navigationBar.botton;
    self.containerView.top = naviHeight;
    self.containerView.size = CGSizeMake(self.view.size.width, self.view.size.height-naviHeight);
}

- (void)handleBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createItem{
    int x = arc4random() % (int)self.view.frame.size.width; //随机X坐标
    int size = arc4random() % 30 + 20;//随机大小
    NSArray * imageArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 100, size, size)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:imageArray[arc4random() % imageArray.count]];
    [self.containerView addSubview:imageView];
    //让imageView遵循行为
    [_dynamicItemBehavior addItem:imageView];
    [_gravityBehavior addItem:imageView];
    [_collisionBehavior addItem:imageView];
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeItem:)];
    [imageView addGestureRecognizer:taps];
}

- (void)removeItem:(UITapGestureRecognizer *)taps{
    UIView *tempViews = taps.view;
    [_dynamicItemBehavior removeItem:tempViews];
    [_gravityBehavior removeItem:tempViews];
    [_collisionBehavior removeItem:tempViews];
    [tempViews removeFromSuperview];
    
}

- (void)createDynamic
{
    //创建现实动画 设定动画模拟区间。self.view : 地球
    _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.containerView];
    //创建物理仿真行为
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    //设置弹性系数,数值越大,弹力值越大
    _dynamicItemBehavior.elasticity = 0.5;
    //重力行为
    _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
    _gravityBehavior.gravityDirection = CGVectorMake(0.5, 0.5);
    //碰撞行为
    _collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[]];
    //开启刚体碰撞
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    //将行为添加到物理仿动画中
    [_dynamicAnimator addBehavior:_dynamicItemBehavior];
    [_dynamicAnimator addBehavior:_gravityBehavior];
    [_dynamicAnimator addBehavior:_collisionBehavior];
    
}

- (void)useGyroPush{
    //初始化全局管理对象
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    self.motionManager = manager;
    //判断传感器是否可用
    if ([self.motionManager isDeviceMotionAvailable]) {
        ///设备 运动 更新 间隔
        manager.deviceMotionUpdateInterval = 0.1;
        ///启动设备运动更新队列
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                double gravityX = motion.gravity.x;
                                                    double gravityY = motion.gravity.y;
                                                    // double gravityZ = motion.gravity.z;
                                                    // 获取手机的倾斜角度(z是手机与水平面的夹角， xy是手机绕自身旋转的角度)：
                                                    //double z = atan2(gravityZ,sqrtf(gravityX * gravityX + gravityY * gravityY))  ;
                                                    double xy = atan2(gravityX, gravityY);
                                                    // 计算相对于y轴的重力方向
                                                    _gravityBehavior.angle = xy-M_PI_2;
                                                    
                                                }];
        
    }
}

- (void)pushInFood {
    for (int i=0 ; i<15; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createItem];
        });
    }
    self.gravityBehavior.gravityDirection = CGVectorMake(5, 5);
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _containerView;
}

@end
