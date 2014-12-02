//
//  DealsTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/1/14.
//
//

#import "DealsTableViewController.h"

#define DEAL_CELL_HEIGHT 209.0f
#define DEAL_CELL_HEIGHT_NO_PHOTO 98.0f

@implementation DealsTableViewController

@synthesize appDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkFeature];
    
    if ([selfViewController isEqualToString:@"My Feed"]) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dealers Logo"]];
    } else if ([selfViewController isEqualToString:@"Explore"]) {
        self.title = self.categoryFromExplore;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosInVisibleCells:)
                                                 name:@"Deals Photos Notifications"
                                               object:nil];
    
    [self initialize];
    [self setRefreshControl];
    [self downloadDeals];
    [self setLoadingView];
}

- (void)checkFeature
{
    if ([self.navigationController.restorationIdentifier isEqualToString:@"feedNavController"]) {
        selfViewController = @"My Feed";
    } else if ([self.navigationController.restorationIdentifier isEqualToString:@"exploreNavController"]) {
        selfViewController = @"Explore";
    }
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.deals = [[NSMutableArray alloc]init];
}

# pragma mark - General methods

- (void)setUpDummyDeals
{
    self.deals = [[NSMutableArray alloc]init];
    
    Deal *deal = [[Deal alloc]init];
    deal.store = [[Store alloc]init];
    
    deal.title = @"Wow great deal go check it out now! :)";
    deal.store.name = @"Castro Raanana Shop";
    deal.price = @(59);
    deal.currency = @"$";
    deal.discountValue = @(20);
    deal.discountType = @"%";
    deal.photoURL1 = @"url";
    
    [self.deals addObject:deal];
    
    deal = [[Deal alloc]init];
    deal.store = [[Store alloc]init];
    
    deal.title = @"Shoes at a really low price! amazing! :)";
    deal.store.name = @"Mango Shop Raanana (1st floor)";
    deal.price = @(59);
    deal.currency = @"$";
    deal.discountValue = @(20);
    deal.discountType = @"%";
    deal.photoURL1 = @"";
    
    [self.deals addObject:deal];
}

- (void)setRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [appDelegate ourPurple];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)refresh
{
    self.deals = [[NSMutableArray alloc]init];
    [self downloadDeals];
}

- (void)downloadDeals
{
    NSString *path;
    NSDictionary *parameters;
    
    if ([selfViewController isEqualToString:@"My Feed"]) {
        path = @"/deals/";
        parameters = nil;
    } else {
        path = @"/dealfilter/";
        parameters = @{@"category": [appDelegate getCategoryKeyForValue:self.categoryFromExplore]};
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:parameters
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [self.deals addObjectsFromArray:mappingResult.array];

                                                  if (!self.deals || self.deals.count == 0) {
                                                      [self stopLoadingAnimation];
                                                      [self noDealMessage];
                                                      
                                                  } else {
                                                      [self.tableView reloadData];
                                                      [self stopLoadingAnimation];
                                                  }
                                                  
                                                  [self.refreshControl endRefreshing];
                                                  
                                                  NSLog(@"\n success! \n number of deals: %lu", (unsigned long)self.deals.count);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"There was an error with the loading of the store search: %@", error);
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  [alert show];
                                              }];
}

- (void)setLoadingView
{
    loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor whiteColor];
    UIImageView *loadingAnimation = [appDelegate loadingAnimationPurple];
    loadingAnimation.tag = 13212;
    [loadingAnimation startAnimating];
    loadingAnimation.frame = CGRectMake(self.view.center.x - 15.0, 15.0, 30.0, 30.0);
    [loadingView addSubview:loadingAnimation];
    [self.tableView addSubview:loadingView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)stopLoadingAnimation
{
    UIImageView *loadingAnimation = (UIImageView *)[loadingView viewWithTag:13212];
    [loadingAnimation stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{ loadingView.alpha = 0; }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)noDealMessage
{
    UILabel *noDealsMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, self.tableView.center.y - 60, 320, 30)];
    [noDealsMessage setFont:[UIFont fontWithName:@"Avenir-Roman" size:18.0]];
    [noDealsMessage setTextAlignment:NSTextAlignmentCenter];
    noDealsMessage.numberOfLines = 0;
    noDealsMessage.center = self.tableView.center;
    noDealsMessage.text = @"There are no deals at this moment!";
    noDealsMessage.textColor = [appDelegate textGrayColor];
    noDealsMessage.alpha = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundView = noDealsMessage;
    
    [UIView animateWithDuration:0.3 animations:^{ noDealsMessage.alpha = 1.0; }];
}

- (void)loadPhotosInVisibleCells:(NSNotification *)notification
{
    NSArray *indexPathes = [self.tableView indexPathsForVisibleRows];
    NSArray *cells = [self.tableView visibleCells];
    
    NSIndexPath *receivedIndexPath = [notification.userInfo objectForKey:@"indexPath"];
    
    for (int i = 0; i < indexPathes.count; i++) {
        
        if ([indexPathes[i] isEqual:receivedIndexPath]) {
            
            DealsTableCell *cell = cells[i];
            cell.photo.image = [notification.userInfo objectForKey:@"image"];
            [UIView animateWithDuration:0.5 animations:^{ cell.photo.alpha = 1.0; }];
            break;
        }
    }
}

- (NSNumber *)setPhotoSum:(Deal *)deal {
    
    if (deal.photoURL1.length > 1 && ![deal.photoURL1 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:0];
    
    if (deal.photoURL2.length > 1 && ![deal.photoURL2 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:1];
    
    if (deal.photoURL3.length > 1 && ![deal.photoURL3 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:2];
    
    if (deal.photoURL4.length > 1 && ![deal.photoURL4 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:3];
    
    return [NSNumber numberWithInt:4];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    int scrollOffset = scrollView.contentOffset.y + self.view.frame.size.height;
//    if (((GAP - scrollOffset) < 200) && (GAP != 0)) {
//        
//        if (!isUpdatingNow) {
//            isUpdatingNow = YES;
//            [self stopWheelAndPresentDeals];
//            
//        }
//    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deal *deal = [self.deals objectAtIndex:indexPath.row];
    
    if (!deal.photoSum) {
        deal.photoSum = [self setPhotoSum:deal];
    }
    
    if (deal.currency.length == 2) {
        deal.currency = [appDelegate getCurrencySign:deal.currency];
    }
    
    if (deal.discountType.length == 2) {
        deal.discountType = [appDelegate getDiscountType:deal.discountType];
    }

    if (deal.photoURL1.length > 1 && ![deal.photoURL1 isEqualToString:@"None"]) {
        
        static NSString *cellIdentifier = @"DealsTableCellID";
        DealsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealsTableCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        // Downloading deal's photo (if haven't been downloaded already)
        
        if (!deal.photo1) {
            cell.photo.alpha = 0;
            [appDelegate downloadPhotosForDeal:deal atIndexPath:indexPath];
        } else {
            cell.photo.alpha = 1.0;
            cell.photo.image = deal.photo1;
        }
        
        // Loading the deal's details to the cell
        
        cell.title.text = deal.title;
        cell.store.text = deal.store.name;
        
        if (deal.dealAttrib.dealersThatLiked.count > 0) {
            cell.likesCounter.hidden = NO;
            cell.likesIcon.hidden = NO;
            cell.likesCounter.text = [NSNumber numberWithUnsignedInteger:deal.dealAttrib.dealersThatLiked.count].stringValue;
        } else {
            cell.likesCounter.hidden = YES;
            cell.likesIcon.hidden = YES;
        }
        
        if (deal.price.floatValue > 0) {
            cell.price.hidden = NO;
            cell.price.text = [deal.currency stringByAppendingString:deal.price.stringValue];
        } else {
            cell.price.hidden = YES;
        }
        
        if (deal.discountValue.floatValue > 0) {
            cell.discount.hidden = NO;
            if ([deal.discountType isEqualToString:@"%"]) {
                cell.discount.text = [deal.discountValue.stringValue stringByAppendingString:deal.discountType];
            } else if ([deal.discountType isEqualToString:@"lastPrice"]){
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSString *lastPriceDiscount = [deal.currency stringByAppendingString:deal.discountValue.stringValue];
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:lastPriceDiscount attributes:attributes];
                cell.discount.attributedText = attrText;
            }
        } else {
            cell.discount.hidden = YES;
        }
    
        return cell;

    } else {
    
        static NSString *cellIdentifier = @"DealsNoPhotoTableCellID";
        DealsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealsNoPhotoTableCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        // Loading the deal's details to the cell
        
        cell.title.text = deal.title;
        cell.store.text = deal.store.name;
        
        if (deal.dealAttrib.dealersThatLiked.count > 0) {
            cell.likesCounter.text = [NSNumber numberWithUnsignedInteger:deal.dealAttrib.dealersThatLiked.count].stringValue;
        } else {
            cell.likesCounter.hidden = YES;
            cell.likesIcon.hidden = YES;
        }
        
        if (deal.price.floatValue > 0) {
            cell.price.text = [deal.currency stringByAppendingString:deal.price.stringValue];
        } else {
            cell.price.hidden = YES;
        }
        
        if (deal.discountValue.floatValue > 0) {
            if ([deal.discountType isEqualToString:@"%"]) {
                cell.discount.text = [deal.discountValue.stringValue stringByAppendingString:deal.discountType];
            } else if ([deal.discountType isEqualToString:@"lastPrice"]){
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSString *lastPriceDiscount = [deal.currency stringByAppendingString:deal.discountValue.stringValue];
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:lastPriceDiscount attributes:attributes];
                cell.discount.attributedText = attrText;
            }
        } else {
            cell.discount.hidden = YES;
        }
        
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deal *deal = [self.deals objectAtIndex:indexPath.row];
    
    if (deal.photoURL1.length > 1 && ![deal.photoURL1 isEqualToString:@"None"]) {
        
        return DEAL_CELL_HEIGHT;
    
    } else {
        
        return DEAL_CELL_HEIGHT_NO_PHOTO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewonedealViewController *vodvc = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    Deal *deal = [self.deals objectAtIndex:indexPath.row];
    vodvc.deal = deal;
    
    if (deal.photoURL1.length > 1 && ![deal.photoURL1 isEqualToString:@"None"]) {
        vodvc.isShortCell = @"no";
    } else vodvc.isShortCell = @"yes";
    
    if ([deal.dealAttrib.dealersThatLiked containsObject:appDelegate.dealer.dealerID]) {
        vodvc.isDealLikedByUser = @"yes";
    } else {
        vodvc.isDealLikedByUser = @"no";
    }
    
    [self.navigationController pushViewController:vodvc animated:YES];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
 */

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
