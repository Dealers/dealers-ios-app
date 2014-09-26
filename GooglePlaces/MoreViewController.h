//
//  MoreViewController.h
//  Dealers
//
//  Created by itzik berrebi on 11/6/13.
//
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) NSArray *moreListArray;
@property (strong,nonatomic) NSArray *moreListIconsArray;
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;

@property (nonatomic) NSArray *deals;

@end
