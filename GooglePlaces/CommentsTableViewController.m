//
//  CommentsTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/12/14.
//
//

#import "CommentsTableViewController.h"
#import "ViewDealViewController.h"

#define keybaordHeight 216
#define NO_COMMENTS_MESSAGE_TAG 54325
#define NAME_FOR_NOTIFICATIONS @"Comments Photos Notifications"
static NSString * const CommentCellIdentifier = @"CommentTableViewCell";


@interface CommentsTableViewController () {
    
    BOOL loadedForFirstTime;
    CGFloat textViewHeight;
    CGRect textInputFrame;
    CGFloat textViewOldHeight;
}

@end

@implementation CommentsTableViewController

@synthesize appDelegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Comments", nil);
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosToView:)
                                                 name:NAME_FOR_NOTIFICATIONS
                                               object:nil];
    
    loadedForFirstTime = YES;
    [self setHidesBottomBarWhenPushed:NO];
    [self setTextToolbar];
    [self setTableViewSettings];
    [self setProgressIndicator];
    [self setNoCommentsMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *plusButton = (UIButton *)[self.tabBarController.view viewWithTag:123];
    if (plusButton.alpha == 1.0) {
        [appDelegate hidePlusButton];
    }
    if (self.tabBarController.tabBar.hidden == NO) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Comments Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIButton *plusButton = (UIButton *)[self.tabBarController.view viewWithTag:123];
    if (plusButton.alpha == 0) {
        [appDelegate showPlusButton];
    }
    
    id viewController = [[self.navigationController viewControllers] objectAtIndex:self.navigationController.viewControllers.count -  1];
    if ([viewController isKindOfClass:[ViewDealViewController class]]) {
        ViewDealViewController *vdvc = viewController;
        vdvc.didChangesInComments = self.didChanges;
        vdvc.deal.comments = self.comments;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self keyboardShouldBeReady];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNoCommentsMessage
{
    if (self.comments.count == 0) {
        
        UILabel *noCommentsMessage = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                              100.0,
                                                                              self.tableView.frame.size.width,
                                                                              30.0)];
        noCommentsMessage.text = NSLocalizedString(@"No Comments...", nil);
        noCommentsMessage.textAlignment = NSTextAlignmentCenter;
        noCommentsMessage.font = [UIFont fontWithName:@"Avenir-Roman" size:22.0];
        noCommentsMessage.textColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:205.0/255.0 alpha:1.0];
        noCommentsMessage.tag = NO_COMMENTS_MESSAGE_TAG;
        
        [self.tableView addSubview:noCommentsMessage];
        
    }
}

- (void)removeNoCommentMessage
{
    if ([self.tableView viewWithTag:NO_COMMENTS_MESSAGE_TAG]) {
        
        UILabel *noCommentsMessage = (UILabel *)[self.tableView viewWithTag:NO_COMMENTS_MESSAGE_TAG];
        
        [UIView animateWithDuration:0.3
                         animations:^{ noCommentsMessage.alpha = 0; }
                         completion:^(BOOL finished) { [noCommentsMessage removeFromSuperview]; }];
    }
}

- (void)setTextToolbar
{
    CGFloat width = self.view.frame.size.width + 2;
    CGFloat height = 44;
    
    self.textInputView = [[UIView alloc]initWithFrame:CGRectMake(-1, self.view.frame.size.height - height, width, height)];
    
    self.textInputView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.textInputView.layer.borderWidth = 0.5;
    self.textInputView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0]CGColor];
    self.textInputView.tintColor = [UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:1.0];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 6, self.view.frame.size.width - 45 * 2, 32)];
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 5.0;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0]CGColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    textViewHeight = self.textView.frame.size.height;
    [self.textView setTextContainerInset:UIEdgeInsetsMake(5, 0, 5, 0)];
    self.textView.returnKeyType = UIReturnKeyDone;
    
    self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, self.textView.frame.size.width - 6 * 2, 44)];
    self.placeholder.font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
    self.placeholder.text = NSLocalizedString(@"Write a comment...", nil);
    self.placeholder.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:206.0/255.0 alpha:1.0];
    
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        [self.placeholder setTextAlignment:NSTextAlignmentRight];
    }
    
    self.postButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.postButton setFrame:CGRectMake(self.view.frame.size.width - 50.0, 0, 50.0, height)];
    [self.postButton setTitle:NSLocalizedString(@"Post", nil) forState:UIControlStateNormal];
    [[self.postButton titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:16.0]];
    [self.postButton addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    self.postButton.enabled = NO;
    
    [self.textInputView addSubview:self.textView];
    [self.textInputView addSubview:self.placeholder];
    [self.textInputView addSubview:self.postButton];
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
    
}

- (UIView *)inputAccessoryView {
    
    return self.textInputView;
    
}

- (void)keyboardShouldBeReady
{
    if (self.isKeyboardReady) {
        
        [self.textView becomeFirstResponder];
        self.isKeyboardReady = NO;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, keybaordHeight + 44.0, 0);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count - 1 inSection:0];
    
    if (self.comments.count > 0) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44.0, 0);
}

-(void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        
        self.placeholder.hidden = YES;
        self.postButton.enabled = YES;
        
    } else {
        
        self.placeholder.hidden = NO;
        self.postButton.enabled = NO;
    }
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([textView.text stringByTrimmingCharactersInSet:set].length == 0) {
        
        self.postButton.enabled = NO;
    }
    
    /*
     
     CGFloat textViewFixedWidth = textView.frame.size.width;
     CGSize newSize = [textView sizeThatFits:CGSizeMake(textViewFixedWidth, CGFLOAT_MAX)];
     CGRect newFrame = textView.frame;
     newFrame.size = CGSizeMake(fmaxf(newSize.width, textViewFixedWidth), newSize.height);
     
     [UIView animateWithDuration:0.3 animations:^{ textView.frame = newFrame; }];
     
     if (textViewOldHeight == 0) {
     textViewOldHeight = textView.frame.size.height;
     }
     
     if (textInputFrame.size.height == 0) {
     textInputFrame = self.textInputView.frame;
     }
     
     if (textViewOldHeight != textView.frame.size.height) {
     
     //        if (textViewOldHeight < textView.frame.size.height) {
     //
     //            textInputFrame.origin.y -= 22.0;
     //
     //        } else {
     //
     //            textInputFrame.origin.y += 22.0;
     //        }
     
     textInputFrame.size.height = textView.frame.size.height + 12.0;
     
     textViewOldHeight = textView.frame.size.height;
     
     [UIView animateWithDuration:0.3 animations:^{
     textView.inputAccessoryView.frame = textInputFrame;
     self.textInputView.frame = textInputFrame;
     }];
     }
     
     */
}

// Setting the return button as Done:

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)postComment {
    
    Comment *comment = [[Comment alloc]init];
    
    comment.text = self.textView.text;
    comment.dealID = self.deal.dealID;
    comment.dealer = appDelegate.dealer;
    comment.uploadDate = [NSDate date];
    comment.type = @"Deal";
    
    self.textView.text = nil;
    self.placeholder.hidden = NO;
    self.postButton.enabled = NO;
    
    [[RKObjectManager sharedManager] postObject:comment
                                           path:@"/addcomments/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mapping) {
                                            
                                            NSLog(@"Comment uploaded successfuly!");
                                            [self removeNoCommentMessage];
                                            [self.comments addObject:comment];
                                            [self addCommentToTableView];
                                            self.didChanges = YES;
                                            
                                            if (self.deal.dealer.dealerID.intValue != appDelegate.dealer.dealerID.intValue) {
                                                [appDelegate sendNotificationOfType:@"Comment"
                                                                       toRecipients:@[self.deal.dealer.dealerID]
                                                                   regardingTheDeal:self.deal.dealID];
                                            }
                                            
                                            [self sendNotificationsToAllCommenters];
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            [unableToPostComment show:YES];
                                            [unableToPostComment hide:YES afterDelay:1.5];
                                        }];
}

- (void)sendNotificationsToAllCommenters
{
    NSMutableArray *recipients = [[NSMutableArray alloc] init];

    for (Comment *comment in self.comments) {
        
        if (comment.dealer.dealerID.intValue != appDelegate.dealer.dealerID.intValue
            && comment.dealer.dealerID.intValue != self.deal.dealer.dealerID.intValue) {
            [recipients addObject:comment.dealer.dealerID];
        }
    }
    
    if (recipients.count > 0) {
        [appDelegate sendNotificationOfType:@"Also Commented"
                               toRecipients:recipients
                           regardingTheDeal:self.deal.dealID];
    }
}

- (void)setProgressIndicator
{
    
    unableToPostComment = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    unableToPostComment.delegate = self;
    unableToPostComment.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    unableToPostComment.mode = MBProgressHUDModeCustomView;
    unableToPostComment.labelText = NSLocalizedString(@"Unable to post comment", nil);
    unableToPostComment.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    unableToPostComment.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:unableToPostComment];
}

- (void)loadPhotosToView:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    if ([[info objectForKey:@"target"] isEqualToString:@"Commenter's Photo"]) {
        
        NSArray *indexPathes = [self.tableView indexPathsForVisibleRows];
        
        NSIndexPath *receivedIndexPath = [info objectForKey:@"indexPath"];
        
        for (int i = 0; i < indexPathes.count; i++) {
            
            if ([indexPathes[i] isEqual:receivedIndexPath]) {
                
                CommentTableViewCell *cell = (CommentTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPathes[i]];
                
                [cell.dealerProfilePic setImage:[info objectForKey:@"image"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.3 animations:^{ cell.dealerProfilePic.alpha = 1.0; }];
                break;
            }
        }
    }
}

- (void)commenterProfileButtonClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    Comment *comment = [self.comments objectAtIndex:button.tag];
    ProfileTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    ptvc.dealerID = comment.dealer.dealerID;
    [self.navigationController pushViewController:ptvc animated:YES];
}


#pragma mark - Table view data source

- (void)setTableViewSettings
{
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 74.0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addCommentToTableView
{
    [self.textView resignFirstResponder];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.postButton.enabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self commentCellForIndexPath:indexPath];
}

- (CommentTableViewCell *)commentCellForIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CommentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.comments objectAtIndex:indexPath.row];

    [self setDealerImageForCell:cell comment:comment indexPath:indexPath];
    [self setDealerProfileLinkForCell:cell indexPath:indexPath];
    [self setBasicDetailsForCell:cell comment:comment];    
}

- (void)setDealerImageForCell:(CommentTableViewCell *)cell comment:(Comment *)comment indexPath:(NSIndexPath *)indexPath
{
    if (comment.dealer.dealerID.intValue == self.appDelegate.dealer.dealerID.intValue) {
        [cell.dealerProfilePic setImage:[appDelegate myProfilePic] forState:UIControlStateNormal];
    } else if (!comment.dealer.photo) {
        if (!comment.dealer.downloadingPhoto) {
            comment.dealer.downloadingPhoto = YES;
            [appDelegate otherProfilePic:comment.dealer forTarget:@"Commenter's Photo" notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:indexPath];
        }
    } else {
        [cell.dealerProfilePic setImage:[UIImage imageWithData:comment.dealer.photo] forState:UIControlStateNormal];
    }
}

- (void)setDealerProfileLinkForCell:(CommentTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell.dealerProfilePic setTag:indexPath.row];
    [cell.dealerProfilePic addTarget:self action:@selector(commenterProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dealerName setTag:indexPath.row];
    [cell.dealerName addTarget:self action:@selector(commenterProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBasicDetailsForCell:(CommentTableViewCell *)cell comment:(Comment *)comment
{
    [cell.dealerName setTitle:comment.dealer.fullName forState:UIControlStateNormal];
    cell.commentDate.text = [comment.dateFormatter stringFromDate:comment.uploadDate];
    cell.commentBody.text = comment.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath];
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    static CommentTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
        if (!sizingCell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil];
            sizingCell = [nib objectAtIndex:0];
        }
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}


@end
