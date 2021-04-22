//
//  ServiceSocketConnect.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/22.
//

#import "ServiceSocketConnect.h"
#define LOCK(BLOCK) [self _lock:^BLOCK];

@interface ServiceSocketConnect ()

@property (nonatomic) NSDictionary *currentHeader; //头信息，下一个数据按这个头来拆
@property (nonatomic) NSMutableData *cache; //缓存的数据

@property (nonatomic, strong) NSLock *handlerLock;

@end

@implementation ServiceSocketConnect

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.handlerLock = [NSLock new];
        self.cache = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)receiveData:(NSData *)data withTag:(long)tag{
        
    if (self.currentHeader) {
      //读数据
        NSUInteger totalLength = [[self.currentHeader objectForKey:@"length"] unsignedIntegerValue];
        NSUInteger lengthToReceive = totalLength - self.cache.length;
        if (data.length > lengthToReceive) {
            //数据长度超过header定义的长度，拼接
            NSData *body = [data subdataWithRange:NSMakeRange(0, lengthToReceive)];
            [self.cache appendData:body];

            //拼接完了取剩下数据作为header
            NSData *nextHeaderData = [data subdataWithRange:NSMakeRange(lengthToReceive, data.length - lengthToReceive)];
            NSError *err;
            NSDictionary *header = [NSJSONSerialization JSONObjectWithData:nextHeaderData options:NSJSONReadingMutableContainers error:&err];
            if (err) {
                NSLog(@"%@",err);
                NSAssert(NO, @"error by load next header");
            }
            self.currentHeader = header;
        } else {

            //没那么长，直接拼接
            [self.cache appendData:data];
        }

        
        if (totalLength == self.cache.length) {
            //长度足够
            if ([self.delegate respondsToSelector:@selector(socketConnect:receiveData:)]) {
                [self.delegate socketConnect:self receiveData:self.cache];
            }
            self.cache = [NSMutableData new];
        }
        
    } else {
        NSError *err;
        NSDictionary *header = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        self.currentHeader = header;
        if (err) {
            NSAssert(NO, @"error by load first header");
        }
    }

    //------
    
    NSString *feedbackString = @"back";
    // 响应给客户端的数据
    [self.clientSocket writeData:[feedbackString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

@end
