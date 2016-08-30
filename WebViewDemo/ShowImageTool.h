//
//  ShowImageTool.h
//  WebViewDemo
//
//  Created by Shaochong Du on 16/8/30.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShowImageTool : NSObject<UIActionSheetDelegate>

+ (instancetype)shareInstance;

-(void)showImageWithImageStr:(NSString *)imageStr originFrame:(CGRect)frame;

@end
