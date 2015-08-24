//
//  ExploreTempTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 3/10/15.
//
//

#import "ExploreTableViewController.h"

@interface ExploreTableViewController ()

@end

@implementation ExploreTableViewController

@synthesize appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    [self setSearchBar];
    [self setExitSearchModeButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    if (self.searched) {
        [self.searchBar becomeFirstResponder];
        [self enterSearchMode];
        self.searched = NO;
    }
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Explore Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [self updateExploreCounter];
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.categories = [[NSMutableArray alloc] initWithArray:[appDelegate getCategories]];
    self.categoriesIcons = [[NSMutableArray alloc] initWithArray:[appDelegate getCategoriesIcons]];
    self.tableView.rowHeight = 54.0;
    self.searched = NO;
}


#pragma mark - Search bar

- (void)setSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = NSLocalizedString(@"Search deals", nil);
    UIView *searchBarContrainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.bounds.size.width - 30.0, 44.0)];
    [searchBarContrainer addSubview:self.searchBar];
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = searchBarContrainer;
    self.searchBar.delegate = self;
}

- (void)setExitSearchModeButton
{
    self.exitSearchModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitSearchModeButton setFrame:self.view.frame];
    [self.exitSearchModeButton setBackgroundColor:[UIColor blackColor]];
    [self.exitSearchModeButton setAlpha:0];
    [self.exitSearchModeButton addTarget:self action:@selector(exitSearchMode) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view insertSubview:self.exitSearchModeButton belowSubview:self.navigationController.navigationBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self enterSearchMode];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self exitSearchMode];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0) {
        [searchBar resignFirstResponder];
        [self exitSearchModeButton];
        DealsTableViewController *dtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealsID"];
        dtvc.categoryFromExplore = nil;
        dtvc.searchTermFromExplore = searchBar.text;
        [self.navigationController pushViewController:dtvc animated:YES];
        self.searched = YES;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self exitSearchMode];
    [self.searchBar resignFirstResponder];
}

- (void)enterSearchMode
{
    [UIView animateWithDuration:0.3 animations:^{self.exitSearchModeButton.alpha = 0.65;}];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)exitSearchMode
{
    [UIView animateWithDuration:0.3 animations:^{self.exitSearchModeButton.alpha = 0.0;}];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
}


#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ExploreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([[[NSBundle mainBundle] preferredLocalizations].firstObject isEqualToString:@"he"]) {
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    }
    
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    NSString *imageString = [self.categoriesIcons objectAtIndex:indexPath.row];
    cell.imageView.image =[UIImage imageNamed:imageString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealsTableViewController *dtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealsID"];
    dtvc.categoryFromExplore = [self.categories objectAtIndex:indexPath.row];
    dtvc.searchTermFromExplore = nil;
    [self.navigationController pushViewController:dtvc animated:YES];
}

- (void)updateExploreCounter
{
    if (appDelegate.dealer.screenCounters) {
        ScreenCounters *counters = appDelegate.dealer.screenCounters;
        counters.explore = @(counters.explore.intValue + 1);
        NSString *path = [NSString stringWithFormat:@"/screen_counters/%@/", counters.screenCountersID];
        [[RKObjectManager sharedManager] patchObject:counters
                                                path:path
                                          parameters:nil
                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                 appDelegate.dealer.screenCounters = mappingResult.firstObject;
                                                 [appDelegate saveScreenCountersOnDevice];
                                             }
                                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                 NSLog(@"Failed to patch the screen counters.");
                                             }];
    }
}



@end
