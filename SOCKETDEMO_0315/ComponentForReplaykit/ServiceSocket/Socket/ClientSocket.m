//
//  ClientSocket.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/16.
//

#import "ClientSocket.h"
#import <GCDAsyncSocket.h>
#import "NSString+IPAddress.h"
#import "LocalSocketDefine.h"

#import "CLCPacketer.h"

@interface ClientSocket ()<GCDAsyncSocketDelegate>
{
     GCDAsyncSocket *_clientSocket;
}

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSString *connectId;
@end

@implementation ClientSocket

- (instancetype)initWithConnectId:(NSString *)connectId {
    self = [super init];
    if (self) {
        self.connectId = connectId;
    }
    return self;
}

- (void) connectToServer{
    //1.主机与端口号
    NSString *host = @"127.0.0.1";
    int port = 12345;
    
    //初始化socket，这里有两种方式。分别为是主/子线程中运行socket。根据项目不同而定
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];//这种是在主线程中运行
    _clientSocket.userData = @{LocalSocketClientUserInfoKeyConnectId:@"13579"};
//    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]; //这种是在子线程中运行
    
    //开始连接
    NSError *error = nil;
    if (![_clientSocket connectToHost:host onPort:port error:&error])
    {
        NSLog(@"Client Error connecting: %@", error);
    }
}

- (void)sendData:(NSData *)data {
    [self sendData:data userInfo:nil];
}

- (void)sendData:(NSData *)data userInfo:(NSDictionary * _Nullable)userInfo {
    
    
    NSMutableDictionary *mutUserInfo = userInfo.mutableCopy;
    if (!mutUserInfo) {
        mutUserInfo = @{}.mutableCopy;
    }
    
    [mutUserInfo setObject:self.connectId ? : @"0000" forKey:LocalSocketClientUserInfoKeyConnectId];
    
    NSLog(@"%@", mutUserInfo);
    NSData *packet = [CLCPacketer packetData:data userInfo:mutUserInfo.copy];
    [_clientSocket writeData:packet withTimeout:-1 tag:100];
}

#pragma mark -socket的代理

#pragma mark 连接成功

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    //连接成功
    [self connectComplete:YES];
}

#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"Client 连接失败 %@", err);
    }else{
        NSLog(@"Client 正常断开");
    }
}

#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    //发送完数据手动读取
    [sock readDataWithTimeout:-1 tag:tag];//不然当收到信息后不会执行读取回调方法。
}

#pragma mark 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self sendComplete:receiverStr];
}

#pragma mark - 特殊代码

- (void)sendComplete:(NSString *)feedback {
    
}

- (void)connectComplete:(BOOL)successed {
    
}

@end
