//
//  ExploretableViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 10/4/13.
//
//

#import <UIKit/UIKit.h>

@interface ExploretableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *types;
@property (nonatomic, strong) NSMutableArray *types_icons;

@property (nonatomic, strong) NSMutableArray *filteredtypes;
@property (nonatomic, strong) NSMutableArray *filteredtypes_icons;
@property BOOL filtered;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;

-(IBAction)BackButton:(id)sender;
- (IBAction)Adddeal:(id)sender;
- (IBAction)myfeedbutton:(id)sender;
- (IBAction)morebutton:(id)sender;
- (IBAction)profilebutton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *BlueButtonsView;
@property (weak, nonatomic) IBOutlet UIButton *LocalButton;
@property (weak, nonatomic) IBOutlet UIButton *OnlineButton;
@property (weak, nonatomic) IBOutlet UIButton *LockTableButton;
@property (weak, nonatomic) IBOutlet UILabel *OnlineText;
@property (weak, nonatomic) IBOutlet UILabel *LocalText;
- (IBAction)LocalButtonAction:(id)sender;
- (IBAction)OnlineButtonAction:(id)sender;
- (IBAction)UNLockButtonAction:(id)sender;

@end
