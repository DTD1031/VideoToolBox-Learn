//
//  ServiceSocket.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/16.
//

#import "ServiceSocket.h"
#import <GCDAsyncSocket.h>
#import "ServiceSocketConnect.h"

@interface ServiceSocket ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_serverSocket;
}

@property (strong, nonatomic) NSMutableArray <ServiceSocketConnect *>*connects;

@property (nonatomic) dispatch_queue_t receiveQueue;

@end
@implementation ServiceSocket


- (instancetype)init {
    if (self = [super init]) {
        
        _connects = [NSMutableArray array];
            //创建服务端的socket，注意这里的是初始化的同时已经指定了delegate
        
        _receiveQueue = dispatch_queue_create("com.serviceSocket.queue", DISPATCH_QUEUE_SERIAL);
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_receiveQueue];
        
    }
    return self;
}

- (void)startService {
    //打开监听端口
    NSError *err;
    [_serverSocket acceptOnPort:12345 error:&err];
    if (!err) {
        NSLog(@"Server 服务开启成功");
    }else{
        NSLog(@"Server 服务开启失败");
    }
}

- (void)closeService {
    for (ServiceSocketConnect *connect in self.connects) {
        //逐个断开链接
        [connect.clientSocket disconnect];
    }
    [self.connects removeAllObjects];
}

- (void)closeConnect:(ServiceSocketConnect *)connect {
    
    BOOL disconnected = NO;
    for (ServiceSocketConnect *connect in self.connects) {
        if ([connect isEqual:connect]) {
            [connect.clientSocket disconnect];
            disconnected = YES;
            break;
        }
    }
    [self.connects removeObject:connect];
}

#pragma mark 有客户端建立连接的时候调用
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    //sock为服务端的socket，服务端的socket只负责客户端的连接，不负责数据的读取。
    //newSocket为客户端的socket
    ServiceSocketConnect *connect = [[ServiceSocketConnect alloc] init];
    connect.serviceSocket = sock;
    connect.clientSocket = newSocket;
//    self.connects
    
    [self.connects addObject:connect];
    //保存客户端的socket，如果不保存，服务器会自动断开与客户端的连接（客户端那边会报断开连接的log）
    if ([self.delegate respondsToSelector:@selector(service:didCreateNewConnect:)]) {
        [self.delegate service:self didCreateNewConnect:connect];
    }
    
    //newSocket为客户端的Socket。这里读取数据
    [self readData:newSocket];
}

#pragma mark 服务器写数据给客户端
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [self readData:sock];
}

#pragma mark 接收客户端传递过来的数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //sock为客户端的socket
    for (ServiceSocketConnect *connect in self.connects) {
        if ([connect.clientSocket isEqual:sock]) {
            [connect receiveData:data withTag:tag];
            [self readDataBySocketConnect:connect];
        }
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    
}


#pragma mark - 拆包

- (void)readData:(GCDAsyncSocket *)socket {
    
    [socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:100];
}

- (void)readDataBySocketConnect:(ServiceSocketConnect *)connect {
    [self readData:connect.clientSocket];
}

@end
