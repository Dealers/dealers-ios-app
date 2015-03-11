//
//  ExploreTempTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/10/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DealsTableViewController.h"
#import "ViewonedealViewController.h"
#import "WhereIsTheDeal.h"

@interface ExploreTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *types;
@property (nonatomic, strong) NSMutableArray *types_icons;

@property (nonatomic, strong) NSMutableArray *filteredtypes;
@property (nonatomic, strong) NSMutableArray *filteredtypes_icons;

@end
