//
//  SFLifeDiaryCreateVC.m
//  selfish
//
//  Created by fanghe on 17/12/20.
//  Copyright © 2017年 He. All rights reserved.
//

#import "SFLifeDiaryCreateVC.h"
#import <MMMarkdown/MMMarkdown.h>
#import <WebKit/WebKit.h>

@interface SFLifeDiaryCreateVC ()

@end

@implementation SFLifeDiaryCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableString *html = @"".mutableCopy;
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:@"### 一、本周工作汇报" error:nil];
    [html appendString:htmlString];
    htmlString = [MMMarkdown HTMLStringWithMarkdown:@"* 1、【iOS 播放器SDK】V1.4.0 本周测试完成了异常测试，稳定性测试等；" error:nil];
    [html appendString:htmlString];
    htmlString = [MMMarkdown HTMLStringWithMarkdown:@"** 1、【iOS 播放器SDK】<font color=#0099ff size=12 face=\"黑体\">黑体</font>准备airplay相关测试分析、测试用例" error:nil];
    [html appendString:htmlString];
    htmlString = [MMMarkdown HTMLStringWithMarkdown:@"### 二、下周工作计划" error:nil];
    [html appendString:htmlString];
    
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//    
//    [webView loadHTMLString:html baseURL:nil];
//    
//    [self.view addSubview:webView];
    
    
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
