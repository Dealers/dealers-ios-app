//
//  ComingSoonViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/4/14.
//
//

#import "ComingSoonViewController.h"

@interface ComingSoonViewController ()

@end

@implementation ComingSoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"Activity";
    }
    
    if (self.messageContent.length > 0) {

        self.message.text = self.messageContent;
        
    } else {
        
        self.message.text = @"In Activity you will see notifications regarding your recent activity at Dealers.";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"Navigation Bar Shade"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
