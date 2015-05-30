//
//  ACParallaxTableViewCell.h
//  Ataturk 365 Gun
//
//  Created by Arda Cicek on 27/03/15.
//  Copyright (c) 2015 Arda Cicek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImageViewAligned/UIImageViewAligned.h"
#import "Event.h"

@interface ACParallaxTableViewCell : UITableViewCell

@property (nonatomic, strong) Event *event;
@property (weak, nonatomic) IBOutlet UIImageViewAligned *parallaxImage;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBottomParaCellContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopParaCellContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consParaCenterToContentCenter;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;

@end
