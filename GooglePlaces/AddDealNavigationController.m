//
//  AddDealNavigationController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/27/14.
//
//

#import "AddDealNavigationController.h"

@interface AddDealNavigationController ()

@end

@implementation AddDealNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIImage *imageNavBar = [UIImage imageNamed:@"Add Deal Navigation Bar Background"];
    imageNavBar = [imageNavBar stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [self.navigationBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
