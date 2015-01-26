//
//  ExploretableViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 10/4/13.
//
//

#import "ExploretableViewController.h"


@interface ExploretableViewController ()

@end

@implementation ExploretableViewController

@synthesize types;
@synthesize types_icons;
@synthesize filteredtypes;
@synthesize filteredtypes_icons;

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"Explore", nil);
        
    [super viewDidLoad];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    types = [[NSMutableArray alloc]initWithArray:[app getCategories]];
    
    filteredtypes = [[NSMutableArray alloc] initWithArray:[app getCategories]];
    
    types_icons = [[NSMutableArray alloc] initWithArray:[app getCategoriesIcons]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.myTableView deselectRowAtIndexPath:self.myTableView.indexPathForSelectedRow animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Explorecell";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([[[NSBundle mainBundle] preferredLocalizations].firstObject isEqualToString:@"he"]) {
        Cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    } else {
        Cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    }
    
    
    Cell.textLabel.text = [types objectAtIndex:indexPath.row];
    NSString *imagestring=[types_icons objectAtIndex:indexPath.row];
    Cell.imageView.image =[UIImage imageNamed:imagestring];
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealsTableViewController *dtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealsID"];
    dtvc.categoryFromExplore = [self.types objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dtvc animated:YES];
}

@end
