//
//  StampBoardView.m
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/06/04.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import "StampBoardView.h"
#import "StampBoardViewCell.h"
#import "CreateViewController.h"

@implementation StampBoardView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"StampBoard" owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        StampBoardView *newView = [arrayOfViews objectAtIndex:0];
        [newView setFrame:frame];
        
        //self = newView;
        [self addSubview:newView];
    }
    
    return self;
}

//to load directly from nib
-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])){
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"StampBoard" owner:self options:nil] objectAtIndex:0]];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"StampBoardCell" bundle:nil] forCellWithReuseIdentifier:@"StampThumbNailCell"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
}

//initialize array of pngs with new image filter
-(void)initImageFilter:(NSString*)newImageFilter; {
    _imageFilter = newImageFilter;
    
    //setup data
    NSArray *directoryContent;
    
    NSString *documentsPath = [[NSBundle mainBundle] bundlePath];
    NSLog(@"%@",documentsPath);
    directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
    
    NSString *filterStr = [NSString stringWithFormat:@"self ENDSWITH '.png' AND self CONTAINS '%@'",_imageFilter];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:filterStr];
    self.stampPngs = [directoryContent filteredArrayUsingPredicate:fltr];
    NSLog(@"Filter %@, number of images found: %lu", _imageFilter, (unsigned long)_stampPngs.count);
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _stampPngs.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StampBoardViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"StampThumbNailCell" forIndexPath:indexPath];
    cell.stampThumbNail.image = [UIImage imageNamed:_stampPngs[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_createView createStamp:_stampPngs[indexPath.row]];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
