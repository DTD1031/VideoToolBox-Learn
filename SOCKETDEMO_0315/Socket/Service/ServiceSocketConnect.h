//
//  ServiceSocketConnect.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/22.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>

NS_ASSUME_NONNULL_BEGIN

@class ServiceSocketConnect;
@protocol ServiceSocketConnectDelegate <NSObject>
///获取到新的数据
- (void)socketConnect:(ServiceSocketConnect *)connect receiveData:(NSData *)data;
@end

@interface ServiceSocketConnect : NSObject

@property (nonatomic, weak) id <ServiceSocketConnectDelegate> delegate;

@property (nonatomic) GCDAsyncSocket *serviceSocket;
@property (nonatomic) GCDAsyncSocket *clientSocket;

- (void)receiveData:(NSData *)data withTag:(long)tag;


@end

NS_ASSUME_NONNULL_END
