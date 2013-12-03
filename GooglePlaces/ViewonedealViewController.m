//
//  ViewonedealViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "ViewonedealViewController.h"
#import "ViewController.h"
#import "MoreViewController.h"
#import "ProfileViewController.h"
#import "ExploretableViewController.h"
#import "ViewalldealsViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"

@interface ViewonedealViewController ()

@end

@implementation ViewonedealViewController
@synthesize scroll;
@synthesize titlelabel;
@synthesize storelabel;
@synthesize categorylabel;
@synthesize pricelabel;
@synthesize discountlabel;
@synthesize expirelabel;
@synthesize descriptiontext;
@synthesize likelabel;
@synthesize commentlabel;
@synthesize productimage;
@synthesize clientimage,ReturnButton,ReturnButtonFull,BlueButtonsView,OnlineButton,OnlineText,LocalButton,LocalText,LockTableButton;

- (void)viewDidLoad
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    [super viewDidLoad];
    [scroll setScrollEnabled:YES ];
    [scroll setContentSize:((CGSizeMake(320, 600)))];
    titlelabel.text = self.titlefromseg;
    storelabel.text = self.storefromseg;
    categorylabel.text = self.categoryfromseg;
    pricelabel.text = self.pricefromseg;
    discountlabel.text = self.discountfromseg;
    expirelabel.text = self.expirefromseg;
    descriptiontext.text = self.descriptionfromseg;
    likelabel.text = self.likefromseg;
    commentlabel.text = self.commentfromseg;
    
   /* if ([self.photoidfromseg isEqualToString:@"0"]) {
        productimage.image = [UIImage imageNamed:@"My Feed+View Deal_NoPic icon"];
    }
    else
    {
    NSString *URLforphoto = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",self.photoidfromseg];
    productimage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLforphoto]]];
    }*/
    
    productimage.image=app.imageforviewdeal.image;
        
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"Registration_Email button.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 70, 70);
    clientimage.layer.mask = mask;
    clientimage.layer.masksToBounds = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [titlelabel resignFirstResponder];

}

- (IBAction)ReturnButtonAction:(id)sender {
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)myfeedbutton:(id)sender{
    ViewalldealsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myfeeds"];
    [self.navigationController pushViewController:controller animated:NO];
}
- (IBAction)morebutton:(id)sender{
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)profilebutton:(id)sender{
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self.navigationController pushViewController:controller animated:NO];
    
}
- (IBAction)explorebutton:(id)sender{
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)Adddeal:(id)sender {
    LockTableButton.alpha=1.0;
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=1.0;}];
}

-(IBAction)UNLockButtonAction:(id)sender{
    LockTableButton.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=0.0;}];
}

-(void) AddDealFunction {
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:NO completion:nil];
    BlueButtonsView.alpha=0.0;
    LockTableButton.alpha=0.0;
}

-(void)LocalButtonAction:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{self.BlueButtonsView.alpha=0.0;}];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];
}

-(void)OnlineButtonAction:(id)sender{
    
}

@end
