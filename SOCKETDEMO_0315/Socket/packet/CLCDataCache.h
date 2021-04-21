//
//  CLCDataCache.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 施工方案：data 长度一致时减少init开销
 */
@interface CLCDataCache : NSObject

- (void)appendData:(NSData *)data;
- (void)cleanCache;
- (NSData *)outputData;
- (NSUInteger)length;
@end

NS_ASSUME_NONNULL_END
