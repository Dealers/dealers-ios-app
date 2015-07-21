//
//  AddStoreTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 3/30/15.
//
//

#import "AddStoreTableViewController.h"

@interface AddStoreTableViewController ()

@end

@implementation AddStoreTableViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self setNavigationBar];
    [self configureMapView];
    [self setProgressIndicator];
    self.storeNameTextField.text = self.searchText;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.storeNameTextField.text.length > 0 && self.storeCategoryTextField.text.length > 0) {
        [self enableAddButton];
    } else {
        [self disableAddButton];
    }
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Add Store Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"Navigation Bar Shade"]];
    } completion:nil];
}

- (void)setNavigationBar
{
    self.title = NSLocalizedString(@"Add New Store", nil);
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIView *addButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton addTarget:self action:@selector(addStore) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(8, 0, 58, 30)];
    [addButton setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
    [addButton setBackgroundColor:[appDelegate ourPurple]];
    [addButton.layer setCornerRadius:5.0];
    [addButton.layer setMasksToBounds:YES];
    [addButtonView addSubview:addButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:addButtonView];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)disableAddButton
{
    UIBarButtonItem *addButton = self.navigationItem.rightBarButtonItem;
    addButton.enabled = NO;
    if (addButton.customView.alpha == 1.0) {
        [UIView animateWithDuration:0.3 animations:^{ addButton.customView.alpha = 0.25; }];
    }
}

- (void)enableAddButton
{
    UIBarButtonItem *addButton = self.navigationItem.rightBarButtonItem;
    addButton.enabled = YES;
    if (addButton.customView.alpha == 0.25) {
        [UIView animateWithDuration:0.3 animations:^{ addButton.customView.alpha = 1.0; }];
    }
}


#pragma mark - Map

- (void)configureMapView
{
    coords.latitude = self.locationManager.location.coordinate.latitude;
    coords.longitude = self.locationManager.location.coordinate.longitude;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;     // 0.0 is min value u van provide for zooming
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = coords;     // to locate to the center
    [self.mapView setRegion:region animated:NO];
    [self.mapView regionThatFits:region];
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = NO;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annotationView.pinColor = MKPinAnnotationColorPurple;
    
    return annotationView;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self.storeNameTextField becomeFirstResponder];
                break;
            case 1:
                [self pushCategoryView];
            case 2:
                [self.storeAddressTextField becomeFirstResponder];
                
            default:
                break;
        }
    } else {
        [self pushStoreLocationView];
    }
}


#pragma mark - Other

- (void)pushCategoryView
{
    ChooseCategoryTableViewController *cctvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chooseCategoryID"];
    cctvc.cameFrom = @"Add Store";
    [self.navigationController pushViewController:cctvc animated:YES];
}

- (void)pushStoreLocationView
{
    StoreLocationViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreLocation"];
    slvc.locationManager = self.locationManager;
    slvc.storeName = self.storeNameTextField.text;
    if (self.storePin) {
        slvc.dropPin = [[DealersAnnotation alloc] initWithPosition:self.storePin.coordinate];
    }
    [self.navigationController pushViewController:slvc animated:YES];
}

- (void)addStore
{
    [storeAdded show:YES];
    [storeAdded hide:YES afterDelay:1.5];
    [self performSelector:@selector(pushWhatIsTheDealView) withObject:nil afterDelay:1.8];
}

- (void)pushWhatIsTheDealView
{
    Store *store = [self createStore];
    WhatIsTheDeal1 *witd1vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WhatIsTheDeal1ID"];
    witd1vc.store = store;
    witd1vc.cashedCategory = self.storeCategoryTextField.text;
    [self.navigationController pushViewController:witd1vc animated:YES];
}

- (Store *)createStore
{
    Store *store = [[Store alloc] init];
    store.name = self.storeNameTextField.text;
    store.address = self.storeAddressTextField.text;
    if (self.storePin) {
        store.latitude = [NSNumber numberWithDouble:self.storePin.coordinate.latitude];
        store.longitude = [NSNumber numberWithDouble:self.storePin.coordinate.longitude];
    } else {
        store.latitude = [NSNumber numberWithDouble:coords.latitude];
        store.longitude = [NSNumber numberWithDouble:coords.longitude];
    }
    store.added = YES;
    return store;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)editingChanged:(id)sender
{
    if (self.storeNameTextField.text.length > 0 && self.storeCategoryTextField.text.length > 0) {
        [self enableAddButton];
    } else {
        [self disableAddButton];
    }
}

- (void)setProgressIndicator
{
    storeAdded = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    storeAdded.delegate = self;
    storeAdded.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    storeAdded.mode = MBProgressHUDModeCustomView;
    storeAdded.labelText = NSLocalizedString(@"Store Added!", nil);
    storeAdded.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    storeAdded.detailsLabelText = NSLocalizedString(@"Thanks!", nil);
    storeAdded.detailsLabelFont = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    storeAdded.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:storeAdded];
}


@end