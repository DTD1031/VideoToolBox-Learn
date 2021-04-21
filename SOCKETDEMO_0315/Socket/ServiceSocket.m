//
//  ServiceSocket.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/16.
//

#import "ServiceSocket.h"
#import <GCDAsyncSocket.h>
#import "CLCDataCache.h"

@interface ServiceSocket ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_serverSocket;
}

@property(strong,nonatomic)NSMutableArray *clientSocket;

@property (nonatomic) NSDictionary *currentHeader; //头信息，下一个数据按这个头来拆
@property (nonatomic) NSMutableData *cache; //缓存的数据

//@property (nonatomic) CLCDataCache *cache;

@property (nonatomic) dispatch_queue_t receiveQueue;

@end
@implementation ServiceSocket


- (instancetype)init {
    if (self = [super init]) {
        
        _clientSocket = [NSMutableArray array];
            //创建服务端的socket，注意这里的是初始化的同时已经指定了delegate
        
        _receiveQueue = dispatch_queue_create("com.serviceSocket.queue", DISPATCH_QUEUE_SERIAL);
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_receiveQueue];
        
        _cache = [NSMutableData new];
//        _cache = [[CLCDataCache alloc] init];
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

#pragma mark 有客户端建立连接的时候调用
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    //sock为服务端的socket，服务端的socket只负责客户端的连接，不负责数据的读取。newSocket为客户端的socket    NSLog(@"服务端的socket %p 客户端的socket %p",sock,newSocket);
    //保存客户端的socket，如果不保存，服务器会自动断开与客户端的连接（客户端那边会报断开连接的log）
    NSLog(@"Server %s",__func__);
    [self.clientSocket addObject:newSocket];
    
    //newSocket为客户端的Socket。这里读取数据
    [self readData:newSocket];
}

#pragma mark 服务器写数据给客户端
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"Server %s",__func__);
    
    [self readData:sock];
}

#pragma mark 接收客户端传递过来的数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //sock为客户端的socket
    //接收到数据
//        //断开连接
//        [sock disconnect];
//        //移除socket
//        [self.clientSocket removeObject:sock];
    //----拆包
    
    if (self.currentHeader) {
      //读数据
        NSUInteger totalLength = [[self.currentHeader objectForKey:@"length"] unsignedIntegerValue];
        NSUInteger lengthToReceive = totalLength - self.cache.length;
        if (data.length > lengthToReceive) {
            //数据长度超过header定义的长度，拼接
            NSData *body = [data subdataWithRange:NSMakeRange(0, lengthToReceive)];
            [self.cache appendData:body];

            //拼接完了取剩下数据作为header
            NSData *nextHeaderData = [data subdataWithRange:NSMakeRange(lengthToReceive, data.length - lengthToReceive)];
            NSError *err;
            NSDictionary *header = [NSJSONSerialization JSONObjectWithData:nextHeaderData options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSAssert(NO, @"error by load next header");
            }
            self.currentHeader = header;
        } else {

            //没那么长，直接拼接
            [self.cache appendData:data];
        }

        
        if (totalLength == self.cache.length) {
            //长度足够
            if ([self.delegate respondsToSelector:@selector(service:receiveData:)]) {
//                [self.delegate service:self receiveData:[self.cache outputData]];
                [self.delegate service:self receiveData:self.cache];
            }
//            [self.cache cleanCache];
            self.cache = [NSMutableData new];
        }
        
    } else {
        NSError *err;
        NSDictionary *header = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        self.currentHeader = header;
        if (err) {
            NSAssert(NO, @"error by load first header");
        }
    }

    //------
    
    NSString *feedbackString = @"back";
    // 响应给客户端的数据
    [sock writeData:[feedbackString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    
    NSLog(@"Server %s",__func__);
}


#pragma mark - 拆包

- (void)readData:(GCDAsyncSocket *)socket {
    
    [socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:100];
}


@end
