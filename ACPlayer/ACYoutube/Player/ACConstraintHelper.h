//
//  ACConstraintHelper.h
//  ACPlayer
//
//  Created by alan on 2015/4/23.
//  Copyright (c) 2015年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACConstraintHelper : NSObject

+(NSLayoutConstraint *)constraintCenterX:(id)v1 with:(id)v2;

+(NSLayoutConstraint *)constraintCenterY:(id)v1 with:(id)v2;

+(NSLayoutConstraint *)constraintHeight:(id)v1 with:(id)v2;

+(NSLayoutConstraint *)constraintWidth:(id)v1 with:(id)v2;

+(NSLayoutConstraint *)constraintWidthAsSameAsHeight:(id)v1;

+(NSLayoutConstraint *)constraintHeightAsSameAsWidth:(id)v1;

+(NSMutableArray *)constraintFrame:(id)v1 with:(id)v2;

+(NSMutableArray *)constraintSize:(id)v1 with:(id)v2;

+(NSMutableArray *)constraintCenter:(id)v1 with:(id)v2;

+(NSArray *)constraintWidthFormat:(NSString *)format metrics:(id)metrics views:(id)views;

#pragma  mark - Align

+(NSLayoutConstraint *)alignTop:(id)v1 with:(id)v2;

+(NSLayoutConstraint *)alignBottom:(id)v1 with:(id)v2;

+(NSLayoutConstraint *)alignLeft:(id)v1 with:(id)v2;

+(NSLayoutConstraint *)alignRight:(id)v1 with:(id)v2;

+(NSLayoutConstraint *)alignTopOf:(id)v1 toBottomOf:(id)v2 space:(float)space;

+(NSLayoutConstraint *)alignLeftOf:(id)v1 toRightOf:(id)v2 space:(float)space;





@end
