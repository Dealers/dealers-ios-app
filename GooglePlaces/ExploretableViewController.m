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
    ExploreCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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



//////////////////////
//// tapbar //////////
//////////////////////


-(void) func {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"foursquare";
    app.onlineOrLocal=@"local";
    WhereIsTheDeal *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"whereIsTheDealID"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) func2 {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"online";
    app.onlineOrLocal=@"online";
    OnlineViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineView"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) goToOnline {
    [self hideLocalOrOnlineView];
    [self performSelector:@selector(func2) withObject:nil afterDelay:0.5];
}

-(void) goToAddDeal {
    [self hideLocalOrOnlineView];
    [self performSelector:@selector(func) withObject:nil afterDelay:0.1];
    
}

-(void) tapBarSet {
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Tab Bar@2X.png"]];
    [imageview setFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height)-69, ([[UIScreen mainScreen] bounds].size.width), 50)];
    [[self view] addSubview:imageview];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Explore button (selected)@2X.png"]];
    [imageview2 setFrame:CGRectMake(74, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview2];
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_More button@2X.png"]];
    [imageview3 setFrame:CGRectMake(276, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview3];
    
    UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_My Feed button@2X.png"]];
    [imageview4 setFrame:CGRectMake(19, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview4];
    
    UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Profile button@2X.png"]];
    [imageview5 setFrame:CGRectMake(218, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview5];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(56, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label.text=@"Explore";
    label.backgroundColor=[UIColor clearColor];
    label.textColor = [UIColor colorWithRed:150/255.0 green:0/255.0 blue:180/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(258, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label2 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label2.text=@"More";
    label2.backgroundColor=[UIColor clearColor];
    label2.textColor = [UIColor lightGrayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label2];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(1, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label3 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label3.text=@"My Feed";
    label3.backgroundColor=[UIColor clearColor];
    label3.textColor =  [UIColor lightGrayColor];
    label3.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label3];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(200, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label4 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label4.text=@"Profile";
    label4.backgroundColor=[UIColor clearColor];
    label4.textColor = [UIColor lightGrayColor];
    label4.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label4];
    
    
    UIButton *selectDealButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton setImage:[UIImage imageNamed:@"My Feed+View Deal_Add Deal button@2X.png"] forState:UIControlStateNormal];
    selectDealButton.frame=CGRectMake(129, ([[UIScreen mainScreen] bounds].size.height)-75,62,56);
    [selectDealButton addTarget:self action:@selector(showLocalOrOnlineView:) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton.tag=120;
    [[self view] addSubview:selectDealButton];
    
    UIButton *selectDealButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton2 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton2.frame=CGRectMake(10, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton2 addTarget:self action:@selector(myFeedClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton2];
    
    UIButton *selectDealButton3=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton3 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton3.frame=CGRectMake(65, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton3 addTarget:self action:@selector(exploreClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton3];
    
    UIButton *selectDealButton4=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton4 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton4.frame=CGRectMake(209, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton4 addTarget:self action:@selector(profileClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton4];
    
    UIButton *selectDealButton5=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton5 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton5.frame=CGRectMake(267, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton5 addTarget:self action:@selector(moreClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton5];
    
    
    //////////////////////
    //// blue buttons ////
    //////////////////////
    
    UIButton *selectDealButton6=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton6 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton6.frame=CGRectMake(0, 0,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-68));
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height-44);
    selectDealButton6.tag=100;
    [selectDealButton6 setBackgroundColor:[UIColor whiteColor]];
    [selectDealButton6 addTarget:self action:@selector(hideLocalOrOnlineView) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton6.alpha=0.0;
    [[self view] addSubview:selectDealButton6];
    
    UIButton *selectDealButton9=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton9 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton9.frame=CGRectMake(0, 0,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-68));
    selectDealButton9.tag=110;
    [selectDealButton9 setBackgroundColor:[UIColor whiteColor]];
    selectDealButton9.alpha=0.0;
    [[self view] addSubview:selectDealButton9];
    
    UIButton *selectDealButton7=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton7 setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton7 setImage:[UIImage imageNamed:@"Add Deal (Final)_Local button.png"] forState:UIControlStateNormal];
    selectDealButton7.frame=CGRectMake(55, ([[UIScreen mainScreen] bounds].size.height)-210,90,90);
    selectDealButton7.tag=101;
    [selectDealButton7 addTarget:self action:@selector(goToAddDeal) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton7.alpha=0.0;
    [[self view] addSubview:selectDealButton7];
    
    UIButton *selectDealButton8=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton8 setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton8 setImage:[UIImage imageNamed:@"Add Deal (Final)_Online button.png"] forState:UIControlStateNormal];
    selectDealButton8.frame=CGRectMake(175, ([[UIScreen mainScreen] bounds].size.height)-210,90,90);
    selectDealButton8.tag=102;
    [selectDealButton8 addTarget:self action:@selector(goToOnline) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton8.alpha=0.0;
    [[self view] addSubview:selectDealButton8];
    
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(55, ([[UIScreen mainScreen] bounds].size.height)-110, 90, 16)];
    [label5 setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
    label5.text=@"Local Store";
    label5.backgroundColor=[UIColor clearColor];
    label5.textColor = [UIColor colorWithRed:0/255 green:122/255 blue:255/255 alpha:1.0];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.tag=103;
    label5.alpha=0.0;
    [[self view] addSubview:label5];
    
    UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(175, ([[UIScreen mainScreen] bounds].size.height)-110, 90, 16)];
    [label6 setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
    label6.text=@"The Web";
    label6.backgroundColor=[UIColor clearColor];
    label6.textColor = [UIColor colorWithRed:0/255 green:122/255 blue:255/255 alpha:1.0];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.tag=104;
    label6.alpha=0.0;
    [[self view] addSubview:label6];
    
    UILabel *label7=[[UILabel alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height)-251, 320, 22)];
    [label7 setFont:[UIFont fontWithName:@"Avenir-Light" size:22.0]];
    label7.text=@"Add deal from?";
    label7.backgroundColor=[UIColor clearColor];
    label7.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.tag=105;
    label7.alpha=0.0;
    [[self view] addSubview:label7];
    
}

-(void) myFeedClicked:(id)sender {
    [self deallocMemory];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
}

-(void) exploreClicked:(id)sender {
}

-(void) moreClicked:(id)sender {
    [self deallocMemory];
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) profileClicked:(id)sender {
    [self deallocMemory];
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) hideLocalOrOnlineView {
    NSLog(@"remove cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    UILabel *label3 = (UILabel*)[self.view viewWithTag:105];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        button1.alpha=0.0;
        button2.alpha=0.0;
        button3.alpha=0.0;
        label1.alpha=0.0;
        label2.alpha=0.0;
        label3.alpha=0.0;
    }];
    
}

-(void) showLocalOrOnlineView:(id)sender {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UIButton *button4 = (UIButton*)[self.view viewWithTag:120];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    UILabel *label3 = (UILabel*)[self.view viewWithTag:105];
    [self.view bringSubviewToFront:button4];
    
    [UIView animateWithDuration:0.5 animations:^{
        button1.alpha=0.9;
        button2.alpha=1.0;
        button3.alpha=1.0;
        label1.alpha=1.0;
        label2.alpha=1.0;
        label3.alpha=1.0;
    }];
    
}

-(void) showWhiteCover {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:120];
    [self.view bringSubviewToFront:button1];
    [self.view bringSubviewToFront:button2];
    button1.alpha=0.8;
}

//-(void) removeWhiteCover {
//    NSLog(@"remove white cover");
//    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
//    button1.alpha=0.0;
//}


@end
