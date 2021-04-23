//
//  CLCVideoDecoder.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/22.
//

#import "CLCVideoDecoder.h"

@interface CLCVideoDecoder ()

///解码工具
@property (nonatomic) id<CLCDecoderProvideDelegate>decoder;
@end


@implementation CLCVideoDecoder

- (instancetype)initWithVideoProvider:(id<CLCDecoderProvideDelegate>)decoder {
    if (self = [super init]) {
        self.decoder = decoder;
        [self setupDecoder:decoder];
    }
    return self;
}

- (void)setupDecoder:(id<CLCDecoderProvideDelegate>)provider {
    self.decoder = provider;
    __weak CLCVideoDecoder *weakSelf = self;
    [self.decoder setup];
    [self.decoder setCallback:^(CVPixelBufferRef _Nonnull pixelBuffer) {
        __strong CLCVideoDecoder *strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(didGetDecodeBuffer:)]) {
            [strongSelf.delegate didGetDecodeBuffer:pixelBuffer];
        }
    }];
}

- (void)receiveData:(NSData *)data {
    [self.decoder decode:data];
}

@end
