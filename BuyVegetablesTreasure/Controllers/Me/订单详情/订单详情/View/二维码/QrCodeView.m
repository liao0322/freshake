//
//  QrCodeView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/6.
//
//

#import "QrCodeView.h"
#import "QRCodeGenerator.h"

@interface QrCodeView ()

@property (nonatomic, strong) UIImageView *qrCodeImgView;

@end

@implementation QrCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    
        [self initQrcodeView];
    }
    return self;
}

- (void)initQrcodeView {

    _qrCodeImgView = [UIImageView new];
    _qrCodeImgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_qrCodeImgView];
}

- (void)setUrlString:(NSString *)urlString {
    
    UIImage *qrcodeImg = [QRCodeGenerator qrImageForString:urlString imageSize:ScreenWidth * 0.7];
    _qrCodeImgView.image = qrcodeImg;
    
    _qrCodeImgView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .heightIs(qrcodeImg.size.height)
    .widthEqualToHeight();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

@end
