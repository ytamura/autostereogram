//
//  StampBoardView.h
//  Autostereogram
//
//  Created by Yuriko Tamura on 2013/06/04.
//  Copyright (c) 2013年 Yuriko Tamura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateViewController;
@interface StampBoardView : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *imageFilter;
@property (strong, nonatomic) NSArray *stampPngs;
@property CreateViewController *createView;

-(id)initWithFrame:(CGRect)frame;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(void)initImageFilter:(NSString*)newImageFilter;
@end
