//
//  ClientSocket.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/16.
//

#import "ClientSocket.h"
#import <GCDAsyncSocket.h>
#import "NSString+IPAddress.h"

@interface ClientSocket ()<GCDAsyncSocketDelegate>
{
     GCDAsyncSocket *_clientSocket;
}

@property (nonatomic) NSTimer *timer;
@end
@implementation ClientSocket

- (void) connectToServer{
    //1.主机与端口号
    NSString *host = @"127.0.0.1";
    int port = 12345;
    
    //初始化socket，这里有两种方式。分别为是主/子线程中运行socket。根据项目不同而定
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];//这种是在主线程中运行
//    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]; //这种是在子线程中运行
    
    //开始连接
    NSError *error = nil;
    if (![_clientSocket connectToHost:host onPort:port error:&error])
    {
        NSLog(@"Client Error connecting: %@", error);
    }
}

- (void)sendData:(NSData *)data {
    [_clientSocket writeData:data withTimeout:-1 tag:0];
}

#pragma mark -socket的代理

#pragma mark 连接成功

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    //连接成功
    NSLog(@"Client %s",__func__);
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(sendData) userInfo:nil repeats:YES];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(debugSend) userInfo:nil repeats:YES];
//    self.timer = timer;
    [self connectComplete:YES];
}

#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"Client 连接失败");
    }else{
        NSLog(@"Client 正常断开");
    }
}

#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"Client %s",__func__);
    //发送完数据手动读取
    [sock readDataWithTimeout:-1 tag:tag];//不然当收到信息后不会执行读取回调方法。
}

#pragma mark 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self sendComplete:receiverStr];
    NSLog(@"received Client %s %@",__func__,receiverStr);
}

#pragma mark - 特殊代码

- (void)sendComplete:(NSString *)feedback {
    
}

- (void)connectComplete:(BOOL)successed {
    
}


- (void)debugSend {
    NSData *data = [@"hello socket " dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}
@end