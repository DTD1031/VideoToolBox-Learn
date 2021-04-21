//
//  CLCPlayer.h
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLCPlayer : UIView
- (void)receiveBuffer:(CVPixelBufferRef)pixelBuffer;
@end

NS_ASSUME_NONNULL_END
