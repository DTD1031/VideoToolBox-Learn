//
//  ViewController.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/15.
//

#import "ViewController.h"
#import "ServiceSocket.h"
#import "ClientSocket.h"
#import "NMLRPStreamNode.h"
#import "RongRTCVideoDecoder.h"
#import "ReplaykitCodec.h"

@interface DataCache : NSObject

@property (nonatomic) NSMutableData *cache;
@end

@implementation DataCache

- (instancetype)init {
    self = [super init];
    if (self){
        self.cache = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)receiveData:(NSData *)data {
    if (![self checkData]) {
        [self.cache appendData:data];
    }
}

- (BOOL)checkData {
    
    NSLog(@"rcv --> %ld", self.cache.length);
    
    NSError *error;
    NSSet *classSet = [NSSet setWithArray:@[[NSDictionary class],
                                            [NMLRPStreamFormat class],
                                            [NMLRPStreamNode class],
                                            [NSData class]]];

    NMLRPStreamNode *decodeNode = [NSKeyedUnarchiver unarchivedObjectOfClasses:classSet fromData:self.cache error:&error];

    if (!error) {
        NSLog(@"OK! --> %@", decodeNode);
    } else {
        NSLog(@"XXX --> %@", error);
    }
    
    if (!error) {
        self.cache = [NSMutableData new];
        [self output:decodeNode];
    }
    
    return nil == error;
    
}

- (void)output:(id)output {
    NSLog(@"out put --> %@",output);
}

@end

@interface ViewController ()<ServiceSocketDelegate, RongRTCCodecProtocol>

@property(strong, nonatomic) ServiceSocket *serviceSocket;
@property(strong, nonatomic) ClientSocket *clientSocket;

@property (nonatomic, strong) RongRTCVideoDecoder *codec;
@property (nonatomic, strong) dispatch_queue_t decodeQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codec = [[RongRTCVideoDecoder alloc] init];
    self.codec.delegate = self;
    RongRTCVideoEncoderSettings *settings = [ReplaykitCodec settings];
    _decodeQueue = dispatch_queue_create("com.Replaykit.decode.queue", DISPATCH_QUEUE_SERIAL);
    [self.codec configWithSettings:settings onQueue:_decodeQueue];
    
    self.serviceSocket = [[ServiceSocket alloc] init];
    self.serviceSocket.delegate = self;
    [self.serviceSocket startChatServer];
    
}


/*
 施工方案：
 
 问题：一个数据有2.6MB大小，不压缩很难，但应该试一试
 
 */
- (void)service:(ServiceSocket *)service receiveData:(NSData *)data {
    
    NSLog(@"rcv --> %ld", data.length);

    [self.codec decode:data];
//    NSError *error;
//    NSSet *classSet = [NSSet setWithArray:@[[NSDictionary class],
//                                            [NMLRPStreamFormat class],
//                                            [NMLRPStreamNode class],
//                                            [NSData class]]];
//
//    NMLRPStreamNode *decodeNode = [NSKeyedUnarchiver unarchivedObjectOfClasses:classSet fromData:data error:&error];
//
//    if (!error) {
//        NSLog(@"OK! --> %@", decodeNode);
//    } else {
//        NSLog(@"error! %@", error);
//    }
//    NSLog(@"OK!!!");
}

- (void)didGetDecodeBuffer:(CVPixelBufferRef)pixelBuffer {
    
    NSLog(@"[Did Decode]%@", pixelBuffer);
}


@end
