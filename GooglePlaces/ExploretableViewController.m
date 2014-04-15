//
//  ExploretableViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 10/4/13.
//
//

#import "ExploretableViewController.h"
#import "ExploreCell.h"
#import "ViewonedealViewController.h"
#import "MoreViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"
#import "ExploreDealsViewController.h"

@interface ExploretableViewController ()

@end

@implementation ExploretableViewController

@synthesize types;
@synthesize types_icons;
@synthesize SearchBar;
@synthesize filteredtypes;
@synthesize filteredtypes_icons;
@synthesize filtered;
@synthesize BlueButtonsView,OnlineButton,OnlineText,LocalButton,LocalText,LockTableButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.LockTableButton.alpha=0.0;
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.SearchBar.delegate=self;
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"aftertapbar";
    
    types = [[NSMutableArray alloc] initWithObjects:@"Art",@"Automotive",@"Beauty & Personal Care",@"Books & Magazines",@"Electronics",@"Entertainment & Events",@"Fashion",@"Food & Groceries",@"Home & Furniture",@"Kids & Babies",@"Music",@"Pets",@"Restaurants & Bars",@"Sports & Outdoor",@"Travel",@"Other",nil];

    filteredtypes = [[NSMutableArray alloc] initWithObjects:@"Art",@"Automotive",@"Beauty & Personal Care",@"Books & Magazines",@"Electronics",@"Entertainment & Events",@"Fashion",@"Food & Groceries",@"Home & Furniture",@"Kids & Babies",@"Music",@"Pets",@"Restaurants & Bars",@"Sports & Outdoor",@"Travel",@"Other",nil];

    types_icons = [[NSMutableArray alloc] initWithObjects:@"Explore-Black_Art icon.png",@"Explore-Black_Automotive icon.png",@"Explore-Black_Beauty & Personal Care icon.png",@"Explore-Black_Books & Magazines icon.png",@"Explore-Black_Electronics icon.png",@"Explore-Black_Amusment & Entertainment icon.png",@"Explore-Black_Fashion icon.png",@"Explore-Black_Food & Groceries icon.png",@"Explore-Black_Home & Furniture icon.png",@"Explore-Black_Kids & Babies icon.png",@"Explore-Black_Music icon.png",@"Explore-Black_Pets icon.png",@"Explore-Black_Restaurants & Bars icon.png",@"Explore-Black_Sports & Outdoor icon.png",@"Explore-Black_Travel icon.png",@"Explore-Black_Other icon.png",nil];
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
    ExploreCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!Cell) {
        Cell = [[ExploreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (filtered == YES) {
        Cell.explorelabel.text = [filteredtypes objectAtIndex:indexPath.row];
        NSString *imagestring=[filteredtypes_icons objectAtIndex:indexPath.row];
        Cell.exploreicon.image =[UIImage imageNamed:imagestring];
        
    }
    else {
        Cell.explorelabel.text = [types objectAtIndex:indexPath.row];
        NSString *imagestring=[types_icons objectAtIndex:indexPath.row];
        Cell.exploreicon.image =[UIImage imageNamed:imagestring];
    }
    return Cell;
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        NSIndexPath *indexpath = [self.myTableView indexPathForSelectedRow];
        NSString *string;
        
        if (indexpath.row<[self.filteredtypes count]) {
            string = [self.filteredtypes objectAtIndex:indexpath.row];
            string = [string stringByReplacingOccurrencesOfString:@" & " withString:@"q9j"];
        } else string=@"Unknown";
       [[segue destinationViewController] setCategoryFromExplore:string];
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
    [searchBar resignFirstResponder];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.SearchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.SearchBar resignFirstResponder];
}

-(void) BackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (IBAction)myfeedbutton:(id)sender{
    [self deallocMemory];
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    
}
- (IBAction)morebutton:(id)sender{
    [self deallocMemory];
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:controller animated:NO];
}

- (IBAction)profilebutton:(id)sender{
    [self deallocMemory];
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:controller animated:NO];
}

- (IBAction)Adddeal:(id)sender {
    LockTableButton.alpha=1.0;
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.myTableView.alpha=0.3;}];
    
}

-(IBAction)UNLockButtonAction:(id)sender{
    LockTableButton.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=0.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.myTableView.alpha=1.0;}];
    
}

-(void) AddDealFunction {
    [self deallocMemory];
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:controller animated:NO];
    BlueButtonsView.alpha=0.0;
    LockTableButton.alpha=0.0;
}

-(void)LocalButtonAction:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{self.BlueButtonsView.alpha=0.0;}];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];
}

-(void)OnlineButtonAction:(id)sender{
    
}

-(void) deallocMemory {
    types=nil;
    types_icons=nil;
    filteredtypes=nil;
    filteredtypes_icons=nil;
}
@end
