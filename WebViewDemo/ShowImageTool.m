//
//  ShowImageTool.m
//  WebViewDemo
//
//  Created by Shaochong Du on 16/8/30.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "ShowImageTool.h"
#import "UIImageView+WebCache.h"
#import "UIView+Addition.h"

static CGRect oldframe;
static UIImageView *curImageView;


@implementation ShowImageTool

+ (instancetype)shareInstance
{
    static ShowImageTool *showImageToolManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        showImageToolManager = [[self alloc] init];
    });
    return showImageToolManager;
}

-(void)showImageWithImageStr:(NSString *)imageStr originFrame:(CGRect)frame
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    if (frame.origin.x != 0 && frame.origin.y != 0) {
        oldframe = frame;
        imageView.center = frame.origin;
    } else {
        imageView.center = window.center;
    }
    imageView.tag = 1000;
    imageView.userInteractionEnabled = YES;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"close.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
                backgroundView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
        NSLog(@"下载完成->%@",imageStr);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [imageView addGestureRecognizer:gesture];
    
    //添加捏合手势
    [imageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
}

- (void)hideImage:(UITapGestureRecognizer*)tap
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1000];
    [UIView animateWithDuration:0.25 animations:^{
        if (oldframe.origin.x != 0 && oldframe.origin.y != 0) {
            imageView.frame = CGRectMake(oldframe.origin.x, oldframe.origin.y, 0, 0);
        } else {
            imageView.frame = CGRectMake(window.centerX, window.centerY, 0, 0);
        }
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    //缩放:设置缩放比例
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)longPressAction:(UIGestureRecognizer *)gestrue
{
    curImageView = (UIImageView *)gestrue.view;
    if (gestrue.state != UIGestureRecognizerStateBegan)
    {
        //这个if一定要加，因为长按会有好几种状态，按住command键，点击UIGestureRecognizerStateBegan就能看到所有状态的枚举了，因为如果不加这句的话，此方法可能会被执行多次
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"保存图片"delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"保存图片到手机",nil];
        
        actionSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [actionSheet showInView:window];

        return;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(curImageView.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
    }else {
        message = [error description];
    }
    NSLog(@"message is %@",message);
    
}


@end
