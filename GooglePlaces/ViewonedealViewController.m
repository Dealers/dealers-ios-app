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


-(void) LocateIconsInPlace {
    
    [scroll setScrollEnabled:YES ];
    [scroll setContentSize:((CGSizeMake(320, 600)))];
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"Registration_Email button.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 70, 70);
    clientimage.layer.mask = mask;
    clientimage.layer.masksToBounds = YES;

    self.TitleIcon.center = CGPointMake(28,207);
    self.StoreIcon.center = CGPointMake(28,243);
    self.CategoryIcon.center = CGPointMake(28,279);
    self.PriceIcon.center = CGPointMake(28,315);
    self.ExpireIcon.center = CGPointMake(28,351);
    self.DescriptionIcon.center = CGPointMake(28,385);
    titlelabel.center = CGPointMake(178,206);
    storelabel.center = CGPointMake(178,242);
    categorylabel.center = CGPointMake(178,278);
    pricelabel.center = CGPointMake(86,314);
    discountlabel.center = CGPointMake(160,314);
    expirelabel.center = CGPointMake(178,352);
    descriptiontext.center = CGPointMake(178,394);

    CGRect rect = descriptiontext.frame;
    rect.size.height = descriptiontext.contentSize.height;
    descriptiontext.frame = rect;

    CGSize textSize = [[pricelabel text] sizeWithFont:[pricelabel font]];
    CGFloat strikeWidth = textSize.width;
    
    if (([pricelabel.text isEqualToString:@"0"])&&(![discountlabel.text isEqualToString:@"0"])) {
        pricelabel.hidden=YES;
        discountlabel.center = CGPointMake(86,314);
    }
    if ((![pricelabel.text isEqualToString:@"0"])&&([discountlabel.text isEqualToString:@"0"])) {
        discountlabel.hidden=YES;
    }
    if (([pricelabel.text isEqualToString:@"0"])&&([discountlabel.text isEqualToString:@"0"])) {
        discountlabel.hidden=YES;
        pricelabel.hidden=YES;
    }


    if ((pricelabel.text==NULL)&&([discountlabel.text isEqualToString:@"0"])&&(expirelabel.text!=NULL)&&[descriptiontext.text length]>0)
    {
        self.ExpireIcon.center = CGPointMake(28,315);
        self.DescriptionIcon.center = CGPointMake(28,351);
        expirelabel.center = CGPointMake(178,314);
        descriptiontext.center = CGPointMake(178,352);
        self.PriceIcon.hidden=YES;
        
        int DescriptionMaxY=CGRectGetMaxY(descriptiontext.frame);
        CGRect frame = self.SecondView.frame;
        frame.origin.y = 7+DescriptionMaxY;
        self.SecondView.frame = frame;
    }
    
    if ((pricelabel.text==NULL)&&([discountlabel.text isEqualToString:@"0"])&&(expirelabel.text!=NULL)&&[descriptiontext.text length]>0)
    {
        self.ExpireIcon.center = CGPointMake(28,315);
        self.DescriptionIcon.center = CGPointMake(28,351);
        expirelabel.center = CGPointMake(178,314);
        descriptiontext.center = CGPointMake(178,352);
        self.PriceIcon.hidden=YES;
        
        int DescriptionMaxY=CGRectGetMaxY(descriptiontext.frame);
        CGRect frame = self.SecondView.frame;
        frame.origin.y = 7+DescriptionMaxY;
        self.SecondView.frame = frame;
    }

    
    if (([pricelabel.text isEqualToString:@"0"])&&([discountlabel.text isEqualToString:@"0"])&&(expirelabel.text!=NULL)&&[descriptiontext.text length]==0)
    {
        self.ExpireIcon.center = CGPointMake(28,315);
        expirelabel.center = CGPointMake(178,314);
        self.PriceIcon.hidden=YES;
        self.DescriptionIcon.hidden = YES;
        CGRect frame = self.SecondView.frame;
        frame.origin.y = 335;
        self.SecondView.frame = frame;

    }
    
    if (([pricelabel.text isEqualToString:@"0"])&&([discountlabel.text isEqualToString:@"0"])&&(expirelabel.text==NULL)&&[descriptiontext.text length]==0)
    {
        self.PriceIcon.hidden=YES;
        self.ExpireIcon.hidden = YES;
        self.descriptiontext.hidden = YES;
        CGRect frame = self.SecondView.frame;
        frame.origin.y = 294;
        self.SecondView.frame = frame;

    }
    if (((![pricelabel.text isEqualToString:@"0"])||(![discountlabel.text isEqualToString:@"0"]))&&(expirelabel.text==NULL)&&[descriptiontext.text length]>0)
    {
        self.DescriptionIcon.center = CGPointMake(28,351);
        descriptiontext.center = CGPointMake(178,352);
        self.ExpireIcon.hidden=YES;
        int DescriptionMaxY=CGRectGetMaxY(descriptiontext.frame);
        CGRect frame = self.SecondView.frame;
        frame.origin.y = 7+DescriptionMaxY;
        self.SecondView.frame = frame;

    }
    if (((![pricelabel.text isEqualToString:@"0"])||(![discountlabel.text isEqualToString:@"0"]))&&(expirelabel.text!=NULL)&&[descriptiontext.text length]==0)
    {
        self.DescriptionIcon.hidden=YES;
        CGRect frame = self.SecondView.frame;
        frame.origin.y = 364;
        self.SecondView.frame = frame;
        
    }

}
-(void) LoadVarsFromDeal{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    titlelabel.text = self.titlefromseg;
    storelabel.text = self.storefromseg;
    categorylabel.text = self.categoryfromseg;
    pricelabel.text = self.pricefromseg;
    discountlabel.text = self.discountfromseg;
    expirelabel.text = self.expirefromseg;
    descriptiontext.text = self.descriptionfromseg;
    likelabel.text = self.likefromseg;
    commentlabel.text = self.commentfromseg;
    self.captureImage.image=app.imageforviewdeal.image;
    LikeOrUnlike=TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadVarsFromDeal];
    [self LocateIconsInPlace];
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

- (IBAction)LikeButtonAction:(id)sender {
    if (LikeOrUnlike) {
        [self.LikeButton setImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Like button (selected).png"] forState:UIControlStateNormal];
        LikeOrUnlike=FALSE;
        int IntLike = [likelabel.text intValue];
        IntLike++;
        likelabel.text=[NSString stringWithFormat:@"%d",IntLike];
    } else {
        [self.LikeButton setImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Like button.png"] forState:UIControlStateNormal];
        LikeOrUnlike=TRUE;
        int IntLike = [likelabel.text intValue];
        IntLike--;
        likelabel.text=[NSString stringWithFormat:@"%d",IntLike];
    }
}

- (IBAction)CommentButtonAction:(id)sender {
}
- (IBAction)ShareButtonAction:(id)sender {
}
@end
