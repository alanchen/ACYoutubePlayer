//
//  ACConstraintHelper.m
//  ACPlayer
//
//  Created by alan on 2015/4/23.
//  Copyright (c) 2015年 alan. All rights reserved.
//

#import "ACConstraintHelper.h"

@implementation ACConstraintHelper

+(NSLayoutConstraint *)constraintCenterX:(id)v1 with:(id)v2
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1.f
                                         constant:0.f];
}

+(NSLayoutConstraint *)constraintCenterY:(id)v1 with:(id)v2
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1.f
                                         constant:0.f];
}

+(NSLayoutConstraint *)constraintHeight:(id)v1 with:(id)v2
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:1.f
                                         constant:0.f];
}

+(NSLayoutConstraint *)constraintWidth:(id)v1 with:(id)v2
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:1.f
                                         constant:0.f];
}

+(NSLayoutConstraint *)constraintHeightAsSameAsWidth:(id)v1
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v1
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:1.f
                                         constant:0.f];
}

+(NSLayoutConstraint *)constraintWidthAsSameAsHeight:(id)v1
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v1
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:1.f
                                         constant:0.f];
}


+(NSMutableArray *)constraintFrame:(id)v1 with:(id)v2
{
    NSMutableArray *myConstraints =[NSMutableArray array];
    
    [myConstraints addObject:[ACConstraintHelper constraintHeight:v1    with:v2]];
    [myConstraints addObject:[ACConstraintHelper constraintWidth:v1     with:v2]];
    [myConstraints addObject:[ACConstraintHelper constraintCenterX:v1   with:v2]];
    [myConstraints addObject:[ACConstraintHelper constraintCenterY:v1   with:v2]];
    
    return  myConstraints;
}

+(NSMutableArray *)constraintSize:(id)v1 with:(id)v2
{
    NSMutableArray *myConstraints =[NSMutableArray array];
    
    [myConstraints addObject:[ACConstraintHelper constraintHeight:v1    with:v2]];
    [myConstraints addObject:[ACConstraintHelper constraintWidth:v1     with:v2]];
    
    return  myConstraints;
}

+(NSMutableArray *)constraintCenter:(id)v1 with:(id)v2
{
    NSMutableArray *myConstraints =[NSMutableArray array];
    [myConstraints addObject:[ACConstraintHelper constraintCenterX:v1   with:v2]];
    [myConstraints addObject:[ACConstraintHelper constraintCenterY:v1   with:v2]];
    
    return  myConstraints;
}

+(NSArray *)constraintWidthFormat:(NSString *)format metrics:(id)metrics views:(id)views
{
    
    return  [NSLayoutConstraint constraintsWithVisualFormat:format
                                                    options:0
                                                    metrics:metrics
                                                      views:views];
}

#pragma  mark - Align

+(NSLayoutConstraint *)alignTop:(id)v1 with:(id)v2
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeTop
                                       multiplier:1.f
                                         constant:0.f];

}

+(NSLayoutConstraint *)alignBottom:(id)v1 with:(id)v2
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.f
                                         constant:0.f];
    
}

+(NSLayoutConstraint *)alignLeft:(id)v1 with:(id)v2
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeLeft
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeLeft
                                       multiplier:1.f
                                         constant:0.f];
}

+(NSLayoutConstraint *)alignRight:(id)v1 with:(id)v2
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.f
                                         constant:0.f];
}

+(NSLayoutConstraint *)alignTopOf:(id)v1 toBottomOf:(id)v2 space:(float)space
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                         constant:space];
}

+(NSLayoutConstraint *)alignLeftOf:(id)v1 toRightOf:(id)v2 space:(float)space
{
    return [NSLayoutConstraint constraintWithItem:v1
                                        attribute:NSLayoutAttributeLeft
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:v2
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.0
                                         constant:space];
}


@end
