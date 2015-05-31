//
//  OnlineImagePickerCollectionViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 5/19/15.
//
//

#import <UIKit/UIKit.h>
#import "ImageCollectionViewCell.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface OnlineImagePickerCollectionViewController : UICollectionViewController

@property id delegate;
@property NSMutableArray *images;

@end
