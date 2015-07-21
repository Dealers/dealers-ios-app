//
//  PersonalizeTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 3/23/15.
//
//

#import "PersonalizeTableViewController.h"

@interface PersonalizeTableViewController ()

@end

@implementation PersonalizeTableViewController

@synthesize appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Personalize", nil);
    [self initialize];
    [self.view layoutIfNeeded];
    [self setNavigationBar];
    [self setExplanationText];
    [self downloadSelectedCategories];
    [self setLoadingView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[self.navigationController navigationBar] isHidden]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    if (self.afterSignUp) {
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Personalize Screen (after sign up)"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    } else {
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Personalize Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.categories = [[NSMutableArray alloc] initWithArray:[appDelegate getCategories]];
    self.categoriesIcons = [[NSMutableArray alloc] initWithArray:[appDelegate getCategoriesIcons]];
    self.selectedCategories = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = 54.0;
}

- (void)setNavigationBar
{
    UIView *doneButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setFrame:CGRectMake(8, 0, 58, 30)];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
    [doneButton setBackgroundColor:[appDelegate ourPurple]];
    [doneButton.layer setCornerRadius:5.0];
    [doneButton.layer setMasksToBounds:YES];
    
    if (self.afterSignUp) {
        [doneButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [doneButtonView addSubview:doneButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:doneButtonView];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    if (self.afterSignUp) {
        [self.navigationItem setHidesBackButton:YES];
    }
}

- (void)setExplanationText
{
    self.explanation.text = NSLocalizedString(@"Choose categories to get more personalized deals in your feed", nil);

    if (self.afterSignUp) {
        self.explanation.text = NSLocalizedString(@"Choose categories to get more personalized deals in your feed. You can always make changes later from your profile.", nil);
    } else {
        self.explanation.text = NSLocalizedString(@"Choose categories to get more personalized deals in your feed", nil);
    }
    
    UIView *header = self.tableView.tableHeaderView;
    CGSize explanationSize = [self.explanation sizeThatFits:CGSizeMake(self.explanation.frame.size.width, MAXFLOAT)];
    header.frame = CGRectMake(0, 0, self.tableView.frame.size.width, explanationSize.height + 14.0 * 2);
    self.tableView.tableHeaderView = header;
    
}

- (void)downloadSelectedCategories
{
    NSString *path = [NSString stringWithFormat:@"/dealer_cats/%@/", appDelegate.dealer.dealerID];
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.selectedCategories = [NSMutableArray arrayWithArray:mappingResult.array];
                                                  [self.tableView reloadData];
                                                  [self stopLoading];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self errorMessage];
                                              }];
}

- (void)setLoadingView
{
    loadingContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    loadingContainer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    loadingAnimation = [appDelegate loadingAnimationPurple];
    [loadingAnimation startAnimating];
    loadingAnimation.frame = CGRectMake(self.view.center.x - 15.0, 15.0, 30.0, 30.0);
    [loadingContainer addSubview:loadingAnimation];
    [self.tableView addSubview:loadingContainer];
    [self.tableView setScrollEnabled:NO];
}

- (void)stopLoading
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         loadingContainer.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [loadingContainer removeFromSuperview];
                         [self.tableView setScrollEnabled:YES];
                     }];
}

- (void)errorMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         loadingAnimation.transform = CGAffineTransformMakeScale(0.001, 0.001);
                     } completion:^(BOOL finished) {
                         UILabel *error = [[UILabel alloc] initWithFrame:loadingContainer.frame];
                         error.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
                         error.textAlignment = NSTextAlignmentCenter;
                         error.textColor = [appDelegate textGrayColor];
                         error.numberOfLines = 0;
                         error.alpha = 0;
                         NSString *problem = NSLocalizedString(@"There was a problem", nil);
                         NSString *tryAgain = NSLocalizedString(@"Please try again", nil);
                         error.text = [NSString stringWithFormat:@"%@...\n%@", problem, tryAgain];
                         [loadingContainer addSubview:error];
                         
                         UILabel *sadSmiley = [[UILabel alloc]initWithFrame:CGRectMake(0, error.center.y - 100, self.tableView.frame.size.width, 50)];
                         sadSmiley.font = [UIFont fontWithName:@"Avenir-Light" size:50.0];
                         sadSmiley.textAlignment = NSTextAlignmentCenter;
                         sadSmiley.textColor = [appDelegate textGrayColor];
                         sadSmiley.alpha = 0;
                         sadSmiley.text = @":(";
                         [loadingContainer addSubview:sadSmiley];

                         [UIView animateWithDuration:0.3 animations:^{
                             error.alpha = 1.0;
                             sadSmiley.alpha = 1.0;
                         }];
                     }];
}


#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PersonalizeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([[[NSBundle mainBundle] preferredLocalizations].firstObject isEqualToString:@"he"]) {
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    NSString *imageString = [self.categoriesIcons objectAtIndex:indexPath.row];
    cell.imageView.image =[UIImage imageNamed:imageString];
    
    if ([self isCategorySelected:cell.textLabel.text]) {
        [self setCellStyleSelected:YES cell:cell];
    } else {
        [self setCellStyleSelected:NO cell:cell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *categoryValue = cell.textLabel.text;
    cashedCategoryCell = cell;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self removeCategoryAsUnselected:categoryValue];
        [self setCellStyleSelected:NO cell:cell];
    } else {
        [self addCategoryAsSelected:categoryValue];
        [self setCellStyleSelected:YES cell:cell];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)setCellStyleSelected:(BOOL)selected cell:(UITableViewCell *)cell
{
    if (selected) {
        [UIView animateWithDuration:0.15 animations:^{
            cell.imageView.alpha = 1.0;
            cell.textLabel.alpha = 1.0;
            cell.backgroundColor = [UIColor whiteColor];
        }];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {
        [UIView animateWithDuration:0.15 animations:^{
            cell.imageView.alpha = 0.5;
            cell.textLabel.alpha = 0.5;
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (BOOL)isCategorySelected:(NSString *)categoryValue
{
    NSString *key = [appDelegate getCategoryKeyForValue:NSLocalizedString(categoryValue, nil)];
    for (Category *category in self.selectedCategories) {
        if ([category.categoryKey isEqualToString:key]) {
            return YES;
        }
    }
    return NO;
}

- (void)addCategoryAsSelected:(NSString *)categoryValue
{
    if (![self isCategorySelected:categoryValue]) {
        Category *newCategory = [[Category alloc] init];
        newCategory.categoryKey = [appDelegate getCategoryKeyForValue:NSLocalizedString(categoryValue, nil)];
        newCategory.dealerID = appDelegate.dealer.dealerID;
        [self postNewCategory:newCategory];
        return;
    }
    NSLog(@"Category was already in the selected categories array...");
}

- (void)postNewCategory:(Category *)category
{
    [[RKObjectManager sharedManager] postObject:category
                                           path:@"/dealer_categorys/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mapping) {
                                            [self.selectedCategories addObject:mapping.firstObject];
                                            cashedCategoryCell = nil;
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"There was a problem", nil)
                                                                                            message:NSLocalizedString(@"Please try again", nil)
                                                                                           delegate:self
                                                                                   cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                  otherButtonTitles:nil];
                                            [alert show];
                                            [self setCellStyleSelected:NO cell:cashedCategoryCell];
                                        }];
    
}

- (void)removeCategoryAsUnselected:(NSString *)categoryValue
{
    NSString *key = [appDelegate getCategoryKeyForValue:NSLocalizedString(categoryValue, nil)];
    for (Category *category in self.selectedCategories) {
        if ([category.categoryKey isEqualToString:key]) {
            [self deleteCategory:category];
            return;
        }
    }
    NSLog(@"Category wasn't in the selected categories array from the first place...");
}

- (void)deleteCategory:(Category *)category
{
    NSString *path = [NSString stringWithFormat:@"/dealer_categorys/%@/", category.categoryID];
    [[RKObjectManager sharedManager] deleteObject:category
                                           path:path
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mapping) {
                                            [self.selectedCategories removeObject:category];
                                            cashedCategoryCell = nil;
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"There was a problem", nil)
                                                                                            message:NSLocalizedString(@"Please try again", nil)
                                                                                           delegate:self
                                                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                  otherButtonTitles:nil];
                                            [alert show];
                                            [self setCellStyleSelected:YES cell:cashedCategoryCell];
                                        }];
    
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)next:(UIButton *)sender
{
    TutorialViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Tutorial"];
    tvc.afterSignUp = YES;
    [self.navigationController pushViewController:tvc animated:YES];
}


@end
