//
//  StoreLocationViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/31/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "AddStoreTableViewController.h"
#import "DealersAnnotation.h"


@interface StoreLocationViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate> {
    
    CLLocationCoordinate2D coords;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
}

@property AppDelegate *appDelegate;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *hintView;
@property DealersAnnotation *dropPin;
@property NSString *storeName;

@end
