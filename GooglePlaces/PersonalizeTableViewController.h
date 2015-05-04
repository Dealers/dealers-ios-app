//
//  PersonalizeTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/23/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Category.h"
#import "ElasticLabel.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface PersonalizeTableViewController : UITableViewController {
    
    UIView *loadingContainer;
    UIImageView *loadingAnimation;
    UITableViewCell *cashedCategoryCell;
}

@property AppDelegate *appDelegate;
@property NSArray *categories;
@property NSArray *categoriesIcons;

@property NSMutableArray *selectedCategories;

@property (weak, nonatomic) IBOutlet ElasticLabel *explanation;

@end
