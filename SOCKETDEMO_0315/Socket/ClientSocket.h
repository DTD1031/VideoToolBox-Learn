//
//  ClientSocket.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClientSocket : NSObject

- (void)connectToServer;
- (void)sendData:(NSData *)data;


//overwrite it
- (void)sendComplete:(NSString *)feedback;
- (void)connectComplete:(BOOL)successed;

@end

NS_ASSUME_NONNULL_END
