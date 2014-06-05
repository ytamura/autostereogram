//
//  CreateViewController.h
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/15.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StampBoardView;

@interface CreateViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *eraserButtonOutlet;
@property (weak, nonatomic) IBOutlet StampBoardView *stampBoardView;
@property (strong, nonatomic) IBOutlet UIView *canvasView;

- (IBAction)smilyStampButton:(UIButton *)sender;
- (IBAction)starStampButton:(UIButton *)sender;
- (IBAction)eraserButton:(UIButton *)sender;
- (IBAction)lettersButton:(UIButton *)sender;

- (void)createStamp:(NSString*)imageFileName;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;
@end
