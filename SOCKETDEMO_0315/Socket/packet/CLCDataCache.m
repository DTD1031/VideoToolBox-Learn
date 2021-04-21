//
//  CLCDataCache.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import "CLCDataCache.h"

@interface CLCDataCache ()

@property (nonatomic) NSUInteger maxLength;
@property (nonatomic) NSUInteger currentLength;
@property (nonatomic) NSMutableData *cacheData;
@end

@implementation CLCDataCache

- (instancetype)init {
    self = [super init];
    if (self){
        _maxLength = 0;
        _currentLength = 0;
        _cacheData = [NSMutableData new];
    }
    return self;
}

- (void)appendData:(NSData *)data {
    if (data.length == 0) return;
    if (data.length + _currentLength > _maxLength) {
        //拼接后长度出现历史最大值
        _maxLength = data.length + _currentLength;
        _currentLength += data.length;
        NSLog(@"[dcache> max up => %lu", (unsigned long)_maxLength);
        [self.cacheData appendData:data];
    } else {
        [self.cacheData replaceBytesInRange:NSMakeRange(_currentLength, data.length)
                                  withBytes:data.bytes
                                     length:data.length];
        _currentLength += data.length;
        NSLog(@"[dcache> current up => %lu", (unsigned long)_currentLength);
    }
}

- (void)cleanCache {
    NSLog(@"[dcache> Clean");
    [self.cacheData resetBytesInRange:NSMakeRange(0, self.maxLength)];
    _currentLength = 0;
}

- (NSData *)outputData {
    NSLog(@"[dcache> OUT PUT %lu",(unsigned long)_currentLength);
    if (self.maxLength == self.currentLength) {
        return self.cacheData;
    }
    return [self.cacheData subdataWithRange:NSMakeRange(0, self.currentLength)];
}

- (NSUInteger)length {
    return self.currentLength;
}
@end
