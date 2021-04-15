//
//  NMLRPStreamNode.h
//  Replaykit
//
//  Created by chenlecheng on 2021/3/22.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface NMLRPStreamFormat : NSObject<NSSecureCoding>

- (instancetype)initWithFormat:(CMFormatDescriptionRef)formatRef;
@end


@interface NMLRPStreamNode : NSObject<NSSecureCoding>
@property (nonatomic) NMLRPStreamFormat *format;

- (instancetype)initWithStreamData:(NSData *)streamData format:(CMFormatDescriptionRef)formatRef;

- (CMSampleBufferRef)getSampleBuffer;
@end

NS_ASSUME_NONNULL_END
