//
//  UIImageView+ZHNradius.m
//  radiousConor
//
//  Created by zhn on 16/4/27.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "UIImageView+ZHNimage.h"
#import <objc/runtime.h>
#define KviewWidth self.frame.size.width
#define KviewHeight self.frame.size.height

@implementation UIImageView (ZHNimage)
#pragma mark - set get 方法
- (void)setZHN_radius:(CGFloat)ZHN_radius{
    
    objc_setAssociatedObject(self, @"key", @(ZHN_radius), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CGFloat)ZHN_radius{
   return [objc_getAssociatedObject(self, @"key")floatValue];
}

- (void)setZHN_imageMode:(ZHN_contentMode)ZHN_imageMode{
    objc_setAssociatedObject(self, @"contentMode", @(ZHN_imageMode), OBJC_ASSOCIATION_ASSIGN);
}

- (ZHN_contentMode)ZHN_imageMode{
    return [objc_getAssociatedObject(self, @"contentMode") integerValue];
}

- (void)setZHN_image:(UIImage *)ZHN_image{
    objc_setAssociatedObject(self, @"zhnImageKey", ZHN_image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)ZHN_image{
    return objc_getAssociatedObject(self, @"zhnImageKey");
}

- (void)setHandledImage:(UIImage *)handledImage{
    objc_setAssociatedObject(self, @"imageKey", handledImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)handledImage{
    return objc_getAssociatedObject(self, @"imageKey");
}
- (void)setScaleImageBlock:(ZHNscaleImageBlock)scaleImageBlock{
    objc_setAssociatedObject(self, @"imageBlock", scaleImageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (ZHNscaleImageBlock)scaleImageBlock{
    return objc_getAssociatedObject(self, @"imageBlock");
}


#pragma mark - 内部处理方法
- (void)p_getNewImage{
    CGFloat radius = self.ZHN_radius;
    if (radius > self.frame.size.width/2) {
        NSLog(@"radius必须要小于控件宽度的一半");
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        CGRect currentRect = [self p_cutImage];
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
        CGContextRef contex = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(contex, KviewWidth/2, 0);
        CGContextAddLineToPoint(contex, KviewWidth - radius, 0);
        CGContextAddArc(contex, KviewWidth - radius, radius, radius, (M_PI) *1.5, 0, NO);
        CGContextAddLineToPoint(contex, KviewWidth,  KviewHeight - radius);
        CGContextAddArc(contex, KviewWidth - radius, KviewHeight - radius, radius, 0, 0.5*(M_PI), NO);
        CGContextAddLineToPoint(contex, radius, KviewHeight);
        CGContextAddArc(contex, radius,  KviewHeight - radius, radius, 0.5*M_PI, M_PI,  NO);
        CGContextAddLineToPoint(contex, 0, radius);
        CGContextAddArc(contex, radius, radius, radius, M_PI, 1.5*M_PI, NO);
        CGContextClosePath(contex);
        
        CGContextClip(contex);
        [self.ZHN_image drawInRect:currentRect];
        UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
        self.handledImage = newImage;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.scaleImageBlock) {
                self.scaleImageBlock(newImage);
            }
            self.image = newImage;
        });
        UIGraphicsEndImageContext();
    });
  
}
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (CGRect)p_cutImage{
    
    CGFloat widthScale = self.ZHN_image.size.width / KviewWidth;
    CGFloat heightScale = self.ZHN_image.size.height / KviewHeight;
    CGFloat cutScale = widthScale > heightScale ? heightScale : widthScale;
    // 新的高度
    CGFloat fitImageWidth = self.ZHN_image.size.width / cutScale;
    CGFloat fitImaegHeight = self.ZHN_image.size.height / cutScale;
    // 默认是不作处理
    CGRect currentRect = CGRectMake(0, 0, self.ZHN_image.size.width, self.ZHN_image.size.height);
    switch (self.ZHN_imageMode) {
        case ZHN_contentModeTop:
            currentRect = CGRectMake((KviewWidth - fitImageWidth)/2, 0, fitImageWidth, fitImaegHeight);
            break;
        case ZHN_contentModeBottom:
            currentRect = CGRectMake((KviewWidth - fitImageWidth)/2, KviewHeight - fitImaegHeight, fitImageWidth, fitImaegHeight);
            break;
        case ZHN_contentModeCenter:
            currentRect = CGRectMake((KviewWidth - fitImageWidth)/2, (KviewHeight - fitImaegHeight)/2, fitImageWidth, fitImaegHeight);
            break;
        case ZHN_contentModeLeft:
            currentRect = CGRectMake(0, (KviewHeight - fitImaegHeight)/2 , fitImageWidth, fitImaegHeight);
            break;
        case ZHN_contentModeRight:
            currentRect = CGRectMake(KviewWidth - fitImageWidth , (KviewHeight - fitImaegHeight)/2 , fitImageWidth, fitImaegHeight);
            break;
        default:
            break;
    }
    return currentRect;
}
#pragma mark - 外部接口
- (void)zhn_setRadius:(CGFloat)radius withImage:(UIImage *)image frame:(CGRect)frame{
    self.ZHN_image = image;
    self.ZHN_radius = radius;
    self.frame = frame;
    [self p_getNewImage];
}

- (void)zhn_setRadius:(CGFloat)radius contentMode:(ZHN_contentMode)mode withImage:(UIImage *)image frame:(CGRect)frame{
    self.ZHN_image = image;
    self.ZHN_radius = radius;
    self.ZHN_imageMode = mode;
    self.frame = frame;
    [self p_getNewImage];
}

- (void)zhn_setContentMode:(ZHN_contentMode)contentMode withImage:(UIImage *)image frame:(CGRect)frame{
    
    self.ZHN_image = image;
    self.frame = frame;
    self.ZHN_imageMode = contentMode;
    self.ZHN_radius = 0;
    [self p_getNewImage];
}

@end
