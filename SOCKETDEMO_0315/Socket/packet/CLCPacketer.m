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

+ (NSData *)packetData:(NSData *)data {
    
    if (data.length == 0) {
        return data;
    }
    
    NSUInteger size = data.length;
    
    NSDictionary *header = @{
        @"length":@(size)
    };
    
    NSData *headerData = [NSJSONSerialization dataWithJSONObject:header options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableData *packet = [NSMutableData dataWithData:headerData];
    [packet appendData:[GCDAsyncSocket CRLFData]];
    [packet appendData:data];
    
    return packet;
}

@end
