//
//  StampManager.m
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/16.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import "StampManager.h"

@implementation StampManager
-(id)init {
    self = [super init];
    if (self) {
        _stamps = [NSMutableArray new];
        return self;
    }
    return nil;
}

-(NSInteger)getClosestStampIndex:(CGPoint)touchLocation {
    NSInteger closestStampIndex = -1;
    float closestDistance = 10000.f;
    for (NSUInteger i=0; i<_stamps.count; i++) {
        UIImageView* s = [_stamps objectAtIndex:i];
        float distance = [StampManager distanceBtwnPt1:touchLocation andPt2:s.center];
        if (distance < closestDistance) {
            closestDistance = distance;
            closestStampIndex = i;
        }
    }
    return closestStampIndex;
}

#pragma mark Static Methods

+(float) distanceBtwnPt1:(CGPoint)point1 andPt2:(CGPoint)point2 {
    return (sqrtf(powf(point1.x-point2.x,2.f) + powf(point1.y - point2.y,2.f)));
}

+(UILabel *)createMessageLabel:(NSString *)message withFont:(UIFont *)font {
    CGFloat height = [self heightForFont:font withText:message];
    CGFloat width = [self widthForFont:font withText:message withHeight:height];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,width,height)];
    label.text = message;
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    [label setFont:font];
    return label;
}

//get expected height and width of label based on
//http://stackoverflow.com/questions/8796862/xcode-uilabel-auto-size-label-to-fit-text
+(CGFloat)heightForFont:(UIFont *)font withText:(NSString*)text
{
    CGSize maximumLabelSize     = CGSizeMake(290, FLT_MAX);
    CGSize expectedLabelSize    = [text sizeWithFont:font
                                   constrainedToSize:maximumLabelSize];
    
    return expectedLabelSize.height;
}

+(CGFloat)widthForFont:(UIFont *)font withText:(NSString*)text withHeight:(CGFloat)h {
    CGSize maximumLabelSize = CGSizeMake(9999,h);
    
    CGSize expectedLabelSize = [text sizeWithFont:font
                                       constrainedToSize:maximumLabelSize];
    return expectedLabelSize.width;
}
@end
