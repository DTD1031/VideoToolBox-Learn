//
//  NMLRPStreamNode.m
//  Replaykit
//
//  Created by chenlecheng on 2021/3/22.
//

#import "NMLRPStreamNode.h"

@interface NMLRPStreamFormat ()
//<CMVideoFormatDescription 0x28386f420 [0x1ee8cdb20]> {
//    mediaType:'vide'
//    mediaSubType:'420f'
//    mediaSpecific: {
//        codecType: '420f'        dimensions: 886 x 1918
//    }
//    extensions: {{
//    CVBytesPerRow = 1348;
//    CVImageBufferChromaLocationBottomField = Left;
//    CVImageBufferChromaLocationTopField = Left;
//    CVImageBufferColorPrimaries = "ITU_R_709_2";
//    CVImageBufferTransferFunction = "IEC_sRGB";
//    CVImageBufferYCbCrMatrix = "ITU_R_709_2";
//    Version = 2;
//}}
//}

@property (nonatomic) UInt32 mediaType;
@property (nonatomic) UInt32 mediaSubType;
//@property (nonatomic) NSArray *mediaSpecific;
@property (nonatomic) NSDictionary *extensions;
@end

@implementation NMLRPStreamFormat
- (instancetype)initWithFormat:(CMFormatDescriptionRef)formatRef {
//    formatRef
    self = [super init];
    if (self) {

        [self loadDataWithFormat:formatRef];
    }
    return self;
}

- (void)loadDataWithFormat:(CMFormatDescriptionRef)formatRef {
    CFDictionaryRef cfDic = CMFormatDescriptionGetExtensions(formatRef);
    
    NSDictionary *dic = (__bridge NSDictionary *)cfDic;
    
    NSLog(@"for %@", dic); //附带信息
    
/*    for {
        CVBytesPerRow = 1348;
        CVImageBufferChromaLocationBottomField = Left;
        CVImageBufferChromaLocationTopField = Left;
        CVImageBufferColorPrimaries = "ITU_R_709_2";
        CVImageBufferTransferFunction = "IEC_sRGB";
        CVImageBufferYCbCrMatrix = "ITU_R_709_2";
        Version = 2;
    }
 */
    //类型信息
    UInt32 subType = CMFormatDescriptionGetMediaSubType(formatRef);
    UInt32 type = CMFormatDescriptionGetMediaSubType(formatRef);
    
    NSLog(@"%ui, %ui", subType, type);
    
    self.extensions = dic;
    self.mediaType = type;
    self.mediaSubType = subType;
    //fourcharcode = uint32 asc ==> 'avc1'
    
//    <CMVideoFormatDescription 0x283d2adc0 [0x1fb631b20]> {
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
}

- (void)encodeWithCoder:(NSCoder *)coder {
    //Encode properties, other class variables, etc
    [coder encodeObject:@(self.mediaType) forKey:@"mediaType"];
    [coder encodeObject:@(self.mediaSubType) forKey:@"mediaSubType"];
    [coder encodeObject:self.extensions?:@{} forKey:@"extensions"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {

    self = [super init];
    if (self) {
        self.mediaType = [[coder decodeObjectForKey:@"mediaType"] unsignedIntValue];
        self.mediaSubType = [[coder decodeObjectForKey:@"mediaSubType"] unsignedIntValue];
        self.extensions = [coder decodeObjectForKey:@"extensions"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

@interface NMLRPStreamNode ()

@property (nonatomic) NSData *frameData;
@property (nonatomic) NSDictionary *formatDict;

@end
@implementation NMLRPStreamNode
- (instancetype)initWithStreamData:(NSData *)streamData format:(CMFormatDescriptionRef)formatRef {
    self = [super init];
    if (self) {

        CFDictionaryRef cfDic = CMFormatDescriptionGetExtensions(formatRef);
        self.formatDict = (__bridge NSDictionary *)cfDic;
        NSLog(@"for! %@", self.formatDict); //附带信息
        self.frameData = streamData;
    }
    return self;
}

- (CMSampleBufferRef)getSampleBuffer {
    
    CVPixelBufferRef pixBuf;
//    CVReturn result = CVPixelBufferCreate(NULL, 886, 1918, self.format.mediaType, (__bridge CFDictionaryRef)self.format.extensions, &pixBuf);
//    if (result != kCVReturnSuccess) {
//        return nil;
//    }
//
//    pixelbuffer
#warning TODO:将data及format重新组装为samplebuffer
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.frameData forKey:@"frameData"];
    [coder encodeObject:self.formatDict forKey:@"format"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {

    self = [super init];
    if (self) {
        self.formatDict = [coder decodeObjectForKey:@"format"];
        self.frameData = [coder decodeObjectForKey:@"frameData"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
