//
//  FinalViewController.h
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/23.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FinalViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
}

@property UIImage* agram;
@property (strong, nonatomic) IBOutlet UIImageView *finalAgram;
- (IBAction)buttonShare:(id)sender;

@end
