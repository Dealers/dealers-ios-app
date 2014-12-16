//
//  ComingSoonViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/4/14.
//
//

#import <UIKit/UIKit.h>

@interface ComingSoonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *featureImage;

@property NSString *messageContent;

@end
