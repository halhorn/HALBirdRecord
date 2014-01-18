//
//  HALBirdRecordTableViewCell.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/15.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALBirdRecordTableViewCell.h"

@interface HALBirdRecordTableViewCell()<UITextFieldDelegate>

@property(nonatomic) HALBirdRecord *birdRecord;

@end

@implementation HALBirdRecordTableViewCell

static NSDateFormatter *dateFormatter;

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
    self.birdImageView.userInteractionEnabled = YES;
    self.birdKindLabel.textColor = kHALTextColor;
    self.datetimeLabel.textColor = kHALSubTextColor;
    self.commentLabel.textColor = kHALSubTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView:(HALBirdRecord *)birdRecord
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd HH:mm:ss";
    }
    self.birdImageView.image = birdRecord.kind.image;
    self.birdKindLabel.text = birdRecord.kind.name;
    self.datetimeLabel.text = [dateFormatter stringFromDate:birdRecord.datetime];
    self.commentLabel.text = birdRecord.comment;
    self.birdRecord = birdRecord;
}

+ (NSString *)cellIdentifier
{
    return @"HALBirdRecordTableViewCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"HALBirdRecordTableViewCell" bundle:nil];
}

- (IBAction)onCommentEditingDone:(id)sender {
    self.birdRecord.comment = self.commentLabel.text;
    [self.birdRecord updateDB];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

@end
