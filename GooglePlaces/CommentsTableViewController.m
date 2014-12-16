//
//  CommentsTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/12/14.
//
//

#import "CommentsTableViewController.h"
#import "ViewonedealViewController.h"

#define keybaordHeight 216
#define NO_COMMENTS_MESSAGE_TAG 54325
#define NAME_FOR_NOTIFICATIONS @"Comments Photos Notifications"

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
    
    self.title = @"Comments";
    
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
    UIButton *plusButton = (UIButton *)[self.tabBarController.view viewWithTag:123];
    if (plusButton.alpha == 1.0) {
        [appDelegate hidePlusButton];
    }
    if (self.tabBarController.tabBar.hidden == NO) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    UIButton *plusButton = (UIButton *)[self.tabBarController.view viewWithTag:123];
    if (plusButton.alpha == 0) {
        [appDelegate showPlusButton];
    }
    
    id viewController = [[self.navigationController viewControllers] objectAtIndex:self.navigationController.viewControllers.count -  1];
    if ([viewController isKindOfClass:[ViewonedealViewController class]]) {
        ViewonedealViewController *vodvc = viewController;
        vodvc.didChangesInComments = self.didChanges;
        vodvc.deal.comments = self.comments;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
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
        noCommentsMessage.text = @"No Comments...";
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
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(40, 6, self.view.frame.size.width - 45 * 2, 32)];
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
    
    self.placeholder = [[UILabel alloc]initWithFrame:CGRectMake(46, 0, self.view.frame.size.width - 44 * 2, 44)];
    self.placeholder.font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
    self.placeholder.text = @"Write a comment...";
    self.placeholder.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:206.0/255.0 alpha:1.0];
    
    self.postButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.postButton setFrame:CGRectMake(self.view.frame.size.width - 50.0, 0, 50.0, height)];
    [self.postButton setTitle:@"Post" forState:UIControlStateNormal];
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

-(void)postComment {
    
    Comment *comment = [[Comment alloc]init];
    
    comment.text = self.textView.text;
    comment.dealerID = appDelegate.dealer.dealerID;
    comment.dealID = self.deal.dealID;
    comment.dealerFullName = appDelegate.dealer.fullName;
    comment.dealerPhotoURL = appDelegate.dealer.photoURL;
    comment.uploadDate = [NSDate date];
    comment.type = @"Deal";
    
    [[RKObjectManager sharedManager] postObject:comment
                                           path:@"/addcomments/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mapping) {
                                            
                                            NSLog(@"Comment uploaded successfuly!");
                                            [self removeNoCommentMessage];
                                            [self.comments addObject:comment];
                                            [self addCommentToTableView];
                                            self.didChanges = YES;
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            [unableToPostComment show:YES];
                                            [unableToPostComment hide:YES afterDelay:1.5];
                                        }];
}

- (void)setProgressIndicator
{
    
    unableToPostComment = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    unableToPostComment.delegate = self;
    unableToPostComment.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    unableToPostComment.mode = MBProgressHUDModeCustomView;
    unableToPostComment.labelText = @"Unable to post comment";
    unableToPostComment.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    unableToPostComment.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:unableToPostComment];
}

- (void)loadPhotosToView:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    if ([[info objectForKey:@"target"] isEqualToString:@"Commenter's Photo"]) {
        
        CommentsTableCell *cell = [info objectForKey:@"cell"];
        cell.dealerProfilePic.alpha = 0;
        [cell.dealerProfilePic setImage:[info objectForKey:@"image"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            cell.dealerProfilePic.alpha = 1;
        }];
    }
}

- (void)commenterProfileButtonClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    Comment *comment = [self.comments objectAtIndex:button.tag];
    ProfileTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    ptvc.dealerID = comment.dealerID;
    [self.navigationController pushViewController:ptvc animated:YES];
}

- (CGFloat)setCommentBodyHeightWithText:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize boundingRect = CGSizeMake(250.0 ,MAXFLOAT);
    CGRect commentBodyFrame = [text boundingRectWithSize:boundingRect
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];
    
    CGFloat height = ceil(commentBodyFrame.size.height);
    return height;
}


#pragma mark - Table view data source

- (void)setTableViewSettings {
    
    static NSString *CellIdentifier = @"CommentsTableCell";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    self.cellPrototype = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 74.0, 0);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addCommentToTableView
{
    [self.textView resignFirstResponder];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.textView.text = nil;
    self.postButton.enabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.comments.count;
}

- (CGFloat)labelHeight:(UILabel *)label {
    
    CGSize maxSize = CGSizeMake(250.0f, CGFLOAT_MAX);
    CGSize requiredSize = [label sizeThatFits:maxSize];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, requiredSize.width, requiredSize.height);
    
    // Calculate cell height
    CGFloat height = 12.0f + self.cellPrototype.dealerName.frame.size.height + 6.0f + 12.0f + label.frame.size.height;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    
    self.cellPrototype.commentBody.text = comment.text;
    
    CGFloat commentBodyHeight = [self labelHeight:self.cellPrototype.commentBody];
    
    return MAX(commentBodyHeight, 64.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CommentsTableCell";
    CommentsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentsTableCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (!cell.dealerProfilePic.imageView.image) {
        if (comment.dealerID.intValue == self.appDelegate.dealer.dealerID.intValue) {
            [cell.dealerProfilePic setImage:[appDelegate myProfilePic] forState:UIControlStateNormal];
        } else {
            [appDelegate otherProfilePic:comment.dealerPhotoURL forTarget:@"Commenter's Photo" notificationName:NAME_FOR_NOTIFICATIONS inCell:cell];
        }
    }
    
    [cell.dealerProfilePic setTag:indexPath.row];
    [cell.dealerProfilePic addTarget:self action:@selector(commenterProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.dealerName setTitle:comment.dealerFullName forState:UIControlStateNormal];
    [cell.dealerName setTag:indexPath.row];
    [cell.dealerName addTarget:self action:@selector(commenterProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.commentDate.text = [comment.dateFormatter stringFromDate:comment.uploadDate];
    cell.commentBody.text = comment.text;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.contentView layoutSubviews];
    
    NSLog(@"\n\nComment body size: %f, %f", cell.commentBody.frame.size.width, cell.commentBody.frame.size.height);
    
    return cell;
}


@end
