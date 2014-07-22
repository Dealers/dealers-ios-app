//
//  EditDealTableViewController.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 7/20/14.
//
//

#import <UIKit/UIKit.h>

@interface EditDealTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *discount;

@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *expirationDate;
@property (weak, nonatomic) IBOutlet UILabel *description;

@end
