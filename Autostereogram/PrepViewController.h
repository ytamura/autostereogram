//
//  PrepViewController.h
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/16.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrepViewController : UIViewController

@property UIImage* depthMap;
@property (strong, nonatomic) IBOutlet UIImageView *depthPreview;
@property (strong, nonatomic) IBOutlet UITextField *textImageName;
- (IBAction)textDidEndOnExit:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *switchGuideDots;
@end
