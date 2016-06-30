//
//  ZHNimageDownLoader.m
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNimageDownLoader.h"
#import "UIImageView+ZHNimage.h"
#import "ZHNwebImageOperation.h"
@interface ZHNimageDownLoader()
@property (nonatomic,strong) NSOperationQueue * webImageOperationQueue;// 队列
@property (nonatomic,copy) NSMutableDictionary * imageOperationDic;
@end


@implementation ZHNimageDownLoader

+ (ZHNimageDownLoader *)shareInstace{
    static dispatch_once_t once;
    static id downLoader;
    dispatch_once(&once, ^{
        downLoader = [[ZHNimageDownLoader alloc]init];
    });
    return downLoader;
}
- (NSMutableDictionary *)imageOperationDic{
    if (_imageOperationDic == nil) {
        _imageOperationDic = [NSMutableDictionary dictionary];
    }
    return _imageOperationDic;
}
- (instancetype)init{
    if (self = [super init]) {
        self.webImageOperationQueue = [[NSOperationQueue alloc]init];
        self.webImageOperationQueue.maxConcurrentOperationCount  = 6;
    }
    return self;
}
- (NSOperationQueue *)delegateQueue{
    return self.webImageOperationQueue;
}

- (ZHNwebImageOperation *)startDownLoadImageWithUrl:(NSString *)url fullKey:(NSString *)fullkey imageviewObject:(UIImageView *)object progress:(ZHNimageDownLoadProgressBlock)progress finished:(ZHNimageDownLoadCallBackBlock)finished{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:60];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    ZHNwebImageOperation * imageOperation = [[ZHNwebImageOperation alloc]initWithRequest:request fullKey:fullkey progress:progress completion:finished];
    if (imageOperation.isCancelled || imageOperation.isFinished) {
        return nil;
    }else{
        [self.webImageOperationQueue addOperation:imageOperation];
        return imageOperation;
    }
}







@end
