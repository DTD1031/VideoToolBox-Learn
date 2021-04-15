//
//  ReplaykitCodec.h
//  Replaykit
//
//  Created by chenlecheng on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ReplaykitCodecDelegate <NSObject>

- (void)sendDecodeData:(NSData *)data;

@end

@interface ReplaykitCodec : NSObject
@property (nonatomic) BOOL ready;
@property (nonatomic, weak) id <ReplaykitCodecDelegate>delegate;

/// client 开始编码发给 server
/// @param sampleBuffer 要编码的 sampleBuffer
- (void)encodeBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
