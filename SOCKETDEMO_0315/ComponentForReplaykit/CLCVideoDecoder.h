//
//  CLCVideoDecoder.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/22.
//

#import <Foundation/Foundation.h>
#import "CLCDecoderProvideDelegate.h"
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CLCVideoDecoderHandlerDelegate <NSObject>
@required

/// 处理解码后的数据
/// @param pixelBuffer 解码后的数据
- (void)didGetDecodeBuffer:(CVPixelBufferRef)pixelBuffer;
@end

@interface CLCVideoDecoder : NSObject
@property (nonatomic, weak) id <CLCVideoDecoderHandlerDelegate>delegate;

- (instancetype)initWithVideoProvider:(id<CLCDecoderProvideDelegate>)provider;

- (void)receiveData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
