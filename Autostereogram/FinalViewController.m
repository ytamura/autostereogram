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
        if (self.showHomeButton) {
            [self.buttonHome setHidden:!self.showHomeButton];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonShare:(id)sender {
    [self shareFileByEmail];
}

- (IBAction)buttonHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Sharing
-(void)shareFileByEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.navigationBar.tintColor = [UIColor blackColor];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"An AGram for you"];
        [controller setMessageBody:@"Here is your message!<br>--AGram--" isHTML:YES];
        
        //attach image
        NSData* imageData = UIImagePNGRepresentation(self.agram);
        [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"agram"];
        
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
