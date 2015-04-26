//
//  ACYTControlView.h
//  ACPlayer
//
//  Created by alan on 2015/4/23.
//  Copyright (c) 2015年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACYTControlView : UIView

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UILabel  *titleLabel;
@property (nonatomic,strong)UIButton *nextBtn;
@property (nonatomic,strong)UIButton *preBtn;
@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,strong)UIButton *expandBtn;
@property (nonatomic,strong)UIButton *hdBtn;
@property (nonatomic,strong)UIButton *closeBtn;

@property (nonatomic,strong)UISlider *slider;


-(void)showWithAnimation:(BOOL)animation;

-(void)hideWithAnimation:(BOOL)animation;

-(void)setSliedrValue:(float)value;


@end
