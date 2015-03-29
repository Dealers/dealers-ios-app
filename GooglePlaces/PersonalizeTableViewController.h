//
//  PersonalizeTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/23/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PersonalizeTableViewController : UITableViewController

@property AppDelegate *appDelegate;
@property NSArray *categories;
@property NSArray *categoriesIcons;

@end
