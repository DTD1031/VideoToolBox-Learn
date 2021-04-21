//
//  NMLCompress.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/15.
//

#import "NMLCompress.h"
#import <VideoToolbox/VideoToolbox.h>

@implementation NMLCompress

/*
 VTCOMPRE
 */

void didCompressH264 (void * CM_NULLABLE outputCallbackRefCon,
                      void * CM_NULLABLE sourceFrameRefCon,
                      OSStatus status,
                      VTEncodeInfoFlags infoFlags,
        CM_NULLABLE CMSampleBufferRef sampleBuffer) {
    //编码完成回调
    NSLog(@"didCompressH264 called with status %d infoFlags %d", (int)status, (int)infoFlags);
    if (status != 0) {
        return;
    }
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog(@"didCompressH264 data is not ready ");
        return;
    }
    
    NMLCompress* encoder = (__bridge NMLCompress*)outputCallbackRefCon;
    bool keyframe = !CFDictionaryContainsKey( (CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync); //kCMSampleAttachmentKey_NotSync => 用于判断是否是I帧

    // 判断当前帧是否为关键帧
    // 获取sps & pps数据
    if (keyframe) {
        //获取帧内信息
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,
                                                                                 0,
                                                                                 &sparameterSet,
                                                                                 &sparameterSetSize, &sparameterSetCount, 0 );


    }
}
    

- (void)createSession {
//    OSStatus status = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, didCompressH264, (__bridge void *)(self),  &encodingSession);
    CGFloat width = 480;
    CGFloat height = 640;
    
    VTCompressionSessionRef encodingSession;
    OSStatus status = VTCompressionSessionCreate(NULL, //指定使用某个构造化器，默认传null
                                                 width, //width
                                                 height, //height
                                                 kCMVideoCodecType_H264, //编码输出格式
                                                 NULL, //指定一个编码器，传NULL让系统自动选择
                                                 NULL, //指定一个缓冲区（pixel buffer pool）（复用，多次采用同一帧时高效处理 传NULL不指定
                                                 NULL, //指定某个构造器，创建编码后的数据对象，传NULL不指定
                                                 didCompressH264, //指定编码回调，当且仅当使用VTCompressionSessionEncodeFrameWithOutputHandler方法编码时可以传NULL
                                                 (__bridge void*)(self) //回调函数的自定义参数，这里把self抛过去接数据
                                                 , &encodingSession); //给一个指针去接创建完成的session
    
    if (status != 0) {
        //Error Happend
        NSAssert(0, @"错误发生于创建构造器");
        return;
    }
    
    // kVTCompressionPropertyKey_RealTime
    //实时传递
    VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
    // 设置关键帧（GOPsize)间隔
    int frameInterval = 24;
    CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
    VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
    
    //设置期望帧率
    int fps = 24;
    CFNumberRef  fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
    VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
    
    
    //设置码率，均值，单位是byte
    int bitRate = width * height * 3 * 4 * 8;
    CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
    VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
    
    //设置码率，上限，单位是bps
    int bitRateLimit = width * height * 3 * 4;
    CFNumberRef bitRateLimitRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateLimit);
    VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_DataRateLimits, bitRateLimitRef);
    
    //开始编码
    VTCompressionSessionPrepareToEncodeFrames(encodingSession);
}

@end
