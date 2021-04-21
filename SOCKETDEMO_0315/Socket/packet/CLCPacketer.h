//
//  CLCPacketer.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 施工方案：数据封包，数据头信息为
 {
    @"length":size
 }
 */
@interface CLCPacketer : NSObject

+ (NSData *)packetData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
