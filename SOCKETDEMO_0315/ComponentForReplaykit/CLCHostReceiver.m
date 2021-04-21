//
//  CLCHostReceiver.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import "CLCHostReceiver.h"
#import "ServiceSocket.h"


#import "RongRTCVideoDecoder.h"
#import "ReplaykitCodec.h"


@interface CLCHostReceiver ()<ServiceSocketDelegate>
@property(strong, nonatomic) ServiceSocket *serviceSocket;

///解码工具
@property (nonatomic) id<CLCDecoderProvideDelegate>decoder;


@end

@implementation CLCHostReceiver

- (instancetype)initWithProvider:(id<CLCDecoderProvideDelegate>)decoder {
    if (self = [super init]) {
        self.decoder = decoder;
        [self setupDecoder:decoder];
        [self setupSocketService];
    }
    return self;
}

- (void)setupDecoder:(id<CLCDecoderProvideDelegate>)provider {
    self.decoder = provider;
    __weak CLCHostReceiver *weakSelf = self;
    [self.decoder setup];
    [self.decoder setCallback:^(CVPixelBufferRef _Nonnull pixelBuffer) {
        __strong CLCHostReceiver *strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(didGetDecodeBuffer:)]) {
            [strongSelf.delegate didGetDecodeBuffer:pixelBuffer];
        }
    }];
}

- (void)setupSocketService {
    self.serviceSocket = [[ServiceSocket alloc] init];
    self.serviceSocket.delegate = self;
}

- (void)start {
    [self.serviceSocket startService];
}

- (void)stop {
    
}

#pragma mark - SocketService
- (void)service:(ServiceSocket *)service receiveData:(NSData *)data {
    
    NSLog(@"rcv --> %ld", data.length);

    [self.decoder decode:data];
}

@end
