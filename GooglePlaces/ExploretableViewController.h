//
//  ExploretableViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 10/4/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DealsTableViewController.h"
#import "ViewonedealViewController.h"
#import "WhereIsTheDeal.h"

@interface ExploretableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *types;
@property (nonatomic, strong) NSMutableArray *types_icons;

@property (nonatomic, strong) NSMutableArray *filteredtypes;
@property (nonatomic, strong) NSMutableArray *filteredtypes_icons;

@end
