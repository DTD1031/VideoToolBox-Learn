//
//  ReplaykitCodec.m
//  Replaykit
//
//  Created by chenlecheng on 2021/3/17.
//

#import "ReplaykitCodec.h"
#import "RongRTCVideoEncoder.h"

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
    self.ready = [self.encoder configWithSettings:[ReplaykitCodec settings] onQueue:_encodeQueue];
    NSLog(@"ready ? %i", self.ready);
}

- (void)encodeBuffer:(CMSampleBufferRef)sampleBuffer {
    [self.encoder encode:sampleBuffer];
}

+ (RongRTCVideoEncoderSettings *)settings {
    
    RongRTCVideoEncoderSettings *settings = [[RongRTCVideoEncoderSettings alloc] init];
    settings.width = 886;
    settings.height = 1918;
    settings.startBitrate = 1500*1024;
    settings.maxFramerate = 30;
    settings.minBitrate = 900*1024;
    
//    <CMVideoFormatDescription 0x28108b300 [0x1d4885b20]> {
//        mediaType:'vide'
//        mediaSubType:'420f'
//        mediaSpecific: {
//            codecType: '420f'        dimensions: 886 x 1918
//        }
//        extensions: {{
//        CVBytesPerRow = 1348;
//        CVImageBufferChromaLocationBottomField = Left;
//        CVImageBufferChromaLocationTopField = Left;
//        CVImageBufferColorPrimaries = "ITU_R_709_2";
//        CVImageBufferTransferFunction = "IEC_sRGB";
//        CVImageBufferYCbCrMatrix = "ITU_R_709_2";
//        Version = 2;
//    }}
//    }
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
