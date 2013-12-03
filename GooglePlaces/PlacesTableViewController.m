//
//  PlacesTableViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/23/13.
//
//

#import "PlacesTableViewController.h"

@interface PlacesTableViewController ()

@end

@implementation PlacesTableViewController

- (void)viewDidLoad
{
    self.tableviewgoogle.dataSource = self;
    self.tableviewgoogle.delegate = self;

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableviewgoogle:nil];
    [super viewDidUnload];
}
@end
