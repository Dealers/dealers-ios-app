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
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface ExploreTableViewController : UITableViewController <UISearchBarDelegate>

@property AppDelegate *appDelegate;
@property UISearchBar *searchBar;
@property UIButton *exitSearchModeButton;
@property BOOL searched;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableArray *categoriesIcons;

@end
