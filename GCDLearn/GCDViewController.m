//
//  ViewController.m
//  GCDLearn
//
//  Created by Metallic  on 17/2/21.
//  Copyright © 2017年 xiaowei. All rights reserved.
//

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
//    [self testSyncAndAsyncMix];
    
    //改变队列优先级和执行阶层
//    [self testSetTargetQueue1];
    
    //设置队列执行阶层
    [self testSetTargetQueue2];
}

- (void)testSetTargetQueue2
{
    dispatch_queue_t serialQueue1 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue1", NULL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue2", NULL);
    dispatch_queue_t serialQueue3 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue3", NULL);
    dispatch_queue_t serialQueue4 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue4", NULL);
    dispatch_queue_t serialQueue5 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue5", NULL);
    
//    //设置前
//    dispatch_async(serialQueue1, ^{
//        NSLog(@"1");
//    });
//    dispatch_async(serialQueue2, ^{
//        NSLog(@"2");
//    });
//    dispatch_async(serialQueue3, ^{
//        NSLog(@"3");
//    });
//    dispatch_async(serialQueue4, ^{
//        NSLog(@"4");
//    });
//    dispatch_async(serialQueue5, ^{
//        NSLog(@"5");
//    });
    
    //创建目标串行队列
    dispatch_queue_t targetSerialQueue = dispatch_queue_create("com.gcd.setTargetQueue2.targetSerialQueue", NULL);

    //设置执行阶层
    dispatch_set_target_queue(serialQueue1, targetSerialQueue);
    dispatch_set_target_queue(serialQueue2, targetSerialQueue);
    dispatch_set_target_queue(serialQueue3, targetSerialQueue);
    dispatch_set_target_queue(serialQueue4, targetSerialQueue);
    dispatch_set_target_queue(serialQueue5, targetSerialQueue);
    
    //设置后
    dispatch_async(serialQueue1, ^{
        NSLog(@"1");
    });
    dispatch_async(serialQueue2, ^{
        NSLog(@"2");
    });
    dispatch_async(serialQueue3, ^{
        NSLog(@"3");
    });
    dispatch_async(serialQueue4, ^{
        NSLog(@"4");
    });
    dispatch_async(serialQueue5, ^{
        NSLog(@"5");
    });
}

- (void)testSetTargetQueue1
{
    //优先级变更的串行队列，初始是默认优先级
    dispatch_queue_t serialQueue = dispatch_queue_create("com.gcd.setTargetQueue1.serialQueue", NULL);

    //优先级不变的串行队列（参照），初始是默认优先级
    dispatch_queue_t serialDefaultQueue = dispatch_queue_create("com.gcd.setTargetQueue1.serialDefaultQueue", NULL);

    //变更前
    dispatch_async(serialQueue, ^{
        NSLog(@"1");
    });
    dispatch_async(serialDefaultQueue, ^{
        NSLog(@"2");
    });

    //获取优先级为后台优先级的全局队列
    dispatch_queue_t globalDefaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    //变更优先级
    dispatch_set_target_queue(serialQueue, globalDefaultQueue);

    //变更后
    dispatch_async(serialQueue, ^{
        NSLog(@"1");
    });
    dispatch_async(serialDefaultQueue, ^{
        NSLog(@"2");
    });
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
