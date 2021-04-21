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
@property (nonatomic, readonly) NSDictionary *formatDict;
- (instancetype)initWithFormat:(CMFormatDescriptionRef)formatRef;
@end


@interface NMLRPStreamNode : NSObject<NSSecureCoding>

@property (nonatomic, readonly) NSDictionary *formatDict;

- (instancetype)initWithStreamData:(NSData *)streamData format:(CMFormatDescriptionRef)formatRef;

- (CMSampleBufferRef)getSampleBuffer;
@end

NS_ASSUME_NONNULL_END
