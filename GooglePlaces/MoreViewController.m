//
//  MoreViewController.m
//  Dealers
//
//  Created by itzik berrebi on 11/6/13.
//

#import "MoreViewController.h"
#import "ViewonedealViewController.h"
#import "ProfileViewController.h"
#import "ExploretableViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"
#import "OnlineViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"More";
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"aftertapbar";
    _moreListArray=@[@"Groups", @"Follows", @"Tutorial", @"Score Guide"];
    _moreListIconsArray=@[@"More list_Groups icon.png",@"More list_Follows icon.png",@"More list_Tutorial icon.png",@"More list_Score Guide icon.png"];
    
    [self configureRestKit];
    [self loadDeals];
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://dealers-env.elasticbeanstalk.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *dealsManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // validate with username and password
    NSString *username = @"uzi";
    NSString *password = @"090909";
    [dealsManager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    // setup object mappings
    RKObjectMapping *dealMapping = [RKObjectMapping mappingForClass:[Deal class]];
    [dealMapping addAttributeMappingsFromDictionary:@{
                                                      @"url" : @"url",
                                                      @"title" : @"title",
                                                      @"more_description" : @"moreDescription",
                                                      @"type" : @"type",
                                                      @"store" : @"store",
                                                      @"price" : @"price",
                                                      @"currency" : @"currency",
                                                      @"discount_value" : @"discountValue",
                                                      @"discount_type" : @"discountType",
                                                      @"expiration" : @"expiration",
                                                      @"upload_date" : @"uploadDate",
                                                      }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:dealMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/deals/"
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // register mappings with the provider using a request descriptor
    RKRequestDescriptor *requestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:[dealMapping inverseMapping]
                                          objectClass:[Deal class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    [dealsManager addResponseDescriptor:responseDescriptor];
    [dealsManager addRequestDescriptor:requestDescriptor];
}

- (void)loadDeals
{
    //    NSDictionary *queryParams = @{  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/deals/"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.deals = mappingResult.array;
                                                  [self.moreTableView reloadData];
                                                  for (Deal *deal in self.deals) {
                                                      NSLog(@" \n deal title: %@ \n deal price: %@ \n deal currency: %@ \n deal discount: %@ ", deal.title,deal.price,deal.currency,deal.discountValue);
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"There was an error with the loading of the store search: %@", error);
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  [alert show];
                                              }];
    
}

- (void)addDeal:(Deal *)deal
{
    [[RKObjectManager sharedManager] postObject:deal
                                           path:@"/deals/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            NSLog(@"Deal was uploaded successfuly!");
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [alert show];
                                        }];
}

- (void)editDeal:(Deal *)deal
{
    [[RKObjectManager sharedManager] patchObject:deal
                                           path:@"/deals/3/"
                                     parameters:nil
                                        success:nil
                                        failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_moreListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_moreListArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17];
    cell.imageView.image = [UIImage imageNamed:[_moreListIconsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Deal *deal = [[Deal alloc]init];
    
    
    if (indexPath.row == 0) {
        deal.title = @"So, is it working?!@#";
        deal.type = @"L";
        deal.price = [NSNumber numberWithInt:15];
        deal.currency = @"SH";
        deal.uploadDate = [NSDate date];
        [self addDeal:deal];
    }
    
    if (indexPath.row == 1) {
        
        deal.title = @"Edited!";
        [self editDeal:deal];
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}

-(void) deallocMemory {
    
}




@end
