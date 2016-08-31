//
//  SecondViewController.m
//  WebViewDemo
//
//  Created by Shaochong Du on 16/8/30.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "SecondViewController.h"
#import "ShowImageTool.h"

@interface SecondViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSMutableArray *allImageArray;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  7张图
    NSString *url = @"http://cps-lib.gongyeyun.com/Page/Activity.aspx?id=a00768f2-174a-42f5-b4cb-7214ca58003e";
    //  3张图
//    NSString *url = @"http://cps-lib.gongyeyun.com/Page/Activity.aspx?id=7ce6f17c-0477-4408-be4c-577f8c8e962f";
    //  0张图
//    NSString *url = @"http://cps-lib.gongyeyun.com/Page/Activity.aspx?id=9770f336-1f8d-4366-88af-455d10c88a1e";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] ]];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.webView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- TapGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取网页中所有图片
//    NSString *imageUrls = [webView stringByEvaluatingJavaScriptFromString:@"var str=new Array();""$('img').each(function(){str.push($(this).attr('src'));});"
//                           "str.join(',');"];
//    NSLog(@"\n\n 所有图片 : %@",imageUrls);
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var ids = document.getElementById(\"js_content\");\
    var objs = ids.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    self.allImageArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    [self.allImageArray removeLastObject];
    NSLog(@"---------->%@",self.allImageArray);
}

//被点击位置对应链接
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"\nimage url ========> %@", urlToSave);
    
    NSString * JsToGetHTMLSource = @"top.location.href";
    NSString * pageSource = [self.webView stringByEvaluatingJavaScriptFromString:JsToGetHTMLSource];
    NSLog(@"\n__url------>%@", pageSource);
    
    if ([urlToSave hasPrefix:@"http:"]) {
        NSString *lastStr = [urlToSave lastPathComponent];
        if ([lastStr rangeOfString:@"jpg"].location != NSNotFound || [lastStr rangeOfString:@"png"].location != NSNotFound) {
            [[ShowImageTool shareInstance] showImageWithImageStr:urlToSave originFrame:CGRectMake(pt.x, pt.y, 0, 0)];
            //  当前点击第几张图片
            NSUInteger index = [self.allImageArray indexOfObject:urlToSave];
            NSLog(@"index--->%ld",index);
        }
//        NSString *substr = [urlToSave substringFromIndex:urlToSave.length-3];
//        if([substr isEqualToString:@"jpg"] || [substr isEqualToString:@"png"]){
//            [self showImageURL:urlToSave point:pt];
//        }
    }
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
