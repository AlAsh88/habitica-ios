//
//  HRPGGemPurchaseView.m
//  Habitica
//
//  Created by Phillip Thelen on 06/10/16.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

#import "HRPGGemPurchaseView.h"
#import "HRPGPurchaseLoadingButton.h"
#import "Habitica-Swift.h"

@interface HRPGGemPurchaseView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *gemsLabel;
@property(nonatomic) void (^promoTapEvent)();

@end

@implementation HRPGGemPurchaseView

- (void)setGemAmount:(NSInteger)amount {
    self.amountLabel.text = [@(amount) stringValue];
    self.amountLabel.textColor = ObjcThemeWrapper.primaryTextColor;
    switch (amount) {
        case 4:
            self.imageView.image = [UIImage imageNamed:@"4_gems"];
            break;
        case 21:
            self.imageView.image = [UIImage imageNamed:@"21_gems"];
            break;
        case 42:
            self.imageView.image = [UIImage imageNamed:@"42_gems"];
            break;
        case 84:
            self.imageView.image = [UIImage imageNamed:@"84_gems"];
            break;
            
        default:
            break;
    }
    
    self.gemsLabel.text = objcL10n.gems;
    self.gemsLabel.textColor = ObjcThemeWrapper.primaryTextColor;
}

- (void)setPrice:(NSString *)price {
    [self.purchaseButton setText:price];
    self.purchaseButton.tintColor = ObjcThemeWrapper.backgroundTintColor;
}

- (void)setPurchaseTap:(void (^)(HRPGPurchaseLoadingButton *))purchaseTap {
    self.purchaseButton.onTouchEvent = purchaseTap;
}

@end
