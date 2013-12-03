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
#import "ViewController.h"
#import "MoreViewController.h"
#import "ProfileViewController.h"
#import "ViewalldealsViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"

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
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.SearchBar.delegate=self;
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"aftertapbar";

    types = [[NSMutableArray alloc] initWithObjects:@"Amusement & Entertainment",@"Art",@"Automotive",@"Beauty & Personal Care",@"Books & Magazines",@"Electronics",@"Events",@"Fashion",@"Food & Groceries",@"Home & Furniture",@"Jewelry & Watches",@"Kitchen",@"Kids & Babies",@"Music",@"Pets",@"Real Estate",@"Restaurants & Bars",@"Sports & Outdoor",@"Travel",@"Other", nil];

    types_icons = [[NSMutableArray alloc] initWithObjects:@"Explore_Amusment & Entertainment icon.png",@"Explore_Art icon.png",@"Explore_Automotive icon.png",@"Explore_Beauty & Personal Care icon.png",@"Explore_Books & Magazines icon.png",@"Explore_Electronics icon.png",@"Explore_Events icon.png",@"Explore_Fashion icon.png",@"Explore_Food & Groceries icon.png",@"Explore_Home & Furniture icon.png",@"Explore_Jewelry & Watches icon.png",@"Explore_Kitchen icon.png",@"Explore_Kids & Babies icon.png",@"Explore_Music icon.png",@"Explore_Pets icon.png",@"Explore_Real Estate icon.png",@"Explore_Restaurants & Bars icon.png",@"Explore_Sports & Outdoor icon.png",@"Explore_Travel icon.png",@"Explore_Other icon.png",nil];
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

-(void) BackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (IBAction)myfeedbutton:(id)sender{
    ViewalldealsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myfeeds"];
    [self.navigationController pushViewController:controller animated:NO];
}
- (IBAction)morebutton:(id)sender{
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)profilebutton:(id)sender{
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self.navigationController pushViewController:controller animated:NO];
    
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
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:NO completion:nil];
    BlueButtonsView.alpha=0.0;
    LockTableButton.alpha=0.0;
    self.myTableView.alpha=1.0;

}

-(void)LocalButtonAction:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{self.BlueButtonsView.alpha=0.0;}];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];
}

-(void)OnlineButtonAction:(id)sender{
    
}

@end
