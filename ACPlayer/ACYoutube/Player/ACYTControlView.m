//
//  ACYTControlView.m
//  ACPlayer
//
//  Created by alan on 2015/4/23.
//  Copyright (c) 2015年 alan. All rights reserved.
//

#import "ACYTControlView.h"
#import "ACConstraintHelper.h"

float kButtonW = 40.0;
float kButtonH = 40.0;

@interface ACYTControlView ()<UIGestureRecognizerDelegate>

@property (nonatomic) BOOL show;

@property (nonatomic,strong) UITapGestureRecognizer *tapG;

@end

@implementation ACYTControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:self.bgView];
        
        self.titleLabel = [self addLabel];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.numberOfLines = 2;
        
        
        self.nextBtn = [self addButtonWithImage:@"yt_next" selectImage:nil];
        self.preBtn = [self addButtonWithImage:@"yt_previous" selectImage:nil];
        
        self.playBtn = [self addButtonWithImage:@"yt_play" selectImage:@"yt_pause"];
        self.expandBtn = [self addButtonWithImage:@"yt_expand" selectImage:@"yt_compress"];
        
        self.hdBtn = [self addButtonWithImage:@"yt_hd_on" selectImage:@"yt_hd_off"];
        
        self.closeBtn = [self addButtonWithImage:@"yt_close" selectImage:nil];
        
        self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
        [self.slider setContinuous:NO];
        [self.bgView addSubview:self.slider];
        
        [self addConstraints];
        
        self.tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        self.tapG.delegate = self;
        [self addGestureRecognizer:self.tapG];
    }
    
    return self;
}

-(UIButton *)addButtonWithImage:(NSString *)imageName selectImage:(NSString *)selectImageName
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    if(selectImageName)
        [btn setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];

    [self.bgView addSubview:btn];
        
    btn.frame = CGRectMake(0, 0, kButtonW, kButtonH);
    
    return btn;
}

-(UILabel *)addLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 1;
    [self.bgView addSubview:label];
    
    return label;
}

-(void)tapped:(UITapGestureRecognizer *)g
{
    CGPoint touchPoint = [g locationInView: self];
    
    if(CGRectContainsPoint(self.slider.frame, touchPoint)){
        return;
    }
    
    if(self.show)
        [self hideWithAnimation:YES];
    else
        [self showWithAnimation:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
    CGPoint touchPoint = [gestureRecognizer locationInView: self];
    
    if(gestureRecognizer==self.tapG && CGRectContainsPoint(self.slider.frame, touchPoint))
        return NO;
    
    return YES;
}


#pragma  mark - Public

-(void)showWithAnimation:(BOOL)animation
{
    __weak __typeof(self)weakSelf = self;
    [self.bgView.layer removeAllAnimations];
    
    self.show  = YES;
    
    if(!animation){
        weakSelf.bgView.alpha = 1.0;
        return ;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
       
        weakSelf.bgView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideWithAnimation:(BOOL)animation
{
    __weak __typeof(self)weakSelf = self;
    [self.bgView.layer removeAllAnimations];
    
    self.show  = NO;
    
    if(!animation){
        weakSelf.bgView.alpha = 0.0;
        return ;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.bgView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setSliedrValue:(float)value
{
    if(self.slider.state == UIGestureRecognizerStatePossible && self.slider.state !=UIControlEventValueChanged)
        self.slider.value = value;
}

#pragma  mark - Layout

-(void)addConstraints
{
    [self.bgView    setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.playBtn   setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.nextBtn   setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.preBtn    setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.expandBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.hdBtn     setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.closeBtn     setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.slider    setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSDictionary *metrics = @{@"space": @10,
                              @"space2x": @40,
                              @"buttonW": @(kButtonW),
                              @"buttonH": @(kButtonH)};
    
    NSDictionary *views = @{@"title": self.titleLabel,
                            @"play": self.playBtn,
                            @"next": self.nextBtn,
                            @"pre": self.preBtn,
                            @"expand": self.expandBtn,
                            @"hd": self.hdBtn,
                            @"close": self.closeBtn,
                            @"slider": self.slider};
    
    
    NSMutableArray *myConstraints = [NSMutableArray array];
    [myConstraints addObjectsFromArray:[ACConstraintHelper constraintCenter:self.bgView with:self]];
    [myConstraints addObjectsFromArray:[ACConstraintHelper constraintSize:self.bgView with:self]];
    [self addConstraints:myConstraints];
    
    NSMutableArray *myConstraint2 = [NSMutableArray array];
    [myConstraint2 addObject:[ACConstraintHelper constraintCenterX:self.playBtn with:self.bgView]];
    [myConstraint2 addObject:[ACConstraintHelper constraintCenterY:self.playBtn with:self.bgView]];
    [myConstraint2 addObject:[ACConstraintHelper constraintCenterY:self.nextBtn with:self.playBtn]];
    [myConstraint2 addObject:[ACConstraintHelper constraintCenterY:self.preBtn with:self.playBtn]];
    
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-(>=space2x)-[play(buttonW)]-(>=space2x)-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];

    
    NSString *format = @"H:|-(>=space2x)-[pre(buttonW)]-(space2x)-[play(buttonW)]-(space2x)-[next(buttonW)]-(>=space2x)-|";
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:format
                                        options:0
                                        metrics:metrics
                                        views:views]];

    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-(>=space2x)-[play(buttonH)]-(>=space2x)-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
    
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-(>=space2x)-[expand(buttonH)]-(space)-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
    
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-(>=space2x)-[hd(buttonH)]-(space)-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
    
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-(20)-[title(40)]-(>=space)-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
    
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-(>=space2x)-[slider(>=140)]-80-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
    
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-(>=space2x)-[expand(buttonW)]-(space)-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
    
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-(space)-[hd(buttonW)]-(>=space)-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
    
    [myConstraint2 addObjectsFromArray:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-(60)-[title(>=100)]-(60)-|"
                                        options:0
                                        metrics:metrics
                                        views:views]];
    
    [myConstraint2 addObject:[ACConstraintHelper constraintHeight:self.nextBtn  with:self.playBtn]];
    [myConstraint2 addObject:[ACConstraintHelper constraintHeight:self.preBtn   with:self.playBtn]];
    [myConstraint2 addObject:[ACConstraintHelper constraintHeight:self.expandBtn   with:self.playBtn]];

    [myConstraint2 addObject:[ACConstraintHelper constraintCenterY:self.slider  with:self.expandBtn]];
    [myConstraint2 addObject:[ACConstraintHelper constraintCenterX:self.slider  with:self.bgView]];
    
    [myConstraint2 addObjectsFromArray:[ACConstraintHelper constraintSize:self.closeBtn with:self.expandBtn]];
    [myConstraint2 addObject:[ACConstraintHelper constraintCenterY:self.closeBtn  with:self.titleLabel]];
    [myConstraint2 addObject:[ACConstraintHelper alignLeft:self.closeBtn with:self.hdBtn]];

    [self.bgView addConstraints:myConstraint2];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}


@end
