//
//  TablegoogleViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/23/13.
//
//

#import <UIKit/UIKit.h>

@interface TablegoogleViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *googletable;

@end
