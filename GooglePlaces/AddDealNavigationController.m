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

    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Add Deal Navigation Bar Background"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
