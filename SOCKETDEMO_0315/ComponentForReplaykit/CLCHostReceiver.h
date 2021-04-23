//
//  CLCHostReceiver.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import "CLCDecoderProvideDelegate.h"
#import "CLCLocalSocketDispatch.h"

NS_ASSUME_NONNULL_BEGIN

/// 封装
@interface CLCHostReceiver : NSObject
///事件分发者
@property (nonatomic, readonly) CLCLocalSocketDispatch *dispatch;

- (instancetype)init;

/// 开始获取数据
- (void)start;

///停止获取数据
- (void)stop;
@end

NS_ASSUME_NONNULL_END

/*
 施工方案：多个receiver的处理方案
 
 1.每个connect追加一个connectId，打在socket的userinfo里，
 
 2.connect通过id选择 -> handler （预设，打开service前预设）
 
 3.分层，decode与getData分为上下层，老老实实的别粘在一起，gnmd
 
 4.音频视频的获取方式分别搭建两个上层decode层
 
 【业务】
 《decoder》
 《socket》
 《base-socket》
 */
