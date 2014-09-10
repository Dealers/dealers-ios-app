//
//  ActivityTypeWhatsApp.m
//  Dealers
//
//  Created by Gilad Lumbroso on 9/4/14.
//
//

#import "ActivityTypeWhatsApp.h"
#import "ViewonedealViewController.h"

@implementation ActivityTypeWhatsApp

- (NSString *)activityType
{
    return @"WhatsApp Sharing";
}

- (NSString *)activityTitle
{
    return @"WhatsApp";
}

- (UIImage *)_activityImage
{
    return [UIImage imageNamed:@"WhatsApp Icon"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)performActivity
{
    [self activityDidFinish:YES];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

@end
