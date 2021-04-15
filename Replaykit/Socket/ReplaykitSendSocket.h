//
//  ReplaykitSendSocket.h
//  Replaykit
//
//  Created by chenlecheng on 2021/3/16.
//

#import "ClientSocket.h"
#import "ReplaykitCodec.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReplaykitSendSocket : ClientSocket<ReplaykitCodecDelegate>

- (void)appendData:(NSData *)dataToSend;

- (void)sendSampleBuffer:(CMSampleBufferRef)source;
@end

NS_ASSUME_NONNULL_END
