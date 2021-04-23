//
//  CLCPacketer.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/20.
//

#import "CLCPacketer.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@implementation CLCPacketer

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSData *)packetData:(NSData *)data userInfo:(NSDictionary * _Nullable)userInfo {
    
    if (data.length == 0) {
        return data;
    }
    
    NSUInteger size = data.length;
    
    NSMutableDictionary *header;
    if (userInfo) {
        header = userInfo.mutableCopy;
    } else {
        header = @{}.mutableCopy;
    }
    [header setObject:@(size) forKey:@"length"];
    
    NSData *headerData = [NSJSONSerialization dataWithJSONObject:header options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableData *packet = [NSMutableData dataWithData:headerData];
    [packet appendData:[GCDAsyncSocket CRLFData]];
    [packet appendData:data];
    
    return packet;
}

@end
