//
//  ReplaykitSendSocket.m
//  Replaykit
//
//  Created by chenlecheng on 2021/3/16.
//

#import "ReplaykitSendSocket.h"
#import "NMLRPStreamNode.h"
#define LOCK(BLOCK) [self _lock:^BLOCK];

@interface ReplaykitSendSocket ()
@property (nonatomic) NSMutableArray *queue;
@property (nonatomic, strong) NSLock *updateLock;

@end

@implementation ReplaykitSendSocket

- (instancetype)init {
    if (self = [super init]) {
        self.queue = @[].mutableCopy;
        self.updateLock = [NSLock new];
    }
    return self;
}

- (void)sendSampleBuffer:(CMSampleBufferRef)source {
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(source);

    CMFormatDescriptionRef formatRef = CMSampleBufferGetFormatDescription(source);
    
    CVPixelBufferLockBaseAddress(imageBuffer,0);

    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    void *src_buff = CVPixelBufferGetBaseAddress(imageBuffer);

    NSData *data = [NSData dataWithBytes:src_buff length:bytesPerRow * height];

    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);

    NMLRPStreamNode *node = [[NMLRPStreamNode alloc] initWithStreamData:data format:formatRef];
    NSError *error;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:node requiringSecureCoding:YES error:&error];
    
    NSSet *classSet = [NSSet setWithArray:@[[NSDictionary class], [NMLRPStreamFormat class], [NMLRPStreamNode class]]];
    NMLRPStreamNode *decodeNode = [NSKeyedUnarchiver unarchivedObjectOfClasses:classSet fromData:archiveData error:&error];

    if (!error) {
        NSLog(@"unarch %@", decodeNode);
        [self appendData:archiveData];
    } else {
        NSLog(@"error! %@", error);
    }
}

- (void)appendData:(NSData *)dataToSend {
    
    LOCK({
        [self.queue addObject:dataToSend];
        NSLog(@"append -- %ld", self.queue.count);
    })
}

- (void)sendData {
    __block BOOL waitForData = NO;
    LOCK({
        if (self.queue.count > 0) {
            NSLog(@"dequeue -- %ld", self.queue.count);
            NSData *dataToSend = self.queue[0];
            [self sendData:dataToSend];
            [self.queue removeObjectAtIndex:0];
        } else {
            waitForData = YES;
        }
    });

    if (waitForData) {
        NSLog(@"wait -- ");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
