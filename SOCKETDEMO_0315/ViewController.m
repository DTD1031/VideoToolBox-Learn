//
//  ViewController.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/3/15.
//

#import "ViewController.h"
#import "ReplaykitCodec.h"
#import "CLCPlayer.h"
#import "CLCHostReceiver.h"
#import "CLCVideoDecoder.h"
#import "CLCDecodeHelper.h"

@interface ViewController ()<CLCVideoDecoderHandlerDelegate>

@property (nonatomic, strong) CLCVideoDecoder *codec;
@property (nonatomic, strong) dispatch_queue_t decodeQueue;

@property (nonatomic) CLCPlayer *showView;

@property (nonatomic) CLCHostReceiver *receiver;

@property (nonatomic) CLCLocalSocketHandler *videoHandler;
@property (nonatomic) CLCLocalSocketHandler *audioHandler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置解码器
    self.codec = [[CLCVideoDecoder alloc] initWithVideoProvider:[[CLCDecodeHelper alloc] init]];
    self.codec.delegate = self;
    
    self.receiver = [[CLCHostReceiver alloc] init];
    
    __weak ViewController *weakSelf = self;
    
    //接受视频帧
    self.videoHandler = [self.receiver.dispatch registerAction:^(NSData * _Nonnull data, NSDictionary * _Nonnull userInfo) {
        __strong ViewController *strongSelf = weakSelf;
            NSLog(@"video comming!");
        [strongSelf.codec receiveData:data];
    } connectId:@"1001"];
    
    
    self.audioHandler = [self.receiver.dispatch registerAction:^(NSData * _Nonnull data, NSDictionary * _Nonnull userInfo) {
            NSLog(@"audio comming!");
    } connectId:@"1002"];
    
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

/// 处理解码后的数据
/// @param pixelBuffer 解码后的数据
- (void)didGetDecodeBuffer:(CVPixelBufferRef)pixelBuffer {
    
    [self.showView receiveBuffer:pixelBuffer];
}


@end
