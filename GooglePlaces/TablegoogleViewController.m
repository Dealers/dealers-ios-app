//
//  TablegoogleViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/23/13.
//
//

#import "TablegoogleViewController.h"
#import "CellGoole.h"


@interface TablegoogleViewController ()

@end

@implementation TablegoogleViewController

- (void)viewDidLoad
{
    self.googletable.dataSource = self;
    self.googletable.delegate = self;

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setGoogletable:nil];
    [self setGoogletable:nil];
    [super viewDidUnload];
}
@end
