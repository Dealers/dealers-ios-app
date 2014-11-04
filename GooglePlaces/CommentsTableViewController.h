//
//  CommentsTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/12/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommentsTableCell.h"
#import "Comment.h"
#import "Dealer.h"
#import "MBProgressHUD.h"

@interface CommentsTableViewController : UITableViewController <UITextViewDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *unableToPostComment;
}

@property AppDelegate *appDelegate;

@property NSMutableArray *comments;
@property Deal *deal;

@property BOOL isKeyboardReady;

@property CommentsTableCell *cellPrototype;

@property UIView *textInputView;

@property UITextView *textView;
@property UILabel *placeholder;
@property UIButton *postButton;


@end
