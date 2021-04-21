//
//  ServiceSocket.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ServiceSocket;
@protocol ServiceSocketDelegate <NSObject>

- (void)service:(ServiceSocket *)service receiveData:(NSData *)data;

@end
@interface ServiceSocket : NSObject

@property (nonatomic, weak) id <ServiceSocketDelegate>delegate;
- (void)startService;
@end

NS_ASSUME_NONNULL_END
