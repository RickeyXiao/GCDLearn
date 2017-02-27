//
//  ViewController.m
//  GCDLearn
//
//  Created by Metallic  on 17/2/21.
//  Copyright © 2017年 xiaowei. All rights reserved.
//

typedef void(^blk)();

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建串行队列和并行队列
//    [self testDispatchQueueCreate];
    
    //同步和异步执行操作
//    [self testSyncAndAsync];
    
    //同步和异步混合
    [self testSyncAndAsyncMix];
}

- (void)testSyncAndAsyncMix
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.gcd.syncAndAsyncMix.serialQueue", NULL);
    dispatch_async(serialQueue, ^{
        NSLog(@"1");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"11");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"111");
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"1111");
    });
    NSLog(@"2");
    dispatch_sync(serialQueue, ^{
        NSLog(@"3");
    });
    NSLog(@"4");
}

- (void)testSyncAndAsync
{
    //获取一个全局队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //要执行的block
    void (^blk)() = ^{
        NSLog(@"Execute block");
    };

    //同步执行操作
    //dispatch_sync(globalQueue, blk);
    //NSLog(@"Done!");
        
    //异步执行操作
    dispatch_async(globalQueue, blk);
    NSLog(@"Done!");
}

- (void)testDispatchQueueCreate
{
    //第一个参数是队列名称，采用域名反转的命名规则，便于调试
    //第二个参数用于区分创建串行队列还是并行队列。串行队列应传入 NULL 或 DISPATCH_Q   UEUE_SERIAL；并行队列应传入 DISPATCH_QUEUE_CONCURRENT
    //优先级使用的是默认优先级，即 DISPATCH_QUEUE_PRIORITY_DEFAULT
    
    //创建串行队列
//    dispatch_queue_t mySerialQueue = dispatch_queue_create("com.gcd.queueCreate.mySerialQueue", NULL);
    
    //创建并行队列
    dispatch_queue_t myConcurrentQueue = dispatch_queue_create("com.gcd.queueCreate.myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //执行的操作
    void (^blk1)() = ^{
        NSLog(@"Execute blk1 in %@", [NSThread currentThread]);
    };
    void (^blk2)() = ^{
        NSLog(@"Execute blk2 in %@", [NSThread currentThread]);
    };
    void (^blk3)() = ^{
        NSLog(@"Execute blk3 in %@", [NSThread currentThread]);
    };
    void (^blk4)() = ^{
        NSLog(@"Execute blk4 in %@", [NSThread currentThread]);
    };
    void (^blk5)() = ^{
        NSLog(@"Execute blk5 in %@", [NSThread currentThread]);
    };
    void (^blk6)() = ^{
        NSLog(@"Execute blk6 in %@", [NSThread currentThread]);
    };
    
    //串行队列执行六个操作，无论运行多少次顺序都是一致的
//    dispatch_async(mySerialQueue, blk1);
//    dispatch_async(mySerialQueue, blk2);
//    dispatch_async(mySerialQueue, blk3);
//    dispatch_async(mySerialQueue, blk4);
//    dispatch_async(mySerialQueue, blk5);
//    dispatch_async(mySerialQueue, blk6);
    
    //并行队列执行六个操作，多运行几次发现每次输出顺序都可能变化，这是由iOS的XNU内核在管理线程，操作的执行可能分配到不同或相同的线程中
    dispatch_async(myConcurrentQueue, blk1);
    dispatch_async(myConcurrentQueue, blk2);
    dispatch_async(myConcurrentQueue, blk3);
    dispatch_async(myConcurrentQueue, blk4);
    dispatch_async(myConcurrentQueue, blk5);
    dispatch_async(myConcurrentQueue, blk6);
}

@end
