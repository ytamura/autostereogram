//
//  PrepViewController.m
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/16.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import "PrepViewController.h"
#import "FinalViewController.h"
#import "Autostereogram.h"
#import <QuartzCore/QuartzCore.h>

@interface PrepViewController ()

@end

@implementation PrepViewController

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
	// load preview image
    
    if (self.depthMap) {
        [self.depthPreview setImage:self.depthMap];
        [self.depthPreview.layer setBorderColor:[[UIColor redColor] CGColor]];
    }
    
    //keyboard dismiss
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.textImageName resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"FinishAgram"]) {
        FinalViewController* finalView = [segue destinationViewController];
        Autostereogram* as = [[Autostereogram alloc] initWithDepthMap:self.depthMap];
        finalView.agram = [as createAutostereogram:[self.switchGuideDots isOn]];
        finalView.showHomeButton = YES;
        
        //save depth map and autostereogram to files
        NSString* name =[self.textImageName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([name isEqualToString:@""]) {
            name = [NSString stringWithFormat:@"untitled-%@",[NSDate date]];
        }
        NSString  *depthPngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/depth-%@.png",name]];
        NSString  *imagePngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/image-%@.png",name]];

        [UIImagePNGRepresentation(self.depthMap) writeToFile:depthPngPath atomically:YES];
        [UIImagePNGRepresentation(finalView.agram) writeToFile:imagePngPath atomically:YES];
    }
}

- (IBAction)textDidEndOnExit:(id)sender {
    [self dismissKeyboard:sender];
}

-(void)dismissKeyboard:(id)sender {
    UITextField* t = (UITextField*)sender;
    [t resignFirstResponder];
}
@end
