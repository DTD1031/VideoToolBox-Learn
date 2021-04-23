//
//  CLCDecoderProvideDelegate.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CLCDecodeCallback)(CVPixelBufferRef);
@protocol CLCDecoderProvideDelegate <NSObject>

- (void)setup;
- (void)decode:(NSData *)data;
- (void)setCallback:(CLCDecodeCallback)didDecode;

@end

NS_ASSUME_NONNULL_END
