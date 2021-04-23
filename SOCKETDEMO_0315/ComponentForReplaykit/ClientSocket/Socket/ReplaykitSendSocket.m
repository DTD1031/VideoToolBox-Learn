//
//  ReplaykitSendSocket.m
//  Replaykit
//
//  Created by chenlecheng on 2021/3/16.
//

#import "ReplaykitSendSocket.h"
#import "LocalSocketDefine.h"
#define LOCK(BLOCK) [self _lock:^BLOCK];

@interface ReplaykitSendSocket ()
@property (nonatomic) NSMutableArray *queue;
@property (nonatomic, strong) NSLock *updateLock;

@end

@implementation ReplaykitSendSocket

- (instancetype)initWithConnectId:(NSString *)connectId {
    if (self = [super initWithConnectId:connectId]) {
        self.queue = @[].mutableCopy;
        self.updateLock = [NSLock new];
    }
    return self;
}

- (void)appendData:(NSData *)dataToSend {
    if (!dataToSend) {
        return;
    }
    
    NSDictionary *nodeToSend = @{
        LocalSocketSendNodeKeyData : dataToSend,
        LocalSocketSendNodeKeyUserInfo : self.userInfo ? : @{}
    };
    
    LOCK({
        [self.queue addObject:nodeToSend];
    });
}

- (void)sendData {
    __block BOOL waitForData = NO;
    LOCK({
        if (self.queue.count > 0) {
            NSDictionary *dataToSend = self.queue[0];
            [self sendData:dataToSend[LocalSocketSendNodeKeyData]
                  userInfo:dataToSend[LocalSocketSendNodeKeyUserInfo]];
            [self.queue removeObjectAtIndex:0];
        } else {
            waitForData = YES;
        }
    });

    if (waitForData) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendData];
        });
    }
}

- (void)_lock:(void(^)(void))block
{
    [_updateLock lock];
    if (block) block();
    [_updateLock unlock];
}

#pragma mark - super
- (void)sendComplete:(NSString *)feedback {
    [super sendComplete:feedback];
    
    [self sendData];
}

- (void)connectComplete:(BOOL)successed {
    [super connectComplete:successed];
    
    [self sendData];
}

#pragma mark - delegate
- (void)sendDecodeData:(NSData *)data {
    [self appendData:data];
}

@end
