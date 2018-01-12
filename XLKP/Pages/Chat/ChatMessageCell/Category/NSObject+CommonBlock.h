//
//  NSObject+CommonBlock.h
//  XLKP
//
//  Created by Facebook on 2017/11/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CommonVoidBlock)(void);

typedef void (^CommonBlock)(id selfPtr);

typedef void (^CommonCompletionBlock)(id selfPtr, BOOL isFinished);

@interface NSObject (CommonBlock)


/**
 * 执行

 @param block block description
 */
- (void)excuteBlock:(CommonBlock)block;


/**
 * 完成

 @param block block description
 */
- (void)performBlock:(CommonBlock)block;


/**
 * 取消

 @param block block description
 */
- (void)cancelBlock:(CommonBlock)block;


/**
 * 延迟完成

 @param block block description
 @param delay delay description
 */
- (void)performBlock:(CommonBlock)block afterDelay:(NSTimeInterval)delay;


/**
 * 执行

 @param block block description
 @param finished finished description
 */
- (void)excuteCompletion:(CommonCompletionBlock)block withFinished:(NSNumber *)finished;


/**
 * 完成

 @param block block description
 @param finished finished description
 */
- (void)performCompletion:(CommonCompletionBlock)block withFinished:(BOOL)finished;


/**
 * 并发执行tasks里的作务，等tasks执行行完毕，回调到completion

 @param completion completion description
 @param task task description
 */
- (void)asynExecuteCompletion:(CommonBlock)completion tasks:(CommonBlock)task, ... NS_REQUIRES_NIL_TERMINATION;
@end
