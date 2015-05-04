//
//  StoreLocationViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 3/31/15.
//
//

#import "StoreLocationViewController.h"

@implementation StoreLocationViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Tap Store Location", nil);
    appDelegate = [[UIApplication sharedApplication] delegate];

    [self setNavigationBar];
    [self configureMapView];
    [self addLongPressRecognizer];
    
    self.hintView.layer.cornerRadius = 5.0;
    self.hintView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"Navigation Bar Shade"]];
    } completion:nil];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Add Store - Store Location Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    } completion:nil];
}

- (void)setNavigationBar
{
    UIView *doneButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setFrame:CGRectMake(8, 0, 58, 30)];
    [doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
    [doneButton setBackgroundColor:[appDelegate ourPurple]];
    [doneButton.layer setCornerRadius:5.0];
    [doneButton.layer setMasksToBounds:YES];
    
    [doneButtonView addSubview:doneButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:doneButtonView];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)configureMapView
{
    if (self.dropPin) {
        coords.latitude = self.dropPin.coordinate.latitude;
        coords.longitude = self.dropPin.coordinate.longitude;
        [self.mapView addAnnotation:self.dropPin];
    } else {
        coords.latitude = self.locationManager.location.coordinate.latitude;
        coords.longitude = self.locationManager.location.coordinate.longitude;
    }
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;     // 0.0 is min value u van provide for zooming
    span.longitudeDelta = 0.02;
    region.span = span;
    region.center = coords;     // to locate to the center
    [self.mapView setRegion:region animated:NO];
    [self.mapView regionThatFits:region];
    self.mapView.showsUserLocation = YES;
}

- (void)addLongPressRecognizer
{
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    longPressGestureRecognizer.minimumPressDuration = 0.6f;
    longPressGestureRecognizer.allowableMovement = 20.0f;
    longPressGestureRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        if (!self.dropPin) {
            self.dropPin = [[DealersAnnotation alloc] initWithPosition:locCoord];
            [self.mapView addAnnotation:self.dropPin];
        } else {
            [self.dropPin setPosition:locCoord];
        }
        self.dropPin.title = self.storeName;
        return;
    
    } else if (sender.state == UIGestureRecognizerStateEnded && self.hintView.alpha > 0) {
        [self performSelector:@selector(hideHintView) withObject:nil afterDelay:1.0];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annotationView.pinColor = MKPinAnnotationColorPurple;
    annotationView.draggable = YES;
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    return annotationView;
}

- (void)hideHintView
{
    [UIView animateWithDuration:0.3 animations:^{ self.hintView.alpha = 0; }];
}

- (void)done
{
    AddStoreTableViewController *adtvc = [[self.navigationController viewControllers] objectAtIndex:self.navigationController.viewControllers.count - 2];
    if (self.dropPin) {
        if (adtvc.storePin) {
            [adtvc.mapView removeAnnotation:adtvc.storePin];
        }
        adtvc.storePin = [[DealersAnnotation alloc] initWithPosition:self.dropPin.coordinate];
        [adtvc.mapView addAnnotation:adtvc.storePin];
        MKCoordinateRegion region;
        region.span = adtvc.mapView.region.span;
        region.center = self.dropPin.coordinate;
        [adtvc.mapView setRegion:region animated:NO];
        [adtvc.mapView regionThatFits:region];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
