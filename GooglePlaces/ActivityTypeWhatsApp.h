//
//  ActivityTypeWhatsApp.h
//  Dealers
//
//  Created by Gilad Lumbroso on 9/4/14.
//
//

#import <UIKit/UIKit.h>

@interface ActivityTypeWhatsApp : UIActivity <UIDocumentInteractionControllerDelegate>

- (NSString *)activityType;
- (NSString *)activityTitle;
- (UIImage *)_activityImage;

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;

+ (UIActivityCategory)activityCategory;

@end
