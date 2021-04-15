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

@property (nonatomic) ReplaykitSendSocket *clientSocket;
@property (nonatomic) ReplaykitCodec *encodec;
@end
@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    
    self.clientSocket = [[ReplaykitSendSocket alloc] init];
    
    self.encodec = [[ReplaykitCodec alloc] init];
    self.encodec.delegate = self.clientSocket;
    
    [self.clientSocket connectToServer];
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
//                [self.encodec encodeBuffer:sampleBuffer];
                [self.clientSocket sendSampleBuffer:sampleBuffer];
            }
            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            break;
            
        default:
            break;
    }
}

@end
