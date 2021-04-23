//
//  ClientSocket.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClientSocket : NSObject

- (instancetype)initWithConnectId:(NSString *)connectId;

- (void)connectToServer;
- (void)sendData:(NSData *)data;
- (void)sendData:(NSData *)dataToSend userInfo:(NSDictionary * _Nullable)userInfo;

//overwrite it
- (void)sendComplete:(NSString *)feedback;
- (void)connectComplete:(BOOL)successed;

@end

NS_ASSUME_NONNULL_END
