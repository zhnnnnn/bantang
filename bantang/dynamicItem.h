//
//  dynamicItem.h
//  bantang
//
//  Created by zhn on 16/6/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface dynamicItem : NSObject<UIDynamicItem>

@property (nonatomic, readwrite) CGPoint center;

@property (nonatomic, readonly) CGRect bounds;

@property (nonatomic, readwrite) CGAffineTransform transform;

@end
