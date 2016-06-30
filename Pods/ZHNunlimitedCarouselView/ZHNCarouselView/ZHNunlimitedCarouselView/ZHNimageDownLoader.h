//
//  ZHNimageDownLoader.h
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ZHNimageDownLoadCallBackBlock)(NSData *data,NSError *error);
typedef void (^ZHNimageDownLoadProgressBlock)(unsigned long long total,unsigned long long current);

@class ZHNwebImageOperation;
@interface ZHNimageDownLoader : NSObject

- (NSOperationQueue *)delegateQueue;
/**
 *  单例方法
 *
 *  @return 下载器
 */
+ (ZHNimageDownLoader *)shareInstace;
/**
 *  下载图片的方法
 *
 *  @param url      图片url
 *  @param progress 成功的回调
 *  @param finished 失败的回调
 */
- (ZHNwebImageOperation *)startDownLoadImageWithUrl:(NSString *)url fullKey:(NSString *)fullkey imageviewObject:(UIImageView *)object progress:(ZHNimageDownLoadProgressBlock)progress finished:(ZHNimageDownLoadCallBackBlock)finished;
@end
