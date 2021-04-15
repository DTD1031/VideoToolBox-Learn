//
//  ReplaykitCodec.m
//  Replaykit
//
//  Created by chenlecheng on 2021/3/17.
//

#import "ReplaykitCodec.h"
#import "RongRTCVideoEncoder.h"
#import "RongRTCVideoEncoderSettings.h"

@interface ReplaykitCodec ()<RongRTCCodecProtocol>

@property (nonatomic) RongRTCVideoEncoder *encoder;
@property (nonatomic) dispatch_queue_t encodeQueue;

@end
@implementation ReplaykitCodec

- (instancetype) init {
    self = [super init];
    if (self) {
        _encoder = [[RongRTCVideoEncoder alloc] init];
        _encoder.delegate = self;
        _encodeQueue = dispatch_queue_create("com.clc.encode.callback.queue", NULL);
        
        [self setup];
    }
    return self;
}

- (void)setup {
    self.ready = [self.encoder configWithSettings:[self settings] onQueue:_encodeQueue];
    NSLog(@"ready ? %i", self.ready);
}

- (void)encodeBuffer:(CMSampleBufferRef)sampleBuffer {
    [self.encoder encode:sampleBuffer];
}

- (RongRTCVideoEncoderSettings *)settings {
    
    RongRTCVideoEncoderSettings *settings = [[RongRTCVideoEncoderSettings alloc] init];
    settings.width = 720;
    settings.height = 1280;
    settings.startBitrate = 300;
    settings.maxFramerate = 30;
    settings.minBitrate = 1000;
    
    return settings;
}

-(void)spsData:(NSData *)sps ppsData:(NSData *)pps{
    NSLog(@"%@ -> %s", NSStringFromClass(self.class),  __func__);

    [self.delegate sendDecodeData:sps];
    [self.delegate sendDecodeData:pps];
}
-(void)naluData:(NSData *)naluData{
    NSLog(@"%@ -> %s", NSStringFromClass(self.class),  __func__);
    [self.delegate sendDecodeData:naluData];
}

- (void)didGetDecodeBuffer:(nonnull CVPixelBufferRef)pixelBuffer {
    NSLog(@"didGetDecodeBuffer - %@", pixelBuffer);
}


@end
