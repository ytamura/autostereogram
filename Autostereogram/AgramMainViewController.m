//
//  AgramMainViewController.m
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/03/15.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import "AgramMainViewController.h"
#import "FinalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AgramMainViewController ()

@end

@implementation AgramMainViewController

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
}

-(void)viewWillAppear:(BOOL)animated {
    [self getListOfFiles];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.myDepthsTable reloadData];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Segue
-(void)returnHome:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"ReturnHome"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ViewImage"]) {
        FinalViewController* finalView = (FinalViewController*)[segue destinationViewController];
        NSIndexPath* indexPath = [self.myDepthsTable indexPathForSelectedRow];
        NSString* depthPath = [listOfFiles objectAtIndex:indexPath.row];
        NSLog(@"Selected %@",depthPath);
        finalView.agram = [UIImage imageWithContentsOfFile:
                           [documentsPath stringByAppendingPathComponent:
                            [depthPath stringByReplacingOccurrencesOfString:@"depth" withString:@"image"]]];
        NSLog(@"agram %f,%f",finalView.agram.size.height,finalView.agram.size.width);
    }
}

#pragma mark Table 

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// Handle deletion/insertion requests
- (void) tableView:(UITableView *) tableView
commitEditingStyle:(UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath:(NSIndexPath *) indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        //actually delete file
        NSString *filePathDepth = [documentsPath stringByAppendingPathComponent:[listOfFiles objectAtIndex:indexPath.row]];
        NSString *filePathImage = [filePathDepth stringByReplacingOccurrencesOfString:@"depth" withString:@"image"];
        if ([[NSFileManager defaultManager] removeItemAtPath:filePathDepth error:nil] != YES) {
            NSLog(@"Unable to delete depth file: %@",filePathDepth);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete depth file!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            if ([[NSFileManager defaultManager] removeItemAtPath:filePathImage error:nil] != YES) {
                NSLog(@"Unable to delete image file: %@",filePathImage);
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete image file!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } else {
                [listOfFiles removeObjectAtIndex:[indexPath row]];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
            }
        }
	}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listOfFiles count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterLongStyle];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArchiveCell" forIndexPath:indexPath];
    
    NSString *fileAtIndex = [listOfFiles objectAtIndex:indexPath.row];
    
    //fill stuff
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileAtIndex];
    
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:100];
    imageView.image = [UIImage imageWithContentsOfFile:filePath];
    
    UIImageView* imageView2 = (UIImageView*)[cell viewWithTag:103];
    imageView2.image = [UIImage imageWithContentsOfFile:[filePath stringByReplacingOccurrencesOfString:@"depth" withString:@"image"]];
    [imageView2.layer setCornerRadius:10.0f];
    [imageView2 setClipsToBounds:YES];
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:101];
    [nameLabel setText:[fileAtIndex substringWithRange:NSMakeRange(6, [fileAtIndex length]-10)]];
    
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    if (attrs != nil) {
        UILabel* dateLabel = (UILabel*)[cell viewWithTag:102];
        [dateLabel setText:[formatter stringFromDate:[attrs fileCreationDate]]];
        
    }
    return cell;
}

#pragma mark Files

//get list of saved zdata files from Documents directory
-(void)getListOfFiles {
    NSArray *directoryContent;
    NSArray *myPathList =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    documentsPath = [myPathList objectAtIndex:0];
    NSLog(@"%@",documentsPath);
    directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
    NSLog(@"Number of files found: %lu",(unsigned long)directoryContent.count);
    
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.png' AND self CONTAINS 'depth'"];
    NSArray *onlyDepthMaps = [directoryContent filteredArrayUsingPredicate:fltr];
    
    //reverse so that new files come on top
    listOfFiles = [NSMutableArray new];
    for (id file in [onlyDepthMaps reverseObjectEnumerator]) {
        [listOfFiles addObject:file];
    }
}

@end
