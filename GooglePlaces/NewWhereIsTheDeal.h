//
//  NewWhereIsTheDeal.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/11/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "StoreCategoriesOrganizer.h"
#import "StoreTableViewCell.h"

@interface NewWhereIsTheDeal : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate> {
    
    CLLocationCoordinate2D currentCentre;
    CLLocationCoordinate2D lastCoords;
    CGFloat mapOriginalPosition, deviceScreenHeight;
}

@property AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYMapViewConstraint;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceSearchBarScrollViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceHideMapButtonConstraint;
@property (weak, nonatomic) IBOutlet UIButton *hideMapButton;

@property RKObjectManager *foursquareManager;

@property (strong, nonatomic) NSMutableArray *storesNearby;
@property (strong, nonatomic) NSMutableArray *storesSearched;

@property (weak, nonatomic) IBOutlet UITableView *nearbyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightNearByTableViewConstraint;
@property CGFloat nearbyTableViewMinHeight;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingAnimation;
@property (weak, nonatomic) IBOutlet UILabel *loadingMessage;

@property NSString *cameFrom;


@end
