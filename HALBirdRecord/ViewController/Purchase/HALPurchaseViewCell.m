//
//  HALPurchaseViewCell.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/26.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALPurchaseViewCell.h"
#import "HALProduct.h"

@interface HALPurchaseViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCommentLabel;


@end

@implementation HALPurchaseViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.productTitleLabel.textColor = kHALTextColor;
    self.productCommentLabel.textColor = kHALSubTextColor;
    self.priceLabel.textColor = kHALTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier
{
    return @"HALPurchaseViewCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"HALPurchaseViewCell" bundle:nil];
}

- (void)loadWithProductID:(NSString *)productID
{
    HALProduct *product = [HALProduct productWithProductID:productID];
    self.productTitleLabel.text = product.title;
    self.productCommentLabel.text = product.comment;
    self.iconView.image = product.image;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%d", product.price];
}

@end
