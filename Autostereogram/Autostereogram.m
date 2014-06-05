//
//  Autostereogram.m
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/23.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import "Autostereogram.h"

@interface Autostereogram()
@property int width;
@property int height;
@end

@implementation Autostereogram

const int DPI = 72;
const float mu = 1/3.0;
const int PIXEL_SIZE = 4;
-(int)E {
    return round(1.25*DPI);
}

-(id)initWithDepthMap:(UIImage *)depthMap {
    self = [super init];
    if (self) {
        _depthMap = depthMap;
        _width = depthMap.size.width;
        _height = depthMap.size.height;
        return self;
    }
    return nil;
}

//based on http://www.cs.waikato.ac.nz/~ihw/papers/94-HWT-SI-IHW-SIRDS-paper.pdf 
-(UIImage*)createAutostereogram:(BOOL)withDots {
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(_depthMap.CGImage));
    const UInt8* depthPixels = CFDataGetBytePtr(pixelData);
    UInt8* newPixels = malloc(sizeof(UInt8)*_width*_height*PIXEL_SIZE);
    
    int x,y;
    for (y=0; y<_height; y++) {
        int pix[_width];
        int same[_width];
        
        int s;
        int left, right;
        
        //link each pixel initially with itself
        for (x=0; x < _width; x++) {
            same[x] = x;
        }
        
        for (x=0; x < _width; x++) {
            float depth = [self getDepthFromX:x Y:y map:depthPixels];
            //NSLog([NSString stringWithFormat:@"%i,%i %f\n",x,y,depth]);
            s = [self separation:depth];
            left = x - s/2;
            right = left + s;
            if (0 <= left && right < _width) {
                int visible; //hidden-surface removal
                int t=1; //will check points (x-t,y) and (x+t,y)
                float zt; //z-coord of ray at these two points
                
                do {
                    float left_depth = [self getDepthFromX:x-t Y:y map:depthPixels];
                    float right_depth = [self getDepthFromX:x+t Y:y map:depthPixels];
                    zt = depth + 2*(2-mu*depth)*t/(mu*self.E);
                    visible = (left_depth<zt) && (right_depth<zt); //false if obscured
                    t++;
                } while (visible && zt < 1); //done hidden-surface removal
                
                if (visible) {
                    //record the fact that pixels at left and right are the same
                    int l = same[left];
                    //juggle pointers until either same[left]=left or same[left]=right
                    while (l != left && l != right) {
                        if (l < right) {
                            left = l;
                            l = same[left];
                        } else {
                            same[left] = right;
                            left = right;
                            l = same[left];
                            right = l;
                        }
                    }
                    //actually record
                    same[left] = right;
                }
            }
        }
        
        //set pixels on this scan line
        for (x=_width-1; x>=0; x--) {
            if (same[x] == x) {
                pix[x] = random()&1;
                //printf("%d ",pix[x]);
            } else {
                pix[x] = pix[same[x]];
                //pix[x] = 1;
                //printf("%d- ",pix[x]);
            }
            //NSLog([NSString stringWithFormat:@"%d ",pix[x]]);
            //set pixel of new image
            newPixels[PIXEL_SIZE*(x+y*_width)] = 255*pix[x]; //R
            newPixels[PIXEL_SIZE*(x+y*_width)+1] = 255*pix[x]; //G
            newPixels[PIXEL_SIZE*(x+y*_width)+2] = 255*pix[x]; //B
            newPixels[PIXEL_SIZE*(x+y*_width)+3] = 255; //alpha
        }
    }
    
    if (withDots) {
        [self drawCircleAtX:_width/2-[self separation:0]/2 Y:_height*19/20 p:newPixels];
        [self drawCircleAtX:_width/2+[self separation:0]/2 Y:_height*19/20 p:newPixels];
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,newPixels,_width*_height*4,NULL);

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef =
    CGImageCreate(_width,_height,8,8*PIXEL_SIZE,PIXEL_SIZE*_width,colorSpaceRef,bitmapInfo,provider,NULL,NO,renderingIntent);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
  
    return newImage;
}

-(void)drawCircleAtX:(int)x Y:(int)y p:(UInt8*)pixels{
    int radius = 10;
    for (int i=x-radius; i<x+radius; i++) {
        for (int j=y-radius; j<y+radius; j++) {
            if (pow(i-x,2)+pow(j-y,2) < pow(radius,2)) {
                pixels[PIXEL_SIZE*(i+j*_width)] = 0; //R
                pixels[PIXEL_SIZE*(i+j*_width)+1] = 0; //G
                pixels[PIXEL_SIZE*(i+j*_width)+2] = 0; //B
                pixels[PIXEL_SIZE*(i+j*_width)+3] = 255; //alpha
            }

        }
    }
}

-(int)separation:(float)Z {
    return round((1-mu*Z)*self.E/(2-mu*Z));
}

-(float)getDepthFromX:(int)x Y:(int)y map:(const UInt8*)depth_map {
    //assume gray scale and just use R value
    int R = depth_map[PIXEL_SIZE*(x+y*_width)];
    return R/255.0f;
}

@end
