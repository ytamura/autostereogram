//
//  StampManager.h
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/16.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StampManager : NSObject

@property NSMutableArray* stamps;

-(NSInteger)getClosestStampIndex:(CGPoint)touchLocation;

+(UILabel*)createMessageLabel:(NSString*)message withFont:(UIFont*)font;
@end
