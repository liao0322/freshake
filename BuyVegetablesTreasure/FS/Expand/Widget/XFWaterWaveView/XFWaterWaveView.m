//
//  XFWaterWaveView.m
//  ttttt
//
//  Created by DamonLiao on 2017/1/6.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFWaterWaveView.h"

@interface XFWaterWaveView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer *waveLayer;  // 绘制波形
@property (nonatomic, strong) CAGradientLayer *gradientLayer;   // 绘制渐变

@property (nonatomic, strong) NSArray *colors;  // 渐变的颜色数组
@property (nonatomic, assign) CGFloat percent;  // 波浪上升的比例

// 绘制波形的变量定义，使用波形曲线y=Asin(ωx+φ)+k进行绘制
@property (nonatomic, assign) CGFloat waveAmplitude;  // 波纹振幅，A
@property (nonatomic, assign) CGFloat waveCycle;      // 波纹周期，T = 2π/ω

@property (nonatomic, assign) CGFloat offsetX;        // 波浪x位移，φ
@property (nonatomic, assign) CGFloat waveSpeed;      // 波纹速度，用来累加到相位φ上，达到波纹水平移动的效果

@property (nonatomic, assign) CGFloat currentWavePointY;    // 当前波浪高度，k
@property (nonatomic, assign) CGFloat waveGrowth;     // 波纹上升速度，累加到k上，达到波浪高度上升的效果

@property (nonatomic, assign) BOOL bWaveFinished;   // 上升完成

// 用来计算波峰一定范围内的波动值
@property (nonatomic, assign) BOOL increase;

@property (nonatomic, assign) CGFloat variable;

@property (nonatomic) UIImageView *bgImageView;
@property (nonatomic) UIView *waveView;
@property (nonatomic) UIView *bgView;

@property (nonatomic) void(^finishedBlock)();

@end

@implementation XFWaterWaveView

static const CGFloat kExtraHeight = 20.0f;     // 保证水波波峰不被裁剪，增加部分额外的高度

static const CGFloat kHudSize = 100.0f;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        [self defaultConfig];
        [self addSubview:self.bgView];
        [self addSubview:self.waveView];
        
        self.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:.0];

    }
    return self;
}

- (void)setGrowthSpeed:(CGFloat)growthSpeed {
    self.waveGrowth = growthSpeed;
}

- (void)defaultConfig {
    // 默认设置一些属性
    self.waveCycle = 1.66 * M_PI / kHudSize;     // 影响波长
    self.currentWavePointY = kHudSize * self.percent;       // 波纹从下往上升起
    
    self.waveGrowth = 1.0;
    self.waveSpeed = 0.4 / M_PI;
    
    self.offsetX = 0;
}

- (void)resetProperty {
    // 重置属性
    self.currentWavePointY = kHudSize * self.percent;
    self.offsetX = 0;
    
    self.variable = 1.6;
    self.increase = NO;
}

- (void)resetLayer {
    // 动画开始之前重置layer
    if (self.waveLayer)
    {
        [self.waveLayer removeFromSuperlayer];
        self.waveLayer = nil;
    }
    self.waveLayer = [CAShapeLayer layer];
    
    self.waveLayer.fillColor = [UIColor colorWithRed:134/255.0f green:197/255.0f blue:59/255.0f alpha:1].CGColor;
    
    self.waveLayer.frame = [self gradientLayerFrame];
    [self.waveView.layer addSublayer:self.waveLayer];
    
    [self addSubview:self.bgImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 0, 120, 120);
    self.bgView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    
    self.waveView.frame = CGRectMake(0, 0, kHudSize, kHudSize);
    self.waveView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    self.bgImageView.frame = CGRectMake(0, 0, kHudSize, kHudSize);
    self.bgImageView.center = self.waveView.center;
    
}

- (CGRect)gradientLayerFrame {
    CGFloat gradientLayerHeight = kHudSize * self.percent + kExtraHeight;
    if (gradientLayerHeight > kHudSize)
    {
        gradientLayerHeight = kHudSize;
    }
    CGRect frame = CGRectMake(0, kHudSize - gradientLayerHeight, kHudSize, gradientLayerHeight);
    return frame;
}



- (void)startWaveToPercent:(CGFloat)percent {
    self.percent = percent;
    
    [self resetProperty];
    [self resetLayer];
    
    if (self.displayLink)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    
    self.bWaveFinished = NO;
    
    // 启动同步渲染绘制波纹
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setCurrentWave:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)dismissWithCompletion:(void (^)())completion {
    self.percent = 1.0f;
    self.waveGrowth = 3.0f;
    self.waveLayer.frame = [self gradientLayerFrame];
    self.finishedBlock = completion;
}


 - (void)stopWave {
     [self.displayLink invalidate];
     self.displayLink = nil;
 }


- (void)setCurrentWave:(CADisplayLink *)displayLink {
    if ([self waveFinished]) {
        self.bWaveFinished = YES;
        //        [self amplitudeReduce];
        
        // 减小到0之后动画停止。
        if (self.waveAmplitude <= 0) {
            //            [self stopWave];
            return;
        }

        if (self.currentWavePointY <= 0) {
            [self stopWave];
            if (self.finishedBlock) {
                self.finishedBlock();
            }
        }

    } else {
        // 波浪高度未到指定高度 继续上涨
        [self amplitudeChanged];
        self.currentWavePointY -= self.waveGrowth;

    }
    
    self.offsetX += self.waveSpeed;
    [self setCurrentWaveLayerPath];
}

- (BOOL)waveFinished {
    // 波浪上升动画是否完成
    CGFloat d = kHudSize - CGRectGetHeight(self.waveLayer.frame);
    CGFloat extraH = MIN(d, kExtraHeight);
    BOOL bFinished = self.currentWavePointY <= extraH;
    
    return bFinished;
}

- (void)setCurrentWaveLayerPath {
    // 通过正弦曲线来绘制波浪形状
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat y = self.currentWavePointY;
    
    CGPathMoveToPoint(path, nil, 0, y);
    CGFloat width = kHudSize;
    for (float x = 0.0f; x <= width; x++) {
        // 正弦波浪公式
        y = self.waveAmplitude * sin(self.waveCycle * x + self.offsetX) + self.currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, width, kHudSize);
    CGPathAddLineToPoint(path, nil, 0, kHudSize);
    CGPathCloseSubpath(path);
    
    self.waveLayer.path = path;
    
    CGPathRelease(path);
    

}

- (void)amplitudeChanged {
    // 波峰在一定范围之内进行轻微波动
    
    // 波峰该继续增大或减小
    if (self.increase) {
        self.variable += 0.01;
    } else {
        self.variable -= 0.01;
    }
    
    // 变化的范围
    if (self.variable <= 1) {
        self.increase = YES;
    }
    
    if (self.variable >= 1.6) {
        self.increase = NO;
    }
    
    // 根据variable值来决定波峰
    self.waveAmplitude = self.variable * 5;
}

/*
 - (void)amplitudeReduce
 {
 // 波浪上升完成后，波峰开始逐渐降低
 self.waveAmplitude -= 0.066;
 }
 */
static XFWaterWaveView *loadingView = nil;

+ (void)showLoading {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    if (!loadingView) {
        loadingView = [[XFWaterWaveView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        loadingView.center = keyWindow.center;
    }
    [keyWindow addSubview:loadingView];
    [loadingView startWaveToPercent:0.5f];
}

+ (void)dismissLoading {
    if (!loadingView) {
        return;
    }
    [loadingView dismissWithCompletion:^{
        [UIView animateWithDuration:0.1f animations:^{
            loadingView.transform = CGAffineTransformScale(loadingView.transform, 0.7f, 0.7f);
        } completion:^(BOOL finished) {
            [loadingView removeFromSuperview];
            loadingView = nil;
        }];
    }];
}

+ (void)dismissWithCompletion:(void (^)())completion {
    loadingView.percent = 1.0f;
    loadingView.waveGrowth = 5.0f;
    loadingView.waveLayer.frame = [loadingView gradientLayerFrame];
    loadingView.finishedBlock = completion;
}

#pragma mark - LazyLoad

- (UIView *)waveView {
    if (!_waveView) {
        _waveView = [UIView new];
        _waveView.backgroundColor = [UIColor whiteColor];
        _waveView.layer.masksToBounds = YES;
    }
    return _waveView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:241/255.0f alpha:1];
        _bgView.layer.cornerRadius = 15.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"333"]];
    }
    return _bgImageView;
}


@end
