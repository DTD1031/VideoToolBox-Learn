//
//  ServiceSocket.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import "ServiceSocketConnect.h"

NS_ASSUME_NONNULL_BEGIN

@class ServiceSocket;
@protocol ServiceSocketDelegate <NSObject>

///当有新的连接建立时，可以从这里进行参数及回调设置
- (void)service:(ServiceSocket *)service didCreateNewConnect:(ServiceSocketConnect *)connect;
@end

@interface ServiceSocket : NSObject

@property (nonatomic, weak) id <ServiceSocketDelegate>delegate;

- (void)startService;

- (void)closeService;

- (void)closeConnect:(ServiceSocketConnect *)connect;
@end

NS_ASSUME_NONNULL_END
