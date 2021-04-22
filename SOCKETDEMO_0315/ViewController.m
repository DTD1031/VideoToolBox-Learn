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
#import "CLCPlayer.h"
#import "CLCHostReceiver.h"
#import "CLCDecodeHelper.h"

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

@interface ViewController ()<CLCHostReceiverHandlerDelegate>

@property(strong, nonatomic) ServiceSocket *serviceSocket;

@property (nonatomic, strong) CLCDecodeHelper *codec;
@property (nonatomic, strong) dispatch_queue_t decodeQueue;

@property (nonatomic) CLCPlayer *showView;

@property (nonatomic) CLCHostReceiver *receiver;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置解码器
    self.codec = [[CLCDecodeHelper alloc] init];
    
    //创建获取类
    self.receiver = [[CLCHostReceiver alloc] initWithProvider:self.codec];
    self.receiver.delegate = self;
    
    //启动，开始获取数据
    [self.receiver start];
    
    [self createImageView];
}

- (void)createImageView {
    
    self.showView = [CLCPlayer new];
    CGFloat width = 100;
    CGFloat height = [UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width * width;
    self.showView.frame = CGRectMake(100, 100, width, height);
    
    [self.view addSubview:self.showView];
}

#pragma mark - CLCHostReceiverHandlerDelegate

/// 处理解码后的数据
/// @param pixelBuffer 解码后的数据
- (void)didGetDecodeBuffer:(CVPixelBufferRef)pixelBuffer {
    
    [self.showView receiveBuffer:pixelBuffer];
}


@end
