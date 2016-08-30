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
    
    //利用CSS修饰出带阴影的图片
    NSString *htmlString = @"<html><head>\
    <style type='text/css'>\
    img.shadow{padding:4px 10px 10px 4px;\
    border:0;\
    border-top:#eee 1px solid;\
    border-left:#eee 1px solid;\
    background-image: url(shadow.gif);\
    background-repeat: no-repeat;\
    background-position: right bottom;}\
    </style>\
    <style type='text/css'>span.highlight{background-color:blue;font-size:110%}</style>\
    </head>\
    <body>\
    <p><a href='pic:huoxing.jpg'><img class='shadow' src='demo0.jpg' width='200' height='200' align='right'></a>\
    <span class='highlight'>楼市调控传闻放大 上海离婚登记处热闹像菜市场!</span> 各路神仙“集中火力炮轰”希拉里：丑闻黑幕此起彼伏!\
    扬子晚报网8月30日讯(记者 裴睿)近日，南京秦淮警方处理了这样一起让人哭笑不得的警情。开学第一天，一名初三男生被老师拒之门外后报警求助。警方赶到后发现该男生竟然顶着一头及肩发来学校。最终，民警将该男生领到了辖区内的一家理发店。!\
    8月27日上午8点多钟，南京市公安局秦淮分局洪武路派出所接到辖区某学校初三学生的报警电话，称开学第一天，老师就不让他进校园。接到报警后，派出所民警立即前往事发地了解情况。!\
    <p><a href='pic1:huoxing.jpg'><img class='shadow' src='demo1.jpg' width='224' height='224' align='right'></a>\
    </p>\
    </body>\
    </html>";
    
    NSString *resPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/"];
    NSLog(@"resPath is %@",resPath);
    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:resPath]];
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
