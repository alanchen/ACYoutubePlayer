//
//  YouTubeListTableCell.h
//  PetViewer
//
//  Created by alan on 13/10/21.
//  Copyright (c) 2013年 MoneyMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouTubeVideoModel.h"

@interface YouTubeListTableCell : UITableViewCell<UIActionSheetDelegate>

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *viewConuntLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *durationLabel;
@property (nonatomic,strong)UILabel *dateLabel;

@property (nonatomic,strong)YouTubeVideoModel *model;

-(void)showData:(YouTubeVideoModel *)model;

@end
