//
//  AddMessageViewController.h
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/16.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMessageViewController : UIViewController <UITextFieldDelegate>
@property NSString* message;
@property UIFont* font;

@property (strong, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) IBOutlet UILabel *previewLabel;

- (IBAction)textInputChanged:(UITextField *)sender;
@end
