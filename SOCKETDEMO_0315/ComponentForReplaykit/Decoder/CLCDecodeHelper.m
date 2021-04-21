//
//  CLCDecodeHelper.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import "CLCDecodeHelper.h"
#import "RongRTCVideoDecoder.h"
#import "ReplaykitCodec.h"

typedef void(^CLCDecodeCallback)(CVPixelBufferRef);
@interface CLCDecodeHelper ()<RongRTCCodecProtocol>

@property (nonatomic) RongRTCVideoDecoder *decoder;
@property (nonatomic) CLCDecodeCallback callback;

@property (nonatomic) dispatch_queue_t decodeQueue;
@end

@implementation CLCDecodeHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.decoder = [[RongRTCVideoDecoder alloc] init];
    self.decoder.delegate = self;
    RongRTCVideoEncoderSettings *settings = [ReplaykitCodec settings];
    _decodeQueue = dispatch_queue_create("com.Replaykit.decode.queue", DISPATCH_QUEUE_SERIAL);
    [self.decoder configWithSettings:settings onQueue:_decodeQueue];
}

- (void)decode:(NSData *)data {
    [self.decoder decode:data];
}

/// 获取解码后的数据
/// @param pixelBuffer 解码后的数据
- (void)didGetDecodeBuffer:(CVPixelBufferRef)pixelBuffer {
    if (self.callback) {
        self.callback(pixelBuffer);
    }
}

@end
