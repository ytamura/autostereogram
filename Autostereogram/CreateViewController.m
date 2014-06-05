//
//  CreateViewController.m
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/15.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import "CreateViewController.h"
#import "AddMessageViewController.h"
#import "PrepViewController.h"
#import "StampManager.h"
#import "StampBoardView.h"
#import <QuartzCore/QuartzCore.h>

@interface CreateViewController ()
@property BOOL eraserMode;
@property NSInteger closestStampIndex;
@property StampManager *stampMgr;
@end

@implementation CreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// initialize array of stamps
    self.stampMgr = [[StampManager alloc] init];
    _eraserMode = NO;
    
    _stampBoardView.createView = self;
    _stampBoardView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) touchIsCloseToStamp:(CGPoint)touchLocation stamp:(UIView*)stamp {
    //if ([self distanceBtwnPt1:touchLocation andPt2:stamp.center] < touchTolerance) {
    /*NSLog([NSString stringWithFormat:@"touchLocation (%f,%f) stamp center (%f,%f) stamp frame (%f,%f)",
           touchLocation.x,touchLocation.y,
           stamp.center.x,stamp.center.y,
           stamp.frame.size.width,stamp.frame.size.height]);*/
    if (ABS(touchLocation.x - stamp.center.x) < stamp.frame.size.width/2
        && ABS(touchLocation.y - stamp.center.y) < stamp.frame.size.height/2) {
        return YES;
    }
    return NO;
}

//this only gets called once at the beginning of touch
//so determine the selected stamp, if any
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.stampBoardView.hidden = YES;
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
    self.closestStampIndex = [self.stampMgr getClosestStampIndex:location];
    if (self.closestStampIndex < 0) return;

    if (self.eraserMode) {
        UIImageView* closestStamp = [self.stampMgr.stamps objectAtIndex:self.closestStampIndex];
        if ([self touchIsCloseToStamp:location stamp:closestStamp]) {
            [self removeStamp:self.closestStampIndex];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	//[self touchesBegan:touches withEvent:event];
    UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];

    if (!self.eraserMode) {
        if (self.closestStampIndex < 0) return;
        UIImageView* closestStamp = [self.stampMgr.stamps objectAtIndex:self.closestStampIndex];
        if ([self touchIsCloseToStamp:location stamp:closestStamp]) {
            closestStamp.center = location;
        }
    }
}

#pragma mark Stamp Create/Destroy
-(void)createStamp:(NSString*)imageFileName; {
    [self turnOnOffEraserMode:NO];
    
    //determine pseudo-random location
    int randNum = rand() % ((int)self.view.frame.size.width - 50) + 50;
    int randNum2 = rand() % ((int)self.view.frame.size.height - 50) + 50;
    
    //create new stamp, add to array, and add to view
    UIImageView* stamp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFileName]];
    stamp.center = CGPointMake(randNum, randNum2);
    [self.canvasView addSubview:stamp];
    [self.stampMgr.stamps addObject:stamp];
}

-(void)removeStamp:(NSInteger)index {
    UIImageView* stamp = [self.stampMgr.stamps objectAtIndex:index];
    [stamp removeFromSuperview];
    [self.stampMgr.stamps removeObjectAtIndex:index];
}

#pragma mark Button Actions

- (IBAction)smilyStampButton:(UIButton *)sender {
    //display smily stamps in collection view
    [self.stampBoardView initImageFilter:@"smily"];
    self.stampBoardView.hidden = NO;
}

- (IBAction)starStampButton:(UIButton *)sender {
    //display star stamps in collection view
    [self.stampBoardView initImageFilter:@"shape"];
    self.stampBoardView.hidden = NO;
}

- (IBAction)eraserButton:(UIButton *)sender {
    self.stampBoardView.hidden = YES;
    [self turnOnOffEraserMode:!self.eraserMode];
}

-(void)turnOnOffEraserMode:(BOOL)turnOn {
    self.eraserMode = turnOn;
    [self.eraserButtonOutlet setImage:[UIImage imageNamed:(turnOn ? @"eraser_active.png":@"eraser.png")] forState:UIControlStateNormal];
}

- (IBAction)lettersButton:(UIButton *)sender {
    self.stampBoardView.hidden = YES;
    [self turnOnOffEraserMode:NO];
}

#pragma mark Unwind Segues from AddMessageViewController
-(void)done:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        
        AddMessageViewController *addController = [segue sourceViewController];
        if (addController.message) {
            UILabel* label = [StampManager createMessageLabel:addController.message withFont:addController.font];
            
            [self.canvasView addSubview:label];
            [self.stampMgr.stamps addObject:label];
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

-(void)cancel:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SaveDepthMap"]) {
        PrepViewController* prepView = [segue destinationViewController];
        prepView.depthMap = [self makeImage];
    }
}

-(UIImage*) makeImage {
    CGSize imageSize = self.view.bounds.size;
    //imageSize.height -= 44;
    UIGraphicsBeginImageContext(imageSize);
    
    [self.canvasView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end
