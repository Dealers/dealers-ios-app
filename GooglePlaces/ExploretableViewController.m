//
//  ExploretableViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 10/4/13.
//
//

#import "ExploretableViewController.h"
#import "ViewonedealViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "WhereIsTheDeal.h"
#import "ExploreDealsViewController.h"
#import "OnlineViewController.h"

@interface ExploretableViewController ()

@end

@implementation ExploretableViewController

@synthesize types;
@synthesize types_icons;
@synthesize SearchBar;
@synthesize filteredtypes;
@synthesize filteredtypes_icons;
@synthesize filtered;

- (void)viewDidLoad
{
    self.title = @"Explore";
    
    [super viewDidLoad];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.SearchBar.delegate=self;
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal = @"aftertapbar";
    
    types = [[NSMutableArray alloc]initWithArray:[app getCategories]];
    
    filteredtypes = [[NSMutableArray alloc] initWithArray:[app getCategories]];
    
    types_icons = [[NSMutableArray alloc] initWithArray:[app getCategoriesIcons]];
    
    UIButton *selectDealButton9=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton9 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton9.frame=CGRectMake(0,_myTableView.frame.origin.y,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-68));
    selectDealButton9.tag=1;
    [selectDealButton9 setBackgroundColor:[UIColor whiteColor]];
    selectDealButton9.alpha=0.0;
    [selectDealButton9 addTarget:self action:@selector(removeWhiteCoverKeyBoard) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton9];
    
    flagWhiteCover=0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (filtered == YES) {
        return filteredtypes.count;
    }
    else
        return types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Explorecell";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17.0];
    
    if (filtered == YES) {
        
        Cell.textLabel.text = [filteredtypes objectAtIndex:indexPath.row];
        NSString *imagestring=[filteredtypes_icons objectAtIndex:indexPath.row];
        Cell.imageView.image =[UIImage imageNamed:imagestring];
    }
    else {
        Cell.textLabel.text = [types objectAtIndex:indexPath.row];
        NSString *imagestring=[types_icons objectAtIndex:indexPath.row];
        Cell.imageView.image =[UIImage imageNamed:imagestring];
    }
    return Cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexpath = [self.myTableView indexPathForSelectedRow];
    NSString *string;
    
    if (filtered == YES) {
    if (indexpath.row < [self.filteredtypes count]) {
        string = [self.filteredtypes objectAtIndex:indexpath.row];
    } else string = @"Unknown";
    [[segue destinationViewController] setCategoryFromExplore:string];
    }
    
    if (filtered == NO) {
        string = [self.types objectAtIndex:indexpath.row];
        [[segue destinationViewController] setCategoryFromExplore:string];
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return 1;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length==0) {
        filtered = NO;
    } else
    {
        filtered = YES;
        filteredtypes = [[NSMutableArray alloc] init];
        filteredtypes_icons = [[NSMutableArray alloc]init];
        for (NSString *type in types) {
            NSRange typerange = [type rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (typerange.location != NSNotFound) {
                [filteredtypes addObject:type];
            }
        }
        
        for (NSString *type in types_icons) {
            NSRange typerange = [type rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (typerange.location != NSNotFound) {
                [filteredtypes_icons addObject:type];
            }
        }
    }
    [self.myTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.SearchBar resignFirstResponder];
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.SearchBar performSelector: @selector(resignFirstResponder)
                         withObject: nil
                         afterDelay: 0.1];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.SearchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.SearchBar performSelector: @selector(resignFirstResponder)
                         withObject: nil
                         afterDelay: 0.1];
}

-(void) BackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.SearchBar performSelector: @selector(resignFirstResponder)
                         withObject: nil
                         afterDelay: 0.0];
}

-(void) deallocMemory {
    types=nil;
    types_icons=nil;
    filteredtypes=nil;
    filteredtypes_icons=nil;
}

-(void) showWhiteCoverKeyBoard {
    if (!flagWhiteCover) {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:1];
    [self.view bringSubviewToFront:button1];
    [UIView animateWithDuration:0.3 animations:^{
        button1.alpha=0.8;
    }];
        flagWhiteCover=1;
    }
}

-(void) removeWhiteCoverKeyBoard {
    if (flagWhiteCover) {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        button1.alpha=0.0;
    }];
    [self.SearchBar performSelector: @selector(resignFirstResponder)
                         withObject: nil
                         afterDelay: 0.1];
        flagWhiteCover=0;
    }
}

@end
