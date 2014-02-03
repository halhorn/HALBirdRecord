//
//  HALNewActivityCell.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/25.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALNewActivityCell.h"
#import "HALActivityManager.h"
#import "HALAccount.h"

@interface HALNewActivityCell()
@property (weak, nonatomic) IBOutlet UILabel *createActivityLabel;
@property (weak, nonatomic) IBOutlet UIView *purchaseView;
@property (weak, nonatomic) IBOutlet UILabel *activityCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *donationMemberIcon;
@property (weak, nonatomic) IBOutlet UIImageView *proAccountIcon;
@property (weak, nonatomic) IBOutlet UIImageView *studentAccountIcon;

@property(nonatomic, copy) void(^tapPurchaseBlock)(void);

@end

@implementation HALNewActivityCell

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
    self.createActivityLabel.textColor = kHALTextColor;
    self.activityCountLabel.textColor = kHALSubTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier
{
    return @"HALNewActivityCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"HALNewActivityCell" bundle:nil];
}

- (void)loadWithTapPurchaseBlock:(void (^)(void))tapPurchaseBlock
{
    self.tapPurchaseBlock = tapPurchaseBlock;
    [self load];
}

- (void)load
{
    self.donationMemberIcon.hidden = YES;
    self.proAccountIcon.hidden = YES;
    self.purchaseView.hidden = YES;
    HALAccount *myAccount = [HALAccount myAccount];
    
    if ([myAccount isDonationMember]) {
        self.donationMemberIcon.hidden = NO;
    } else if ([myAccount isProAccount]) {
        self.proAccountIcon.hidden = NO;
    } else if([myAccount isStudentAccount]) {
        self.studentAccountIcon.hidden = NO;
    } else {
        HALActivityManager *activityManager = [HALActivityManager sharedManager];
        self.purchaseView.hidden = NO;
        self.activityCountLabel.text = [NSString stringWithFormat:@"(%d/%d)", activityManager.activityCount, activityManager.activityCapacity];
        if (activityManager.activityCapacity - activityManager.activityCount <= 1) {
            self.activityCountLabel.textColor = [UIColor redColor];
        } else {
            self.activityCountLabel.textColor = kHALTextColor;
        }
    }
}

- (IBAction)onTapPurchase:(id)sender {
    if (!self.tapPurchaseBlock) {
        return;
    }
    self.tapPurchaseBlock();
}

@end
