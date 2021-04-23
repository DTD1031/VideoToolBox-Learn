//
//  CLCLocalSocketDispatch.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/23.
//

#import "CLCLocalSocketDispatch.h"

@interface CLCSocketHostHandlerList : NSObject

@property (nonatomic) NSHashTable *handlers;
@end

@implementation CLCSocketHostHandlerList
- (instancetype)init {
    self = [super init];
    if (self) {
        self.handlers = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}
@end

@implementation CLCLocalSocketHandler

@end

@interface CLCLocalSocketDispatch ()

@property (nonatomic) NSMutableDictionary <NSString * ,CLCSocketHostHandlerList *>*handlerList;
@end

@implementation CLCLocalSocketDispatch

- (instancetype)init {
    self = [super init];
    if (self) {
        self.handlerList = @{}.mutableCopy;
    }
    return self;
}

///记录
- (CLCLocalSocketHandler *)registerAction:(CLCLocalSocketHandlerBlock)block connectId:(NSString *)connectId {
    
    if (!block || !connectId) {
        return nil;
    }
    
    CLCLocalSocketHandler *handler = [CLCLocalSocketHandler new];
    handler.handler = block;

    //记录receiver对应的connectId，收到数据后对应处理
    if ([self.handlerList objectForKey:connectId]) {
        CLCSocketHostHandlerList *handlerList = [self.handlerList objectForKey:connectId];
        [handlerList.handlers addObject:handler];
    } else {
        CLCSocketHostHandlerList *handlerList  = [[CLCSocketHostHandlerList alloc] init];
        [handlerList.handlers addObject:handler];
        [self.handlerList setObject:handlerList forKey:connectId];
    }
    
    return handler;
}

- (void)receiveData:(NSData *)data userInfo:(NSDictionary *)userInfo connectId:(NSString *)connectId {
    if (data.length == 0 || connectId.length == 0) {
        return;
    }
    
    //事件分发
    CLCSocketHostHandlerList *handlerList = [self.handlerList objectForKey:connectId];
    if (handlerList) {
        for (CLCLocalSocketHandler *handlerNode in handlerList.handlers) {
            if (handlerNode.handler) {
                handlerNode.handler(data, userInfo);
            }
        }
    }
}

@end
