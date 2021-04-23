//
//  SampleHandler.m
//  Replaykit
//
//  Created by chenlecheng on 2021/3/16.
//


#import "SampleHandler.h"

#import "ReplaykitSendSocket.h"

#import "ReplaykitCodec.h"

@interface SampleHandler ()

@property (nonatomic) ReplaykitSendSocket *videoClientSocket;
@property (nonatomic) ReplaykitSendSocket *audioClientSocket;

@property (nonatomic) ReplaykitCodec *encodec;
@end
@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    
    self.videoClientSocket = [[ReplaykitSendSocket alloc] initWithConnectId:@"1001"];
    self.audioClientSocket = [[ReplaykitSendSocket alloc] initWithConnectId:@"1002"];
    
    self.encodec = [[ReplaykitCodec alloc] init];
    self.encodec.delegate = self.videoClientSocket;
    
    [self.videoClientSocket connectToServer];
    [self.audioClientSocket connectToServer];
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional. 
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            // Handle video sample buffer
            if (self.encodec.ready) {
                [self.encodec encodeBuffer:sampleBuffer];
            }
            break;
        case RPSampleBufferTypeAudioApp: {
            // Handle audio sample buffer for app audio

            //获取CMBlockBufferRef
            CMBlockBufferRef buffer = CMSampleBufferGetDataBuffer(sampleBuffer);
            //获取pcm数据大小
            size_t length = CMBlockBufferGetDataLength(buffer);

            char bf[length];
            
            NSData *data = [NSData dataWithBytes:bf length:length];
            
            [self.audioClientSocket appendData:data];
            
            
        } break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            break;
            
        default:
            break;
    }
}

@end
