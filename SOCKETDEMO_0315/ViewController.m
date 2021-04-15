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

@interface ViewController ()<ServiceSocketDelegate>

@property(strong, nonatomic) ServiceSocket *serviceSocket;
@property(strong, nonatomic) ClientSocket *clientSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serviceSocket = [[ServiceSocket alloc] init];
    self.serviceSocket.delegate = self;
    [self.serviceSocket startChatServer];
    
    
//    self.clientSocket = [[ClientSocket alloc] init];
//    [self.clientSocket connectToServer];
}

- (void)service:(ServiceSocket *)service receiveData:(NSData *)data {
    
    NSLog(@"rcv --> %ld", data.length);
    
    NSError *error;
    NMLRPStreamFormat *node = [NSKeyedUnarchiver unarchivedObjectOfClass:NMLRPStreamFormat.class fromData:data error:&error];
    if (!error) {
        NSLog(@"%@", node);
    } else {
        NSLog(@"error! %@", error);
    }
}
//
//2021-03-23 14:20:47.614985+0800 SOCKETDEMO_0315[1408:30171] error! Error Domain=NSCocoaErrorDomain Code=4864 "*** -[NSKeyedUnarchiver _initForReadingFromData:error:throwLegacyExceptions:]: incomprehensible archive (0xffffffe7, 0xffffffe7, 0xffffffe7, 0xffffffe7, 0xffffffe7, 0xffffffe8, 0xffffffe8, 0xffffffe8)" UserInfo={NSDebugDescription=*** -[NSKeyedUnarchiver _initForReadingFromData:error:throwLegacyExceptions:]: incomprehensible archive (0xffffffe7, 0xffffffe7, 0xffffffe7, 0xffffffe7, 0xffffffe7, 0xffffffe8, 0xffffffe8, 0xffffffe8)}

@end

//
//error! Error Domain=NSCocoaErrorDomain Code=4864 "value for key 'extensions' was of unexpected class 'NSDictionary (0x1e13831d8) [/System/Library/Frameworks/CoreFoundation.framework]'. Allowed classes are '{(
//    "NMLRPStreamFormat (0x1003c0548) [/private/var/containers/Bundle/Application/AD39D3BA-B2E4-474B-AEA5-41DA1C31BF64/SOCKETDEMO_0315.app]"
//)}'." UserInfo={NSDebugDescription=value for key 'extensions' was of unexpected class 'NSDictionary (0x1e13831d8) [/System/Library/Frameworks/CoreFoundation.framework]'. Allowed classes are '{(
//    "NMLRPStreamFormat (0x1003c0548)
