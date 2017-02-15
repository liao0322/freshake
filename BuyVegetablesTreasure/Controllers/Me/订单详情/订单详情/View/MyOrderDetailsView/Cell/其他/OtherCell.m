//
//  OtherCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/6.
//
//

#import "OtherCell.h"
#import "XFExpressDetailsViewController.h"


@interface OtherCell ()

@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *qrCodeImgView;

@end

@implementation OtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    // 订单状态
    self.stateLabel = [UILabel new];
    self.stateLabel.tag = 10;
    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textAlignment = NSTextAlignmentRight;
    [self.stateLabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth / 2];
    
    self.stateLabel.sd_layout
    .leftEqualToView(self.accessoryView)
    .topEqualToView(self.accessoryView)
    .heightIs(45);
    
    // 二维码
    UIImage *img = IMAGE(@"QrCode");;
    self.qrCodeImgView = [UIImageView new];
    self.qrCodeImgView.image = img;
    self.qrCodeImgView.userInteractionEnabled = YES;
    
    self.qrCodeImgView.sd_layout
    .leftEqualToView(self.accessoryView)
    .topEqualToView(self.accessoryView)
    .widthIs(img.size.width)
    .heightIs(img.size.height);
    
    [self setupAutoHeightWithBottomView:self.stateLabel bottomMargin:0];
}

- (void)setOrderModel:(MyOrderDetailsModel *)orderDetailsModel indexPath:(NSIndexPath *)indexPath {
    
    CGFloat point = 0;
    for (int i = 0; i < orderDetailsModel.list.count; i++) {
        NSDictionary *dic = orderDetailsModel.list[i];
        point += [dic[@"point"] floatValue];
    }
    
    self.orderDetailsModel = orderDetailsModel;
    self.stateLabel.textColor = [UIColor blackColor];
    self.accessoryView = self.stateLabel;
    self.imageView.image = nil;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LineColor.CGColor;
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont systemFontOfSize:13];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 订单
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 订单状态
        NSInteger status = [orderDetailsModel.status intValue];
        // 支付状态
        NSInteger paymentStatus = [orderDetailsModel.payment_status intValue];
        
        if (status == 1 && paymentStatus == 1) {
            _stateLabel.text = @"未支付";
        }
        else if (status == 1 && paymentStatus == 2) {
            _stateLabel.text = @"已支付";
        }
        else if (status == 2) {
            _stateLabel.text = @"待提货";
        }
        else if (status == 3) {
            _stateLabel.text = @"已提货";
        }
        else if (status == 4) {
            _stateLabel.text = @"已取消";
        }
        else {
            _stateLabel.text = @"售后中";
        }
        
        self.imageView.image = IMAGE(@"FSOrderDetail订单");
        self.textLabel.text = [NSString stringWithFormat:@"订单号: %@",orderDetailsModel.order_no];
    }
    // 到店自提
    else if (indexPath.section == 1 && indexPath.row == 0) {
        
        self.stateLabel.text = @"";
        self.imageView.image = IMAGE(@"FSOrderDetail送货上门");
        
        if ([orderDetailsModel.express_id intValue] == 1 && [orderDetailsModel.status intValue] != 4) {
            self.stateLabel.text = @"查看物流";
            self.stateLabel.textColor = [UIColor colorDomina];
            self.stateLabel.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewExpress)];
            [self.stateLabel addGestureRecognizer:tap];
            
            
            self.textLabel.text = @"送货上门";
            
        } else {
            self.textLabel.text = @"到店自提";
        }

    }
    // 提货码
    else if (indexPath.section == 3) {
        
        // 完成订单时显示提货码
        int status = [orderDetailsModel.status intValue];
        if (status == 2) {
            self.accessoryView = self.qrCodeImgView;
            self.textLabel.textColor = Color;
            self.textLabel.text = [NSString stringWithFormat:@"提货码: %@",orderDetailsModel.order_no];
        }
        else if (status == 1 && [orderDetailsModel.payment_status intValue] == 2) {
            self.textLabel.text = @"备货中...";
        }
        else {
            self.textLabel.text = @"无提货码...";
        }
    }
    // 发票
    else if (indexPath.section == 4) {
        
        if (indexPath.row == 0) {
            
            self.stateLabel.text = @"个人无明细";
            self.textLabel.text = @"发票信息";
            
            if (![Tools isBlankString:orderDetailsModel.InvoiceTitle]) {
                self.stateLabel.text = @"纸质发票";
            }
        }
        else if (indexPath.row == 1) {
            
            self.layer.borderWidth = 0;
            self.textLabel.text = @"发票抬头:";
            self.stateLabel.text = orderDetailsModel.InvoiceTitle;
        }
        else if (indexPath.row == 2) {
            
            self.textLabel.text = @"发票内容:";
            self.stateLabel.text = orderDetailsModel.InvoiceContent;
        }
    }
    // 支付信息
    else if (indexPath.section == 5) {
        
        // 去线
        if (indexPath.row % 2) {
            self.layer.borderWidth = 0;
        }
        
        // 支付信息
        NSArray *arr;
        if ([orderDetailsModel.payment_status integerValue] == 2) {
            arr = @[@"运费:",@"合计:",@"使用优惠券:",@"积分抵扣:",@"实付:",@"支付方式:"];
        }
        else {
            arr = @[@"运费:",@"合计:",@"使用优惠券:",@"积分抵扣:",@"应付:"];
        }
        
        // 价格
        NSArray *priceArray = @[orderDetailsModel.express_fee,
                                orderDetailsModel.order_amount,
                                orderDetailsModel.order_AwardAmount,
                                [NSString stringWithFormat:@"%.2f",[orderDetailsModel.point floatValue] / 100],
                                orderDetailsModel.payable_amount,
                                orderDetailsModel.payment_id];
        
        if (indexPath.row == 5) {
        
            // 判断支付方式
            NSString *paymentString = @"";
            int paymentId = [orderDetailsModel.payment_id intValue];
            if (paymentId == 2) {
                paymentString = @"余额支付";
            }
            else if (paymentId == 3) {
                paymentString = @"支付宝支付";
            }
            else if (paymentId == 4) {
                paymentString = @"微信支付";
            }
            else if (paymentId == 6) {
                paymentString = @"HD支付宝支付";
            }
            else if (paymentId == 5) {
                paymentString = @"HD微信支付";
            }
            
            self.stateLabel.text = paymentString;
        }
        else {
            
            CGFloat price = [priceArray[indexPath.row] floatValue];
            if (price > 0 && (indexPath.row == 2 || indexPath.row == 3)) {
                self.stateLabel.text = [NSString stringWithFormat:@"- ¥ %.2f", price];
            }
            else {
                self.stateLabel.text = [NSString stringWithFormat:@"¥ %.2f", price];
            }
            
        }

        self.stateLabel.textColor = [UIColor colorOrange];
        self.textLabel.text = arr[indexPath.row];
    }
    // 评价
    else if (indexPath.section == 6 && indexPath.row == 0) {
        
        self.textLabel.text = @"我的评价:";
        self.textLabel.textColor = Color;
    }
}

- (void)viewExpress {
    XFExpressDetailsViewController *viewExpressVC = [[XFExpressDetailsViewController alloc] initWithOriginalNo:self.orderDetailsModel.order_no];
    
    if (self.pushViewController) {
        self.pushViewController(viewExpressVC);
    }

}

@end
