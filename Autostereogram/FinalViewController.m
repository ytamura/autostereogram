//
//  FinalViewController.m
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/23.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import "FinalViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface FinalViewController ()
-(void)shareFile:(UILongPressGestureRecognizer*)sender;
@end

@implementation FinalViewController

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
	if (self.agram) {
        [self.finalAgram setImage:self.agram];
        NSLog(@"agram2 %f,%f",self.agram.size.height,self.agram.size.width);
        
        //long press
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(shareFile:)];
        longPress.minimumPressDuration = 2;
        [self.view addGestureRecognizer:longPress];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonShare:(id)sender {
    //[self.finalAgram setImage:self.agram];
}

#pragma mark UILongPressGestureRecognizer
-(void)shareFile:(UILongPressGestureRecognizer*)sender {
    //need to pick Began or Ended, because otherwise this gets called both times
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press recognized");
    } else return;
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.navigationBar.tintColor = [UIColor blackColor];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"temp name"];
        [controller setMessageBody:@"Here is your message!\n\n--MagicEye--" isHTML:YES];
        
        if (controller) {
            [self presentViewController:controller animated:YES completion:^{}];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No email configured!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark MFMailComposeViewController delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result==MFMailComposeResultSent) {
        NSLog(@"Email sent!");
    }
    if(![self.presentedViewController isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}
@end
