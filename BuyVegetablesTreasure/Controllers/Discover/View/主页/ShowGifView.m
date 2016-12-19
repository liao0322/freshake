//
//  ShowGifView.m
//  BuyVegetablesTreasure
//
//  Created by Linf on 15/10/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "ShowGifView.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/CoreAnimation.h>
#import <AVFoundation/AVFoundation.h>

void getFrameInfo(CFURLRef url, NSMutableArray *frames, NSMutableArray *delayTimes, CGFloat *totalTime)
{
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(url, NULL);
    
    size_t frameCount = CGImageSourceGetCount(gifSource);
    for (size_t i = 0; i < frameCount; ++i) {
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:(__bridge id)frame];
        CGImageRelease(frame);
        
        NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime]];
        
        
        if (totalTime) {
            *totalTime = *totalTime + [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime] floatValue];
        }
    }
}
@interface ShowGifView() {
    NSMutableArray *_frames;
    NSMutableArray *_frameDelayTimes;
    
    CGFloat _totalTime;
    
    AVAudioPlayer *_audioPlayer;
    AVAudioPlayer *_mp3Player;
    
}

@end

@implementation ShowGifView

- (id)initWithFrame:(CGRect)frame fileURL:(NSURL *)fileURL;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _frames = [[NSMutableArray alloc] init];
        _frameDelayTimes = [[NSMutableArray alloc] init];
        
        if (fileURL) {
            getFrameInfo((__bridge CFURLRef)fileURL, _frames, _frameDelayTimes, &_totalTime);
        }
        _gifView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _gifView.hidden=YES;
        _gifImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _gifImageView.image=[UIImage imageWithCGImage:(CGImageRef)_frames[0]];
        [self addSubview:_gifImageView];
        [self addSubview:_gifView];
        
    }
    return self;
}

+ (NSArray*)framesInGif:(NSURL *)fileURL
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *delays = [NSMutableArray arrayWithCapacity:3];
    
    getFrameInfo((__bridge CFURLRef)fileURL, frames, delays, NULL);
    
    return frames;
}

- (void)startGif
{
    _playStr=@"1";
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"warning2.wav" withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [_audioPlayer prepareToPlay];
    //4.播放
    [_audioPlayer play];
    
    _gifView.hidden=NO;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:3];
    CGFloat currentTime = 0;
    int count =(int)_frameDelayTimes.count;
    for (int i = 0; i < count; ++i) {
        [times addObject:[NSNumber numberWithFloat:(currentTime / _totalTime)]];
        currentTime += [[_frameDelayTimes objectAtIndex:i] floatValue];
    }
    [animation setKeyTimes:times];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < count; ++i) {
        [images addObject:[_frames objectAtIndex:i]];
    }
    
    [animation setValues:images];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = _totalTime;
    animation.delegate = self;
    animation.repeatCount = 3;
    
    [_gifView.layer addAnimation:animation forKey:@"gifAnimation"];
    
    
    //播放音频
    // 路径
    NSString *string = [[NSBundle mainBundle] pathForResource:@"Rock" ofType:@"mp3"];
    NSURL *urling = [NSURL fileURLWithPath:string];
    
    //初始化音频类 并且添加播放文件
    _mp3Player = [[AVAudioPlayer alloc] initWithContentsOfURL:urling error:nil];
    
    [_mp3Player play];
}

- (void)stopGif
{
    _playStr=@"0";
    [_audioPlayer stop];
    _gifView.hidden=YES;
    [_gifView.layer removeAllAnimations];
    _GifStop();
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self stopGif];
}


@end
