//
//  AddStoreTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/30/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "ChooseCategoryTableViewController.h"
#import "StoreLocationViewController.h"
#import "WhatIsTheDeal1.h"
#import "DealersAnnotation.h"
#import "Store.h"
#import "MBProgressHUD.h"

@interface AddStoreTableViewController : UITableViewController <UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate> {
    
    CLLocationCoordinate2D coords;
    MBProgressHUD *storeAdded;
}

@property AppDelegate *appDelegate;
@property CLLocationManager *locationManager;
@property NSString *searchText;
@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *storeCategoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *storeAddressTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property DealersAnnotation *storePin;

@end
