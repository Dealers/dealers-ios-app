//
//  ProfileTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/2/14.
//
//

#import "ProfileTableViewController.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosInVisibleCells:)
                                                 name:@"Profile Photos Notifications"
                                               object:nil];
    
    [self initialize];
    [self setRefreshControl];
    [self downloadDeals];
    [self setLoadingView];
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.uploadedDeals = [[NSMutableArray alloc]init];
    self.likedDeals = [[NSMutableArray alloc]init];
}

- (void)setRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [appDelegate ourPurple];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)refresh
{
    self.uploadedDeals = [[NSMutableArray alloc]init];
    self.likedDeals = [[NSMutableArray alloc]init];
    [self downloadDeals];
}

- (void)downloadDeals
{
    NSString *path;
    NSDictionary *parameters;
    
    path = @"/profile
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:parameters
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [self.deals addObjectsFromArray:mappingResult.array];
                                                  
                                                  if (!self.deals || self.deals.count == 0) {
                                                      [self stopLoadingAnimation];
                                                      [self noDealMessage];
                                                      
                                                  } else {
                                                      [self.tableView reloadData];
                                                      [self stopLoadingAnimation];
                                                  }
                                                  
                                                  [self.refreshControl endRefreshing];
                                                  
                                                  NSLog(@"\n success! \n number of deals: %lu", (unsigned long)self.deals.count);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"There was an error with the loading of the store search: %@", error);
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  [alert show];
                                              }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    // Configure the cell...
    
    return cell;
}


@end
