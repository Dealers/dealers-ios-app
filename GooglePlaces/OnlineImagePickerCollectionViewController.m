//
//  OnlineImagePickerCollectionViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 5/19/15.
//
//

#import "OnlineImagePickerCollectionViewController.h"
#import "WhatIsTheDeal1Online.h"

@interface OnlineImagePickerCollectionViewController ()

@end

@implementation OnlineImagePickerCollectionViewController

static NSString * const imageCellIdentifier = @"ImageCell";
static CGFloat const imageCellPadding = 6.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Select an image", nil);
    [self setNavigationButtons];
    [self collectionViewSettings];
}

- (void)setNavigationButtons
{
    UIBarButtonItem *options = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Dismiss"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(dismiss:)];
    [options setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    self.navigationItem.leftBarButtonItem = options;
    
    UIBarButtonItem *noImage = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"No Image", nil)
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(noImage:)];
    [noImage setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Roman" size:16.0]}
                           forState:UIControlStateNormal];
    [noImage setTitlePositionAdjustment:UIOffsetMake(-4.0, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = noImage;
}

- (void)collectionViewSettings
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = [self imageCellSize];
    flow.sectionInset = UIEdgeInsetsMake(0, imageCellPadding, 0, imageCellPadding);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    self.collectionView.collectionViewLayout = flow;
}

- (CGSize)imageCellSize
{
    CGFloat x = (self.view.bounds.size.width - imageCellPadding * 2) / 2;
    return CGSizeMake(x, x);
}

- (void)dismiss:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectedImage:(UIImage *)image
{
    if (image) {
        WhatIsTheDeal1Online *witd1ovc = (WhatIsTheDeal1Online *)self.delegate;
        [witd1ovc insertImageInImageView:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)noImage:(UIBarButtonItem *)sender
{
    WhatIsTheDeal1Online *witd1ovc = (WhatIsTheDeal1Online *)self.delegate;
    [witd1ovc removeImageFromImageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [self.images objectAtIndex:indexPath.item];
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *selectedImage = (UIImage *)[self.images objectAtIndex:indexPath.item];
    [self selectedImage:selectedImage];
}


@end
