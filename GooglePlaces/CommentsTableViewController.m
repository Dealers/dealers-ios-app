//
//  CommentsTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/12/14.
//
//

#import "CommentsTableViewController.h"

#define keybaordHeight 216

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
    
    loadedForFirstTime = YES;
    
    [self setTextToolbar];
    [self setTableViewSettings];
    [self setProgressIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIButton *plusButton = (UIButton *)[self.tabBarController.view viewWithTag:123];
    if (plusButton.alpha == 1.0) {
        [appDelegate hidePlusButton];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    UIButton *plusButton = (UIButton *)[self.tabBarController.view viewWithTag:123];
    if (plusButton.alpha == 0) {
        [appDelegate showPlusButton];
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
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    comment.dealer = appDelegate.dealer;
    comment.deal = self.deal;
    comment.uploadDate = [NSDate date];
    comment.type = @"Deal";
    
    [self.comments addObject:comment];
    
    /*
    [[RKObjectManager sharedManager] patchObject:self.deal
                                            path:@"/deals/"
                                      parameters:nil
                                         success:^(RKObjectRequestOperation *operation, RKMappingResult *mapping) {
                                             
                                             [self addCommentToTableView];
                                         }
                                         failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
                                             
                                         }];
     */
    
    [self addCommentToTableView];
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


#pragma mark - Table view data source

- (void)setTableViewSettings {
    
    static NSString *CellIdentifier = @"CommentsTableCell";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    self.cellPrototype = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44.0, 0);
}

- (void)addCommentToTableView
{
    [self.textView resignFirstResponder];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.textView.text = nil;
    self.postButton.enabled = NO;
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.comments.count;
}

- (CGFloat)labelHeight:(UILabel *)label {
    
    CGSize maxSize = CGSizeMake(250.0f, CGFLOAT_MAX);
    CGSize requiredSize = [label sizeThatFits:maxSize];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, requiredSize.width, requiredSize.height);
    
    // Calculate cell height
    CGFloat height = 10.0f + self.cellPrototype.dealerName.frame.size.height + 6.0f + 10.0f + label.frame.size.height;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    
    self.cellPrototype.commentBody.text = comment.text;
    
    CGFloat commentBodyHeight = [self labelHeight:self.cellPrototype.commentBody];
    
    return MAX(commentBodyHeight, 60.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"CommentsTableCell";
    CommentsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    
    cell.dealerProfilePic.image = appDelegate.dealer.photo;
    cell.dealerName.text = comment.dealer.fullName;
    cell.commentDate.text = [comment.dateFormatter stringFromDate:comment.uploadDate];
    cell.commentBody.text = comment.text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
