//
//  CLCHostReceiver.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import "CLCHostReceiver.h"
#import "ServiceSocket.h"
#import "LocalSocketDefine.h"

@interface CLCHostReceiver ()<ServiceSocketDelegate, ServiceSocketConnectDelegate>
@property(strong, nonatomic) ServiceSocket *serviceSocket;

///解码工具
@property (nonatomic) id<CLCDecoderProvideDelegate>decoder;

@end

@implementation CLCHostReceiver

- (instancetype)init {
    self = [super init];
    if (self) {
        _dispatch = [[CLCLocalSocketDispatch alloc] init];
        [self setupSocketService];
    }
    return self;
}

- (void)setupSocketService {
    self.serviceSocket = [[ServiceSocket alloc] init];
    self.serviceSocket.delegate = self;
}

- (void)start {
    [self.serviceSocket startService];
}

- (void)stop {
    [self.serviceSocket closeService];
}

#pragma mark - ServiceSocketDelegate
- (void)service:(ServiceSocket *)service didCreateNewConnect:(ServiceSocketConnect *)connect {
    connect.delegate = self;
}

#pragma mark - ServiceSocketConnectDelegate
- (void)socketConnect:(ServiceSocketConnect *)connect receiveData:(NSData *)data userInfo:(nonnull NSDictionary *)userInfo {

    NSString *connectId = [userInfo objectForKey:LocalSocketClientUserInfoKeyConnectId];
    //交由分发模块进行分发
    [self.dispatch receiveData:data userInfo:userInfo connectId:connectId];
}


@end
