//
//  ACParallaxTableViewCell.m
//  Ataturk 365 Gun
//
//  Created by Arda Cicek on 27/03/15.
//  Copyright (c) 2015 Arda Cicek. All rights reserved.
//
#import "AC.h"
#import "ACParallaxTableViewCell.h"

@implementation ACParallaxTableViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)prepareForReuse {
//    [_parallaxImage setAlignment:UIImageViewAlignmentMaskCenter];
}

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view
{
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.parallaxImage.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.parallaxImage.frame;
    imageRect.origin.y = (-(difference/2)+move)*2/5;
    
//    DDLogDebug(@"Original:%f / New:%f", _parallaxImage.frame.origin.y, imageRect.origin.y);

    self.parallaxImage.frame = imageRect;
}

@end
