//
//  CLCPlayer.m
//  SOCKETDEMO_0315
//
//  Created by chenlecheng on 2021/4/21.
//

#import "CLCPlayer.h"
#import <AVKit/AVKit.h>


@interface CLCPlayer ()

@property (nonatomic) UIImageView *imageView;
@end

@implementation CLCPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}


- (void)receiveBuffer:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                       createCGImage:ciImage
                       fromRect:CGRectMake(0, 0,
                              CVPixelBufferGetWidth(pixelBuffer),
                              CVPixelBufferGetHeight(pixelBuffer))];

    UIImage *image = [UIImage imageWithCGImage:videoImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView setImage:image];
    });
    CGImageRelease(videoImage);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
