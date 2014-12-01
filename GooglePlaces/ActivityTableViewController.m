//
//  ActivityTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import "ActivityTableViewController.h"
#import "ViewonedealViewController.h"

#define S3_PHOTOS_ADDRESS @"https://s3-eu-west-1.amazonaws.com/dealers-app/"

@interface ActivityTableViewController ()

@end

@implementation ActivityTableViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Activity";
    self.notifications = appDelegate.dealer.notifications;
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.notifications = [[NSMutableArray alloc]init];
    
    Notification *notification1 = [[Notification alloc]initWithRecipient:@"gullumbroso@gmail.com"
                                                                    type:@"Like"
                                                                  dealer:appDelegate.dealer
                                                                    deal:nil
                                                                    date:[NSDate date]];
    [self.notifications addObject:notification1];
    
    Notification *notification2 = [[Notification alloc]initWithRecipient:@"gullumbroso@gmail.com"
                                                                    type:@"Comment"
                                                                  dealer:appDelegate.dealer
                                                                    deal:nil
                                                                    date:[NSDate date]];
    [self.notifications addObject:notification2];
    
    Notification *notification3 = [[Notification alloc]initWithRecipient:@"gullumbroso@gmail.com"
                                                                    type:@"Share"
                                                                  dealer:appDelegate.dealer
                                                                    deal:nil
                                                                    date:[NSDate date]];
    [self.notifications addObject:notification3];
    
    Notification *notification4 = [[Notification alloc]initWithRecipient:@"gullumbroso@gmail.com"
                                                                    type:@"Edit Deal"
                                                                  dealer:appDelegate.dealer
                                                                    deal:nil
                                                                    date:[NSDate date]];
    [self.notifications addObject:notification4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableCell *cell = (NotificationTableCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
    
    [self loadProfilePicInNotification:notification cell:cell];
    
    if ([notification.type isEqualToString:@"Like"]) {
        
        cell.label.text = [notification.dealer.fullName stringByAppendingString:@" likes your deal."];
        
    } else if ([notification.type isEqualToString:@"Comment"]) {
        
        cell.label.text = [notification.dealer.fullName stringByAppendingString:@" commented on your deal."];
        
    } else if ([notification.type isEqualToString:@"Share"]) {
        
        cell.label.text = [notification.dealer.fullName stringByAppendingString:@" Shared your deal."];
        
    } else if ([notification.type isEqualToString:@"Edit Deal"]) {
        
        cell.label.text = [notification.dealer.fullName stringByAppendingString:@" Edited your deal."];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ViewonedealViewController *vodvc = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
    
    vodvc.deal = notification.deal;
    
    [self.navigationController pushViewController:vodvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

#pragma mark - General methods

- (void)loadProfilePicInNotification:(Notification *)notification cell:(NotificationTableCell *)cell
{
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        
        NSString *profilePicID = notification.dealer.photoURL;
        
        if (profilePicID.length > 0) {
            
            NSString *URLForPhoto = [S3_PHOTOS_ADDRESS stringByAppendingString:profilePicID];
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:URLForPhoto]];
            self.notificationPhoto = [[UIImage alloc]initWithData:imageData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.image.alpha = 0;
            cell.image.image = self.notificationPhoto;
            [UIView animateWithDuration:0.3 animations:^{ cell.image.alpha = 1.0; }];
        });
    });
}



@end
