//
//  PushNotification.m
//  Dealers
//
//  Created by Gilad Lumbroso on 1/25/15.
//
//

#import "PushNotificationView.h"

@implementation PushNotificationView

@synthesize appDelegate;

- (PushNotificationView *)initWithDelegate:(UIWindow *)container
{
    _containerWindow = container;
    self = [self initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
    return self;
}

- (PushNotificationView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        if (_containerWindow) {
            [_containerWindow addSubview:self];
        }
        
        return self;
    }
    return nil;
}

- (void)layoutSubviews
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setBarTintColor:[UIColor blackColor]];
    self.translucent = YES;
    
    if (!self.notificationPhoto) {
        self.notificationPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 40, 40)];
        self.notificationPhoto.layer.cornerRadius = self.notificationPhoto.frame.size.width / 2;
        self.notificationPhoto.layer.masksToBounds = YES;
        self.notificationPhoto.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.notificationPhoto];
    }
    
    if (!self.message) {
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, [UIScreen mainScreen].bounds.size.width - 65 - 30, 40)];
        self.message.numberOfLines = 0;
        self.message.font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
        self.message.textColor = [UIColor whiteColor];
        [self addSubview:self.message];
    }
    
    if (!self.hideNotificationButton) {
        self.hideNotificationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.hideNotificationButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30 - 5, 16, 30, 30)];
        [self.hideNotificationButton setImage:[UIImage imageNamed:@"Dismiss Notification"] forState:UIControlStateNormal];
        [self.hideNotificationButton setTintColor:[UIColor lightGrayColor]];
        [self.hideNotificationButton addTarget:self action:@selector(hideNotification) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.hideNotificationButton];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.deal) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ViewonedealViewController *vodvc = [storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
        vodvc.deal = self.deal;
        
        [self hideNotification];
        [appDelegate presentNotificationOfType:@"deal"];
    }
}

- (void)presentNotification
{
    appDelegate.pushNotificationsWindow.hidden = NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y = 0;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                         [self performSelector:@selector(hideNotification) withObject:nil afterDelay:5.0];
                     }];
}

- (void)hideNotification
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y = -64;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         appDelegate.pushNotificationsWindow.hidden = YES;
                         appDelegate.pushedDeal = nil;
                         appDelegate.notifyingDealer = nil;
                     }];
}


@end
