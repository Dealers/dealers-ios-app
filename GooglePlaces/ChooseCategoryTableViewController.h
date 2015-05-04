//
//  ChooseCategoryTableViewController.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 7/22/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface ChooseCategoryTableViewController : UITableViewController

@property (nonatomic) NSArray *categories;
@property (nonatomic) NSArray *icons;

@property (nonatomic) NSString *cameFrom;

@end
