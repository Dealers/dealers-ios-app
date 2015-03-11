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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Explore", nil);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.types = [[NSMutableArray alloc] initWithArray:[appDelegate getCategories]];
    
    self.filteredtypes = [[NSMutableArray alloc] initWithArray:[appDelegate getCategories]];
    
    self.types_icons = [[NSMutableArray alloc] initWithArray:[appDelegate getCategoriesIcons]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.types.count;
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
    
    
    cell.textLabel.text = [self.types objectAtIndex:indexPath.row];
    NSString *imageString = [self.types_icons objectAtIndex:indexPath.row];
    cell.imageView.image =[UIImage imageNamed:imageString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealsTableViewController *dtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealsID"];
    dtvc.categoryFromExplore = [self.types objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dtvc animated:YES];
}



@end
