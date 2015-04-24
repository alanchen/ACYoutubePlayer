//
//  YouTubeListTableCell.m
//  PetViewer
//
//  Created by alan on 13/10/21.
//  Copyright (c) 2013年 MoneyMan. All rights reserved.
//

#import "YouTubeListTableCell.h"
#import "ACConstraintHelper.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface YouTubeListTableCell()

@end

@implementation YouTubeListTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.iconImageView.backgroundColor = [UIColor blackColor];
        [self.iconImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.iconImageView setClipsToBounds:YES];
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setNumberOfLines:2];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.contentView addSubview:self.titleLabel];
        
        self.viewConuntLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.viewConuntLabel setTextColor:[UIColor grayColor]];
        [self.viewConuntLabel setBackgroundColor:[UIColor clearColor]];
        [self.viewConuntLabel setTextAlignment:NSTextAlignmentRight];
        [self.viewConuntLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.viewConuntLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.nameLabel setTextColor: [UIColor grayColor]];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.nameLabel];
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.durationLabel setTextColor:[UIColor whiteColor]];
        [self.durationLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [self.durationLabel setTextAlignment:NSTextAlignmentRight];
        [self.durationLabel setFont:[UIFont systemFontOfSize:12]];
        [self.iconImageView addSubview:self.durationLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.dateLabel setTextColor:[UIColor grayColor]];
        [self.dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.dateLabel setTextAlignment:NSTextAlignmentLeft];
        [self.dateLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.dateLabel];

        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addConstraints];
    }
    return self;
}

-(void)showData:(YouTubeVideoModel *)model
{
    self.model = model;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:nil];
   
    [self.titleLabel setText:model.title];
    [self.titleLabel sizeToFit];
    
    [self.viewConuntLabel setText:model.displayViewCount];
    [self.viewConuntLabel sizeToFit];

    [self.nameLabel setText: [NSString stringWithFormat:@"by %@", model.channelTitle]];
    [self.nameLabel sizeToFit];
    
    [self.durationLabel setText:model.displayDuration];
    [self.durationLabel sizeToFit];
    
    [self.dateLabel setText:model.displayDate];
    [self.dateLabel sizeToFit];
}

-(void)addConstraints
{
    [self.iconImageView     setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.titleLabel        setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewConuntLabel   setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.nameLabel         setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.durationLabel     setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.dateLabel         setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSDictionary *metrics = @{@"space": @10,
                              @"space2x": @20,
                              @"imgW": @(50),
                              @"imgH": @(50)};

    NSDictionary *views = @{@"imgView": self.iconImageView,
                            @"title": self.titleLabel,
                            @"viewcount": self.viewConuntLabel,
                            @"name": self.nameLabel,
                            @"duration": self.durationLabel,
                            @"date": self.dateLabel};
   
    NSMutableArray *myConstraints = [NSMutableArray array];
    
    
    [myConstraints addObject: [ACConstraintHelper constraintWidthAsSameAsHeight:self.iconImageView]];
    
    NSString *f = @"H:|-(space)-[imgView(>=imgH)]-(space)-[title(>=10)]-(space)-|";
    [myConstraints addObjectsFromArray: [ACConstraintHelper constraintWidthFormat:f
                                                                          metrics:metrics
                                                                            views:views]];
    
    NSString *f1 = @"H:|-(space)-[imgView(>=imgH)]-(space)-[name(>=10)]-(space)-|";
    [myConstraints addObjectsFromArray: [ACConstraintHelper constraintWidthFormat:f1
                                                                          metrics:metrics
                                                                            views:views]];
    
    NSString *f2 = @"H:|-(space)-[imgView(>=imgH)]-(space)-[date(>=10)]-(space)-|";
    [myConstraints addObjectsFromArray: [ACConstraintHelper constraintWidthFormat:f2
                                                                          metrics:metrics
                                                                            views:views]];
    
    //////////////////////////////////////////////////
    
    NSString *fv = @"V:|-(space)-[imgView(>=imgH)]-(space)-|";
    [myConstraints addObjectsFromArray: [ACConstraintHelper constraintWidthFormat:fv
                                                                          metrics:metrics
                                                                            views:views]];
    
    [myConstraints addObject: [ACConstraintHelper alignTop:self.titleLabel with:self.iconImageView]];

    [myConstraints addObject: [ACConstraintHelper alignTopOf:self.nameLabel toBottomOf:self.titleLabel space:3]];

    [myConstraints addObject: [ACConstraintHelper alignBottom:self.dateLabel with:self.iconImageView]];
    
    [myConstraints addObject: [ACConstraintHelper alignRight:self.viewConuntLabel with:self.titleLabel]];

    [myConstraints addObject: [ACConstraintHelper alignBottom:self.viewConuntLabel with:self.iconImageView]];
    
    [myConstraints addObject: [ACConstraintHelper alignBottom:self.durationLabel with:self.iconImageView]];
    
    [myConstraints addObject: [ACConstraintHelper alignRight:self.durationLabel with:self.iconImageView]];


    [self.contentView addConstraints:myConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
