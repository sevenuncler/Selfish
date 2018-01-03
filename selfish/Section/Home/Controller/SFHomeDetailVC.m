//
//  SFHomeDetailVC.m
//  selfish
//
//  Created by He on 2018/1/1.
//  Copyright © 2018年 He. All rights reserved.
//

#import "SFHomeDetailVC.h"
#import <WebKit/WebKit.h>
#import <MMMarkdown/MMMarkdown.h>
#import "SUAdvancedScrollView.h"

@interface SFHomeDetailVC ()
@property(nonatomic,strong) UIView    *coverView;
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) UIScrollView   *scrollView;
@property(nonatomic,strong) SUAdvancedScrollView *advancedScrollView;
@end

@implementation SFHomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.coverView];
    [self.scrollView addSubview:self.webView];
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.webView.top = self.coverView.botton;
//    self.webView.size = self.webView.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.webView.size.height + self.coverView.size.height);
//    self.advancedScrollView.contentSize = self.view.bounds.size;
}

- (void)loadWebView {
    NSString *sourceString = @"<font size=12 face='黑体' color=gray> \\# ReactiveCocoa 与 MVVM在含GUI软件的开发过程中，基于MVX的视图、模型、业务逻辑分离的分层开发思想被广泛的应用，其实也可以看出这几个模型之间的区别主要是X的实现方式的不同。\n\n\n## MVVM （Model-View-ViewModel）其实是MVP(Model-View-Presention)模式的衍生，\n\n\n大家都知道其实MVP广泛的应用在移动开发过程中，苹果自家的Cocoa框架中的ViewController其实更加偏向于MVP模式（即视图与模型的同步操作、\n\n\n状态放在ViewController中，\n\n\n而MVC模式中C倾向于负责路由作用、View可以与Model直接交互）；</font>\r\n[![drew.jpg](http://img5.imgtn.bdimg.com/it/u=4130922592,3193289117&fm=200&gp=0.jpg)](http://baidu.com)  <div  align='center'><img src='http://img5.imgtn.bdimg.com/it/u=4130922592,3193289117&fm=200&gp=0.jpg' width = '100%' height = '32%' alt='图片名称' align=center /></div>";
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:sourceString error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (WKWebView *)webView {
    if(!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(15, 0, self.view.size.width-30, self.view.size.height*3)];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.backgroundColor = [UIColor grayColor];
        _webView.scrollView.bounces = YES;
    }
    return _webView;
}

- (UIView *)coverView {
    if(!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _coverView.backgroundColor = [UIColor redColor];
    }
    return _coverView;
}

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blueColor];
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (SUAdvancedScrollView *)advancedScrollView {
    if(!_advancedScrollView) {
        _advancedScrollView = [[SUAdvancedScrollView alloc] initWithFrame:self.view.bounds];
        _advancedScrollView.thresholdOffset = 300;
        _advancedScrollView.targetView = self.view;
        _advancedScrollView.sourceView = self.webView;
        _advancedScrollView.backgroundColor = [UIColor yellowColor];
    }
    return _advancedScrollView;
}

@end
