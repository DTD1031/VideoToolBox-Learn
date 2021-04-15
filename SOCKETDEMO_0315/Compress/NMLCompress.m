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
    
}
    

- (void)createSession {
//    OSStatus status = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, didCompressH264, (__bridge void *)(self),  &encodingSession);

    VTCompressionSessionRef encodingSession;
    OSStatus status = VTCompressionSessionCreate(NULL, //指定使用某个构造化器，默认传null
                                                 480, //width
                                                 640, //height
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
}

@end
