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
    
    [self initialize];
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.categories = [[NSMutableArray alloc] initWithArray:[appDelegate getCategories]];
    self.categoriesIcons = [[NSMutableArray alloc] initWithArray:[appDelegate getCategoriesIcons]];
    self.tableView.rowHeight = 54.0;
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ExploreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
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
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
}


@end
