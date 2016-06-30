//
//  ZHNwebImageOperation.h
//  radiousConor
//
//  Created by zhn on 16/5/3.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZHNimageDownLoadCallBackBlock)(NSData *data,NSError *error);
typedef void (^ZHNimageDownLoadProgressBlock)(unsigned long long total,unsigned long long current);

@interface ZHNwebImageOperation : NSOperation
/**
 *  初始化方法
 *
 *  @param request    请求
 *  @param progress   过程的回调
 *  @param completion 成功的回调
 *
 *  @return 对象
 */
- (instancetype)initWithRequest:(NSURLRequest *)request fullKey:(NSString *)fullkey progress:(ZHNimageDownLoadProgressBlock)progress completion:(ZHNimageDownLoadCallBackBlock)completion;
/**
 *  取消当前imageview的图片下载
 */
- (void)cancelDownLoad;
@end
