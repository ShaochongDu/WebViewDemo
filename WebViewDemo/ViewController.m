//
//  ViewController.m
//  WebViewDemo
//
//  Created by Shaochong Du on 16/8/30.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "ViewController.h"
#import "ShowImageTool.h"


@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testWebView" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *picName = [[request URL] absoluteString];
    NSLog(@"picName is %@",picName);
    if ([picName hasPrefix:@"pic:"]) {
        [[ShowImageTool shareInstance] showImageWithImageStr:@"http://www.bz55.com/uploads/allimg/121201/1-121201111T3-50.jpg" originFrame:CGRectZero];
        return NO;
    } else if ([picName hasPrefix:@"pic1:"]) {
        [[ShowImageTool shareInstance] showImageWithImageStr:@"http://img4.duitang.com/uploads/item/201502/11/20150211005650_AEyUX.jpeg" originFrame:CGRectZero];
        return NO;
    } else {
        return YES;
    }
}


@end
