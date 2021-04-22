//
//  CLCHostReceiver.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import "CLCDecoderProvideDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CLCHostReceiverHandlerDelegate <NSObject>
@required
/// 处理解码后的数据
/// @param pixelBuffer 解码后的数据
- (void)didGetDecodeBuffer:(CVPixelBufferRef)pixelBuffer;
@end

@interface CLCHostReceiver : NSObject

///正在接收中
@property (nonatomic) BOOL working;

/// 处理数据回调的对象
@property (nonatomic, weak) id<CLCHostReceiverHandlerDelegate> delegate;

///全村的希望，decode处理者
- (instancetype)initWithProvider:(id<CLCDecoderProvideDelegate>)provider;

/// 开始获取数据
- (void)start;

///停止获取数据
- (void)stop;
@end

NS_ASSUME_NONNULL_END
