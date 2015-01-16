//
//  ChooseCategoryTableViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 7/22/14.
//
//

#import "ChooseCategoryTableViewController.h"
#import "EditDealTableViewController.h"
#import "WhatIsTheDeal2.h"

@interface ChooseCategoryTableViewController ()

@end

@implementation ChooseCategoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.title = NSLocalizedString(@"Choose Category", nil);
    
    self.categories = [[NSArray alloc]initWithArray:[app getCategories]];
    self.icons = [[NSArray alloc]initWithArray:[app getCategoriesIcons]];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navigation Bar Background"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Add Deal Navigation Bar Background"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"categoryCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[self.icons objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17.0];
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cameFrom isEqualToString:@"Edit Deal"]) {
        
        EditDealTableViewController *edtvc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        edtvc.dealCategory.text = [self.categories objectAtIndex:indexPath.row];
        edtvc.dealCategory.textColor = [UIColor blackColor];
        edtvc.didChangeOriginalDeal = YES;
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([self.cameFrom isEqualToString:@"Add Deal"]) {
        
        WhatIsTheDeal2 *witd2vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        witd2vc.categoryLabel.text = [self.categories objectAtIndex:indexPath.row];
        witd2vc.categoryLabel.textColor = [UIColor blackColor];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
