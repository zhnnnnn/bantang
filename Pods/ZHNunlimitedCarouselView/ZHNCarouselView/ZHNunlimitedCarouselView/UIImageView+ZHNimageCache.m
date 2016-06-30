
//
//  UIImageView+ZHNimageCache.m
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "UIImageView+ZHNimageCache.h"
#import "UIImageView+ZHNimage.h"
#import "ZHNimageDownLoader.h"
#import "ZHNwebImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "ZHNwebImageOperation.h"
#import <objc/runtime.h>

static NSMutableDictionary * faildUrls;

@implementation UIImageView (ZHNimageCache)
#pragma mark set get 方法
- (ZHNwebImageOperation *)currentImageOperation{
    return objc_getAssociatedObject(self, @"ZHNwebImageOperation");
}
- (void)setCurrentImageOperation:(ZHNwebImageOperation *)currentImageOperation{
    objc_setAssociatedObject(self, @"ZHNwebImageOperation", currentImageOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 接口方法
- (void)zhn_setImageWithUrl:(NSString *)url{
    [self zhn_setImageWithUrl:url withContentMode:ZHN_contentModeDefault needDefaultImage:YES placeHolder:nil];
}
- (void)zhn_setImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder{
    [self zhn_setImageWithUrl:url withContentMode:ZHN_contentModeDefault needDefaultImage:YES placeHolder:placeHolder];
}
- (void)zhn_setImageWithUrl:(NSString *)url withContentMode:(ZHN_contentMode)mode{
    [self zhn_setImageWithUrl:url withContentMode:mode needDefaultImage:NO placeHolder:nil];
}
- (void)zhn_setImageWithUrl:(NSString *)url withContentMode:(ZHN_contentMode)mode placeHolder:(UIImage *)placeHolder{
    [self zhn_setImageWithUrl:url withContentMode:mode needDefaultImage:NO placeHolder:placeHolder];
}


- (void)zhn_setImageWithUrl:(NSString *)url withContentMode:(ZHN_contentMode)mode needDefaultImage:(BOOL)needDefaultImage placeHolder:(UIImage *)placeHolder{
    
    // 取消当前imageview的下载任务
    [self.currentImageOperation cancelDownLoad];
    
    if (placeHolder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = placeHolder;
        });
    }
    if (faildUrls == nil) {//
        faildUrls = [NSMutableDictionary dictionary];
    }
    if(faildUrls[url]){
        return;
    }
    
    if(url.length == 0){
        return;
    }
    
    NSString * fullKey = [NSString stringWithFormat:@"%@%f%f%lu",[self cachedFileNameForKey:url],self.frame.size.width,self.frame.size.height,mode];
   
    if (mode == ZHN_contentModeDefault) {
        fullKey = [self cachedFileNameForKey:url];
    }
    UIImage * currentImage = [[ZHNwebImageCache shareInstance]zhnWebImageCache_getImageWithKey:fullKey];
    if (currentImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = currentImage;
        });
        return;
    }
    
    
    
   ZHNwebImageOperation * imageOperation = [[ZHNimageDownLoader shareInstace] startDownLoadImageWithUrl:url fullKey:fullKey imageviewObject:self progress:nil finished:^(NSData *data, NSError *error) {
       
       if (error || data == nil) {
           NSLog(@"%@",error);
           return;
       }
       
       UIImage * currentImage = [UIImage imageWithData:data];
       if (!currentImage) {
           [faildUrls setObject:@"faild" forKey:url];
           return;
       }
     
        // 需要默认的图片的情况
        if (needDefaultImage) {
            [[ZHNwebImageCache shareInstance]zhnWebImageCache_setImage:nil imageData:data key:[self cachedFileNameForKey:url]];
        }
        if (mode == ZHN_contentModeDefault) { // 默认的显示
            [[ZHNwebImageCache shareInstance]zhnWebImageCache_setImage:[UIImage imageWithData:data] key:[self cachedFileNameForKey:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = [UIImage imageWithData:data];
            });
        }else{// 特殊的显示
            
            self.scaleImageBlock = ^(UIImage * scaleImage){
                 [[ZHNwebImageCache shareInstance]zhnWebImageCache_setImage:scaleImage key:fullKey];
            };
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self zhn_setContentMode:mode withImage:[UIImage imageWithData:data] frame:self.frame];
            });
        }
    }];

    [imageOperation start];
    self.currentImageOperation = imageOperation;
}

// md5 加密有两个好处啊，一是不暴露url 还有就是在存入disk的情况下如果有 / 的话会生成路劲失败
- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
}




@end
