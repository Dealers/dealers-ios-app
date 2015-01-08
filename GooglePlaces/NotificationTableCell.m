//
//  NotificationTableCell.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import "NotificationTableCell.h"
#import "Notification.h"
#import "Dealer.h"

@implementation NotificationTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.notificationImagePlaceholder.layer.cornerRadius = self.notificationImagePlaceholder.frame.size.width / 2;
    self.notificationImagePlaceholder.layer.masksToBounds = YES;
    self.notificationImage.layer.cornerRadius = self.notificationImage.frame.size.width / 2;
    self.notificationImage.layer.masksToBounds = YES;
    
    self.date.hidden = YES;
}

+ (NSString *)notificationStringForObject:(id)object
{
    if ([object isMemberOfClass:[Notification class]]) {
        
        Notification *notification = object;
        NSString *fullName = notification.dealer.fullName;
        NSString *notificationString;
        
        if ([notification.type isEqualToString:@"Like"]) {
            
            notificationString = @"likes your deal.";
            
        } else if ([notification.type isEqualToString:@"Comment"]) {
            
            notificationString = @"commented on your deal.";
            
        } else if ([notification.type isEqualToString:@"Also Commented"]) {
            
            notificationString = @"also commented on this deal.";
            
        } else if ([notification.type isEqualToString:@"Share"]) {
            
            notificationString = @"shared your deal.";
            
        } else if ([notification.type isEqualToString:@"Edit"]) {
            
            notificationString = @"edited your deal.";
        }
        
        return [NSString stringWithFormat:@"%@ %@", fullName, notificationString];
    
    
    } else {
        
        NSMutableArray *notificationsGroup = object;
        
        Notification *notification1 = [notificationsGroup objectAtIndex:0];
        Notification *notification2 = [notificationsGroup objectAtIndex:1];
        
        NSString *fullName1 = notification1.dealer.fullName;
        NSString *fullName2 = notification2.dealer.fullName;
        
        NSString *notificationString;
        
        if ([notification1.type isEqualToString:@"Like"]) {
            
            notificationString = @"like your deal.";
            
        } else if ([notification1.type isEqualToString:@"Comment"]) {
            
            notificationString = @"commented on your deal.";
            
        } else if ([notification1.type isEqualToString:@"Also Commented"]) {
            
            notificationString = @"also commented on this deal.";
            
        } else if ([notification1.type isEqualToString:@"Share"]) {
            
            notificationString = @"shared your deal.";
            
        } else if ([notification1.type isEqualToString:@"Edit"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"There is a problem!"
                                                            message:@"Notification of type \"Edit\" shouldn't be in a group."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        if (notificationsGroup.count == 2) {
            
            return [NSString stringWithFormat:@"%@ & %@ %@", fullName1, fullName2, notificationString];
        
        } else if (notificationsGroup.count > 2) {
            
            return [NSString stringWithFormat:@"%@, %@ & %@ more people %@", fullName1, fullName2, [NSNumber numberWithUnsignedInteger:notificationsGroup.count - 2], notificationString];
        }
    }
    
    return nil;
}

@end
