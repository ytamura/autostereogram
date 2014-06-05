//
//  AgramMainViewController.h
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/15.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgramMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString* documentsPath;
    NSMutableArray* listOfFiles;
}

@property (strong, nonatomic) IBOutlet UITableView *myDepthsTable;
- (IBAction)returnHome:(UIStoryboardSegue *)segue;
@end
