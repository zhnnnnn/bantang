//
//  ZHNwebImageOperation.m
//  radiousConor
//
//  Created by zhn on 16/5/3.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNwebImageOperation.h"
#import "ZHNimageDownLoader.h"
#import "ZHNwebImageCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface ZHNwebImageOperation()<NSURLSessionDownloadDelegate>{
    BOOL        executing;  // 执行中
    BOOL        finished;   // 已完成
}
@property (nonatomic,strong) NSURLSession *connection;// 任务
@property (nonatomic,strong) NSURLSessionDownloadTask * downLoadTask;
@property (nonatomic,strong) NSMutableData * data;
@property (nonatomic, assign) unsigned long long totalLength;
@property (nonatomic, assign) unsigned long long currentLength;
@property (nonatomic, copy) ZHNimageDownLoadProgressBlock progressBlock;
@property (nonatomic, copy) ZHNimageDownLoadCallBackBlock callbackOnFinished;

@property (nonatomic,strong) UIImage * cacheImage;
@end

@implementation ZHNwebImageOperation

- (instancetype)initWithRequest:(NSURLRequest *)request fullKey:(NSString *)fullkey progress:(ZHNimageDownLoadProgressBlock)progress completion:(ZHNimageDownLoadCallBackBlock)completion{

    if (self = [super init]) {
        
        NSURLSessionConfiguration * defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _connection = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[[ZHNimageDownLoader shareInstace] delegateQueue]];
        _downLoadTask = [self.connection downloadTaskWithRequest:request];
        
        _data = [NSMutableData data];
        _progressBlock = progress;
        _callbackOnFinished = completion;
        executing = NO;
        finished = NO;
        
       
    }
    return self;
}

- (void)start {
    
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self.downLoadTask resume];
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}
- (void)main {
    @try {
        BOOL isFinished = NO;
        // 必须为自定义的 operation 提供 autorelease pool，因为 operation 完成后需要销毁。
        @autoreleasepool {
            while (isFinished == NO && [self isCancelled] == NO){
                [self.downLoadTask resume];
                isFinished = YES;
            }
            [self completeOperation];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception %@", e);
    }
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}


- (void)cancelDownLoad{
    [self.downLoadTask cancel];
//    [self cancel];
    [self start];
    [self cancel];
}


// 下载完成
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
    }
    
    if (self.callbackOnFinished) {
        self.callbackOnFinished(data, nil);
        
        // 防止重复调用
        self.callbackOnFinished = nil;
    }
}

// 下载过程
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    self.currentLength = totalBytesWritten;
    self.totalLength = totalBytesExpectedToWrite;

    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
    }
}

// 下载失败

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        if (self.callbackOnFinished) {
            self.callbackOnFinished(nil, error);
        }
        self.callbackOnFinished = nil;
    }
}



@end
