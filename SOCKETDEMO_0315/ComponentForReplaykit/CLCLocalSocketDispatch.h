//
//  CLCLocalSocketDispatch.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CLCLocalSocketHandlerBlock)(NSData *data, NSDictionary *userInfo);
@interface CLCLocalSocketHandler : NSObject
@property (nonatomic, strong) CLCLocalSocketHandlerBlock handler;
@end


/// 事件分发
@interface CLCLocalSocketDispatch : NSObject

- (CLCLocalSocketHandler *)registerAction:(CLCLocalSocketHandlerBlock)block
                                connectId:(NSString *)connectId;

- (void)receiveData:(NSData *)data
           userInfo:(NSDictionary *)userInfo
          connectId:(NSString *)connectId;
@end

NS_ASSUME_NONNULL_END
