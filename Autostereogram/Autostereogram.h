//
//  Autostereogram.h
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/23.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Autostereogram : NSObject
@property UIImage* depthMap;

-(id)initWithDepthMap:(UIImage*)depthMap;
-(UIImage*)createAutostereogram:(BOOL)withDots;
@end
