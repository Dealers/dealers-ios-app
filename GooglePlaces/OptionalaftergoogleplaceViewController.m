//
//  OptionalViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/25/13.
//
//
#import <Social/Social.h>
#import "OptionalaftergoogleplaceViewController.h"
#import "AppDelegate.h"
#import "ViewalldealsViewController.h"
#import "TableViewController.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface OptionalaftergoogleplaceViewController ()

@end

@implementation OptionalaftergoogleplaceViewController
@synthesize dealphoto;
@synthesize categorylabel;
@synthesize pricelabel;
@synthesize discountlabel;
@synthesize expirationlabel;
@synthesize descriptionlabel;
@synthesize facebookicon;
@synthesize twiiticon;
@synthesize groupicon;
@synthesize facebook;
@synthesize twitter;
@synthesize whatsapp;
@synthesize whatsappicon;
@synthesize group;
@synthesize list;
@synthesize scroll;
@synthesize CategoryNavBar;
@synthesize CategoryPicker;
@synthesize PriceNavBar,DollarButton,ShekelButton,DatePicker,DateNavBar,ChagrtoDate,ChagrtoTime,ChangetodateFull,ChangetotimeFull,DollarButtonFull,ShekelButtonFull,PoundButtonFull,PoundButton,PersentButton,PersentButtonFull,LoadingDeal,ReturnButtonFull,ReturnButton,Coverblack,LoadingImage,DoneButton,imagePreview,captureImage,stillImageOutput,titlelabel,mapView,TrashButton,AddAnotherPicButton,PicFromLibButton,RotateCamButton,ExitCameraButton,MoreView,AddDealButton,SocialView,scrollcamera,SnapButton, captureImage2,captureImage3,captureImage4,BlackCoverImage,morebutton,MoreButtonButton,GrayCoverView,FlashView,SnapButton2,DescriptionTextView,imagePicker,popoverController,PageControl;


-(void) BackgroundMethod {
        dealphotoid=@"0";
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([app.didaddphoto isEqualToString:@"yes"]) {
        dealphoto=app.savedphoto;
        
        NSData *imagedata = UIImageJPEGRepresentation(captureImage.image, 2);
        NSString *urlString = @"http://www.dealers.co.il/uploadphpFile.php";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imagedata]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        dealphotoid = returnString;
    }
    /////////
    if ([app.didaddphoto isEqualToString:@"no"]) {
        dealphotoid=@"0";
    }
    NSString *price=@"0";
    NSLog(@"prce=%@",pricelabel);
    if ([pricelabel.text length]>0) {
        price=pricelabel.text;
    }
    NSString *discount=@"0";
    if ([discountlabel.text length]>0) {
        discount=discountlabel.text;
    }

    app.AfterAddDeal = @"yes";
    
    app.CategoryName = [app.CategoryName stringByReplacingOccurrencesOfString:@" & " withString:@"q9j"];
    titlelabel.text = [titlelabel.text stringByReplacingOccurrencesOfString:@"&" withString:@"q9j"];
    self.segstore = [self.segstore stringByReplacingOccurrencesOfString:@"&" withString:@"q9j"];
    descriptionlabel.text = [descriptionlabel.text stringByReplacingOccurrencesOfString:@"&" withString:@"q9j"];
    NSLog(@"tile=%@",titlelabel.text);
    NSLog(@"tile=%@",app.CategoryName);
    NSLog(@"tile=%@",self.segstore);
    NSLog(@"tile=%@",descriptionlabel.text);

    NSString *newString;
    NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/dealphpFile.php?Title='"];
    newString = [strURL stringByAppendingString:titlelabel.text];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Description='"];
    newString = [newString stringByAppendingString:descriptionlabel.text];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Store='"];
    newString = [newString stringByAppendingString:self.segstore];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Price='"];
    newString = [newString stringByAppendingString:price];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Discount='"];
    newString = [newString stringByAppendingString:discount];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Expire='"];
    newString = [newString stringByAppendingString:expirationlabel.text];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Photoid='"];
    newString = [newString stringByAppendingString:dealphotoid];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Category='"];
    newString = [newString stringByAppendingString:app.CategoryName];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Sign='"];
    newString = [newString stringByAppendingString:sign];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Clientid='"];
    newString = [newString stringByAppendingString:app.UserID];
    newString = [newString stringByAppendingString:@"'"];
    strURL = newString;
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"strURL=%@",strURL);

    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"result=%@\n",strResult);
    
    [self performSelectorOnMainThread:@selector(MainMethod) withObject:nil waitUntilDone:NO];

}

-(void) MainMethod {
    [self performSelector:@selector(DoneFunc) withObject:nil afterDelay:3];
    
    
}

-(void) DeallocMemory {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
app.savedphoto=NULL;
app.imageforviewdeal=NULL;
app.globaltitlelabel=NULL;
app.globalstorelabel=NULL;
app.photoid=NULL;
app.FavButtonDidPress=NULL;
app.didaddphoto=NULL;
app.TITLEMARRAY=NULL;
app.DESCRIPTIONMARRAY=NULL;
app.STOREMARRAY=NULL;
app.PRICEMARRAY=NULL;
app.DISCOUNTMARRAY=NULL;
app. EXPIREMARRAY=NULL;
app.LIKEMARRAY=NULL;
app.COMMENTMARRAY=NULL;
app.CLIENTMARRAY=NULL;
app.PHOTOIDMARRAY=NULL;
app.PHOTOIDMARRAYCONVERT=NULL;
app.FAVARRAY=NULL;
app.CATEGORYARRAY=NULL;
app.SIGNARRAY=NULL;
app.DEALIDARRAY=NULL;
app.USERSIDSARRAY=NULL;
app.CategoryName=NULL;
    app=NULL;
}
-(void) DoneFunc {
    [self DeallocMemory];
    TableViewController *vc=[[TableViewController alloc]init];
    [vc DeallocMemory];
    
   /* ViewalldealsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myfeeds"];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navi animated:YES completion:nil];*/

    UINavigationController * navigationController = self.navigationController;
    //ViewalldealsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myfeeds"];
    [navigationController popToRootViewControllerAnimated:NO];
    //[navigationController presentViewController:controller animated:YES completion:nil];
    
}

-(void) initialize {
    titlelabel.text=@"";
    expirationlabel.text=@"";
    descriptionlabel.text=@"";
    categorylabel.text=@"";
}

- (void)viewDidLoad
{
    [self initialize];
    PageControl.hidden=YES;
    Flag = true;
    updown_moreoption = true;
    currentpage=0;
    BlackCoverImage.hidden=YES;
   // [self initializeCamera];

    [self ReduceScroll];
    [self EnlargeCameraScroll];
    [scroll setScrollEnabled:YES];
    [scrollcamera setScrollEnabled:YES];
    [scrollcamera setBackgroundColor:[UIColor blackColor]];    
    TrashButton.hidden=YES;
    AddAnotherPicButton.hidden=YES;
    FrontCamera = NO;
    captureImage.hidden = YES;
    LoadingDeal.hidden=YES;
    [super viewDidLoad];
    //UIColor *colorOne = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
    //self.scroll.backgroundColor=colorOne;

    sign=@"1";
    facebook = @"a";
    whatsapp = @"a";
    group = @"a";
    twitter = @"a";
    morebutton = @"a";
    descriptionlabel.tag=1;
    pricelabel.tag=2;
    discountlabel.tag=3;
    titlelabel.tag=4;
    DescriptionTextView.tag=5;
    ChangetotimeFull.alpha=0.0;
    ChangetodateFull.alpha=1.0;
    ChagrtoDate.alpha=0.0;
    DollarButtonFull.alpha=1.0;
    DollarButton.alpha=0.0;

    ShekelButtonFull.alpha=0.0;
    PoundButtonFull.alpha=0.0;
    PersentButton.alpha=0.0;
    PersentButtonFull.alpha=1.0;
    Coverblack.alpha=0.0;
    FlashView.alpha=0.0;
    SnapButton2.alpha=0.0;
    
    [self.titlelabel setDelegate:self];
    [self.titlelabel setReturnKeyType:UIReturnKeyDone];
    [self.titlelabel addTarget:self action:@selector(titlelabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.categorylabel setDelegate:self];
    [self.categorylabel setReturnKeyType:UIReturnKeyDone];
    [self.categorylabel addTarget:self action:@selector(categorylabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.pricelabel setDelegate:self];
    [self.pricelabel setReturnKeyType:UIReturnKeyDone];
    [self.pricelabel addTarget:self action:@selector(pricelabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.discountlabel setDelegate:self];
    [self.discountlabel setReturnKeyType:UIReturnKeyDone];
    [self.discountlabel addTarget:self action:@selector(discountlabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.expirationlabel setDelegate:self];
    [self.expirationlabel setReturnKeyType:UIReturnKeyDone];
    [self.expirationlabel addTarget:self action:@selector(expirationlabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.descriptionlabel setDelegate:self];
    [self.descriptionlabel setReturnKeyType:UIReturnKeyDone];
    [self.descriptionlabel addTarget:self action:@selector(descriptionlabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    list = [[NSMutableArray alloc] initWithObjects:@"Automotive",@"Art",@"Beauty & Personal Care"@"Book & Magazines",@"Electronics",@"Entertainment & Events",@"Fashion",@"Food & Groceries",@"Home & Furniture",@"Kids & Babies",@"Music",@"Pets",@"Restaurants & Bars",@"Sports & Outdoor",@"Travel",@"Other",nil];
    
    [scrollcamera setScrollEnabled:NO];
    mapView.showsUserLocation = YES;
    mapView.zoomEnabled = NO;
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager startUpdatingLocation];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = locationManager.location.coordinate.latitude;
    location.longitude = locationManager.location.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    categorylabel.text=app.CategoryName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)adddealbutton:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{Coverblack.alpha=1.0;}];
    LoadingDeal.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{LoadingDeal.alpha=1.0; LoadingDeal.transform =CGAffineTransformMakeScale(0.8,0.8);
        LoadingDeal.transform =CGAffineTransformMakeScale(1,1);}];
    LoadingImage.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"loading.png"],
                                    [UIImage imageNamed:@"loading5.png"],
                                    [UIImage imageNamed:@"loading10.png"],
                                    [UIImage imageNamed:@"loading15.png"],
                                    [UIImage imageNamed:@"loading20.png"],
                                    [UIImage imageNamed:@"loading25.png"],
                                    [UIImage imageNamed:@"loading30.png"],
                                    [UIImage imageNamed:@"loading35.png"],
                                    [UIImage imageNamed:@"loading40.png"],
                                    [UIImage imageNamed:@"loading45.png"],
                                    [UIImage imageNamed:@"loading50.png"],
                                    [UIImage imageNamed:@"loading55.png"],
                                    [UIImage imageNamed:@"loading60.png"],
                                    [UIImage imageNamed:@"loading65.png"],
                                    [UIImage imageNamed:@"loading70.png"],
                                    [UIImage imageNamed:@"loading75.png"],
                                    [UIImage imageNamed:@"loading80.png"],
                                    [UIImage imageNamed:@"loading85.png"],
                                    nil];
    LoadingImage.animationDuration = 0.3;
    [LoadingImage startAnimating];
    [UIView animateWithDuration:0.2 animations:^{LoadingImage.alpha=1.0; LoadingImage.transform =CGAffineTransformMakeScale(0,0);
        LoadingImage.transform =CGAffineTransformMakeScale(1,1);}];
    

    [self performSelectorInBackground:@selector(BackgroundMethod) withObject:nil];
    

}


- (IBAction)groupbutton:(id)sender {
    if ([group isEqual:@"a"]){
        [groupicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Groups button (selected).png"] forState:UIControlStateNormal];
        group=@"b";
    }
    else {
        [groupicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Groups button.png"] forState:UIControlStateNormal];
        group=@"a";
    }
}

- (IBAction)whatsappbutton:(id)sender {
    if ([whatsapp isEqual:@"a"]){
        [whatsappicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via WhatsApp button (selected).png"] forState:UIControlStateNormal];
        whatsapp=@"b";
        
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        NSString *strURL = [NSString stringWithFormat:@"whatsapp://send?text=Check this great deal:"];
        strURL = [strURL stringByAppendingString:@" "];
        strURL = [strURL stringByAppendingString:app.globaltitlelabel.text];
        strURL = [strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL *whatappURL = [NSURL URLWithString:strURL];
        if ([[UIApplication sharedApplication] canOpenURL:whatappURL]) {
            [[UIApplication sharedApplication] openURL:whatappURL];
        }
        
        }
    else {
        [whatsappicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via WhatsApp button.png"] forState:UIControlStateNormal];
        whatsapp=@"a";
    }
}
- (IBAction)facebookbutton:(id)sender {
    
    if ([facebook isEqual:@"a"]){
        [facebookicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Facebook button (selected).png"] forState:UIControlStateNormal];
        facebook=@"b";

      //  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *facebookview = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            NSString *post = @"try my new app";
            [facebookview setInitialText:post];
            //[facebookview addImage:[UIImage imageNamed:@"Launch App Icons_iPhone.png"]];
            [self presentViewController:facebookview animated:YES completion:Nil];
            
            SLComposeViewControllerCompletionHandler completion = ^(SLComposeViewControllerResult result) {
                switch (result) {
                    case SLComposeViewControllerResultDone:
                        NSLog(@"poasted!");
                        break;
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"cancelled!");
                        break;
                    default:
                        break;
                }
                [facebookview dismissViewControllerAnimated:YES completion:nil];
            };
            facebookview.completionHandler = completion;
        //}
    }
    else {
        
        [facebookicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Facebook button.png"] forState:UIControlStateNormal];
        facebook=@"a";
    }
}

- (IBAction)twittbutton:(id)sender {
    
    if ([twitter isEqual:@"a"]){
        [twiiticon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Twitter button (selected).png"] forState:UIControlStateNormal];
        twitter=@"b";
    }
    
    else {
        [twiiticon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Twitter button.png"] forState:UIControlStateNormal];
        twitter=@"a";
    }
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        categorylabel.text = [list objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [list count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [list objectAtIndex:row];
}

/*
- (IBAction)DollarButtonAction:(id)sender {
}

- (IBAction)DiscountButtonAction:(id)sender {
}*/

- (IBAction)ExpireButtonAction:(id)sender {
    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    [titlelabel resignFirstResponder];

    [self EnlargeScroll]; //960
    
    [UIView animateWithDuration:0.5 animations:^{DatePicker.center = CGPointMake(160, 352);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 222);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 222);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 222);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 222);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 222);}];

    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 340);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 700);}];

    

}
- (IBAction)CateoryButtonAction:(id)sender {
    [pricelabel resignFirstResponder];
    [titlelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    [self EnlargeScroll]; //960?
    
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 290);}];

    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 700);}];

    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 352);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 222);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 700);}];

}

- (IBAction)Cateory_DoneButtonAction:(id)sender {
    [self EnlargeScroll];
   // [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];

}

-(void) keyboardWillShow {
}

-(void) keyboardWillHide {
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    descriptionlabel.hidden=YES;
    
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 350);}];
    
    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 700);}];
    
    [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];
    return true;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (updown_moreoption) {
        [self ReduceScroll];
    } else [self EnlargeScroll];
    
    [scroll setScrollEnabled:YES];
    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    [DescriptionTextView resignFirstResponder];
    [titlelabel resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 700);}];
    
    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];

    
    return true;

}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    [self EnlargeScroll];

    if (textField.tag==1) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 350);}];

        [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 700);}];
        [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 700);}];
        [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 700);}];
        [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 700);}];
        [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 700);}];
        [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 700);}];

        [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 700);}];
        [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 700);}];
        [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 700);}];
        [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 700);}];
        [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 700);}];
        [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 700);}];
        [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];

        
    } if ((textField.tag==2)||(textField.tag==3)) {
        [UIView animateWithDuration:0.3 animations:^{PriceNavBar.center = CGPointMake(160, 225);}];
        [UIView animateWithDuration:0.3 animations:^{DollarButton.center = CGPointMake(18, 225);}];
        [UIView animateWithDuration:0.3 animations:^{ShekelButton.center = CGPointMake(53, 225);}];
        [UIView animateWithDuration:0.3 animations:^{PoundButton.center = CGPointMake(90, 225);}];
        [UIView animateWithDuration:0.3 animations:^{DollarButtonFull.center = CGPointMake(18, 225);}];
        [UIView animateWithDuration:0.3 animations:^{ShekelButtonFull.center = CGPointMake(53, 225);}];
        [UIView animateWithDuration:0.3 animations:^{PoundButtonFull.center = CGPointMake(90, 225);}];
        
        [UIView animateWithDuration:0.3 animations:^{CategoryPicker.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.3 animations:^{CategoryNavBar.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.3 animations:^{DatePicker.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.3 animations:^{ChagrtoTime.center = CGPointMake(20, 700);}];
        [UIView animateWithDuration:0.3 animations:^{ChagrtoDate.center = CGPointMake(50, 700);}];
        [UIView animateWithDuration:0.3 animations:^{DateNavBar.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.3 animations:^{ChangetotimeFull.center = CGPointMake(20, 700);}];
        [UIView animateWithDuration:0.3 animations:^{ChangetodateFull.center = CGPointMake(50, 700);}];
        [UIView animateWithDuration:0.3 animations:^{PersentButton.center = CGPointMake(18, 225);}];
        [UIView animateWithDuration:0.3 animations:^{PersentButtonFull.center = CGPointMake(18, 225);}];
        [UIView animateWithDuration:0.3 animations:^{DoneButton.center = CGPointMake(285, 225);}];

    }
    
    if (textField.tag==4) {

        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 100);}];

        DollarButtonFull.hidden=YES;
        DollarButton.hidden=YES;
        PoundButton.hidden=YES;
        PoundButtonFull.hidden=YES;
        ShekelButtonFull.hidden=YES;
        ShekelButton.hidden=YES;
        PersentButtonFull.hidden=YES;
        PersentButton.hidden=YES;

    }
    if (textField.tag==2) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 310);}];

        DollarButtonFull.hidden=NO;
        DollarButton.hidden=NO;
        PoundButton.hidden=NO;
        PoundButtonFull.hidden=NO;
        ShekelButtonFull.hidden=NO;
        ShekelButton.hidden=NO;
        PersentButtonFull.hidden=YES;
        PersentButton.hidden=YES;
    }
    
    if (textField.tag==3) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 310);}];

        DollarButtonFull.hidden=YES;
        DollarButton.hidden=YES;
        PoundButton.hidden=YES;
        PoundButtonFull.hidden=YES;
        ShekelButtonFull.hidden=YES;
        ShekelButton.hidden=YES;
        PersentButtonFull.hidden=NO;
        PersentButton.hidden=NO;
    }

    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (updown_moreoption) {
        [self ReduceScroll];
    } else [self EnlargeScroll];
    
    [scroll setScrollEnabled:YES];
    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    [DescriptionTextView resignFirstResponder];
    [titlelabel resignFirstResponder];

    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 700);}];

    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];

   // [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    return YES;
    }

- (IBAction)ShekelButtonAction:(id)sender {
    sign=@"1";
    ShekelButtonFull.alpha=1.0;
    ShekelButton.alpha=0.0;
    PoundButtonFull.alpha=0.0;
    PoundButton.alpha=1.0;
    DollarButtonFull.alpha=0.0;
    DollarButton.alpha=1.0;
}

- (IBAction)DollarButtonAction:(id)sender {
    sign=@"2";
    ShekelButtonFull.alpha=0.0;
    ShekelButton.alpha=1.0;
    PoundButtonFull.alpha=0.0;
    PoundButton.alpha=1.0;
    DollarButtonFull.alpha=1.0;
    DollarButton.alpha=0.0;
}

-(IBAction)PoundButtonAction:(id)sender{
    sign=@"3";
    ShekelButtonFull.alpha=0.0;
    ShekelButton.alpha=1.0;
    PoundButtonFull.alpha=1.0;
    PoundButton.alpha=0.0;
    DollarButtonFull.alpha=0.0;
    DollarButton.alpha=1.0;
}

- (IBAction)Date_DoneButtonAction:(id)sender {

    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    [titlelabel resignFirstResponder];
    [self EnlargeScroll];
    
    //[UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    [UIView animateWithDuration:0.5 animations:^{DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ChagrtoTime.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ChangetotimeFull.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];


    NSDate *select = [DatePicker date];
    NSString *selecteddate = [[NSString alloc]initWithFormat:@"%@",select];
    
    NSArray *datearray = [selecteddate componentsSeparatedByString:@" "];
    
    NSString *first = [datearray objectAtIndex:0];
    NSString *second = [datearray objectAtIndex:1];
    
    NSArray *reversedate = [first componentsSeparatedByString:@"-"];
    
    NSString *day = [reversedate objectAtIndex:2];
    NSString *mounth = [reversedate objectAtIndex:1];
    NSString *year = [reversedate objectAtIndex:0];
    NSString *space = @"-";
    NSString *space2 = @"   ";

    NSString *date = [[NSString alloc] initWithString:day];
    date = [date stringByAppendingString:space];
    date = [date stringByAppendingString:mounth];
    date = [date stringByAppendingString:space];
    date = [date stringByAppendingString:year];
    date = [date stringByAppendingString:space2];
    date = [date stringByAppendingString:second];
    
    expirationlabel.text=date;
    

}
- (IBAction)ChagrtoDateAction:(id)sender {
    DatePicker.datePickerMode=UIDatePickerModeDate;
    ChangetotimeFull.alpha=0.0;
    ChangetodateFull.alpha=1.0;
    ChagrtoDate.alpha=0.0;
    ChagrtoTime.alpha=1.0;
}

- (IBAction)ChagrtoTimeAction:(id)sender {
    DatePicker.datePickerMode=UIDatePickerModeDateAndTime;
    ChangetotimeFull.alpha=1.0;
    ChangetodateFull.alpha=0.0;
    ChagrtoTime.alpha=0.0;
    ChagrtoDate.alpha=1.0;
}

- (IBAction)ChangetotimeFullAction:(id)sender {
    DatePicker.datePickerMode=UIDatePickerModeDateAndTime;
    ChangetotimeFull.alpha=1.0;
    ChangetodateFull.alpha=0.0;
    ChagrtoTime.alpha=0.0;
    ChagrtoDate.alpha=1.0;

}
- (IBAction)ChangetodateFullAction:(id)sender {
    DatePicker.datePickerMode=UIDatePickerModeDate;
    ChangetotimeFull.alpha=0.0;
    ChangetodateFull.alpha=1.0;
    ChagrtoDate.alpha=0.0;
    ChagrtoTime.alpha=1.0;
}

-(IBAction)PersentButtonAction:(id)sender {
    PersentButton.alpha=0.0;
    PersentButtonFull.alpha=1.0;
}

- (IBAction)ReturnButtonAction:(id)sender {
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) DoneButtonAction:(id)sender {
    if (updown_moreoption) {
        [self ReduceScroll];
    } else [self EnlargeScroll];

    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    [titlelabel resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 700);}];
    
  //  [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    
}

//AVCaptureSession to show live video feed in view
- (void) initializeCamera {
    session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = self.imagePreview.bounds;
	[self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
	
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
	
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
	[session startRunning];
    
}


- (IBAction)snapImage:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{self.FlashView.alpha=1.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.SnapButton2.alpha=1.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.SnapButton.alpha=0.0;}];
    [self capImage];
    [self performSelector:@selector(Flash) withObject:nil afterDelay:2];

}

-(void) Flash {
    [UIView animateWithDuration:1.0 animations:^{self.FlashView.alpha=0.0;}];
}

-(void) CameraMode {
    [self initializeCamera];
    PageControl.hidden=YES;
    BlackCoverImage.hidden=YES;
    captureImage.hidden = YES;
    imagePreview.hidden = NO;
    RotateCamButton.hidden=NO;
    TrashButton.hidden=YES;
    AddAnotherPicButton.hidden=YES;
    PicFromLibButton.hidden=NO;
    SnapButton.hidden=NO;
    ExitCameraButton.hidden=NO;
    [scrollcamera setScrollEnabled:NO];
    SnapButton.alpha=1.0;
    SnapButton2.alpha=0.0;
    [scrollcamera setContentSize:((CGSizeMake(320, 155)))];
}

-(void) ImageslideMode {
    PageControl.hidden=NO;
    PageControl.numberOfPages=numofpics;
    [session stopRunning];
    SnapButton.alpha=0.0;
    SnapButton2.alpha=0.0;
    BlackCoverImage.hidden=NO;
    currentpage=0;
    ExitCameraButton.hidden=YES;
    captureImage.hidden = NO; //show the captured image view
    imagePreview.hidden = YES; //hide the live video feed
    RotateCamButton.hidden=YES;
    SnapButton.hidden=YES;
    PicFromLibButton.hidden=YES;
    TrashButton.hidden=NO;
    if (numofpics == 4) {
        AddAnotherPicButton.hidden=YES;
    } else AddAnotherPicButton.hidden=NO;
    [self EnlargeCameraScroll];
    }


- (void) capImage { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}


- (void) processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    haveImage = YES;
    CGSize size3 = [image size];

    CGRect rect = CGRectMake(0,0,320,(size3.height*320)/size3.width);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *imgLarge=[UIImage imageWithData:imageData];
    CGSize size = [imgLarge size];

    // Create rectangle that represents a cropped image
    // from the middle of the existing image
    CGRect rect2 = CGRectMake(2,(size.height / 3)-10,310,155);
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([imgLarge CGImage], rect2);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    
    
    
   /* CGSize itemSize = CGSizeMake(300,365); // give any size you want to give
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    

/*
        UIGraphicsBeginImageContext(CGSizeMake(320, 155));
        [image drawInRect: CGRectMake(0, 0, 320, 155)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGRect cropRect = CGRectMake(0, 0, 300, 155);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    */
    if (numofpics==0) {
        //[captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        captureImage.image=img;
    }
    if (numofpics==1) {
        //[captureImage2 setImage:[UIImage imageWithCGImage:imageRef]];
        captureImage2.image=img;
    }
    if (numofpics==2) {
        //[captureImage3 setImage:[UIImage imageWithCGImage:imageRef]];
        captureImage3.image=img;
    }
    if (numofpics==3) {
        //[captureImage4 setImage:[UIImage imageWithCGImage:imageRef]];
        captureImage4.image=img;
    }
    numofpics++;
    [self oreder];
    [self EnlargeCameraScroll];
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.didaddphoto=@"yes";
    [self ImageslideMode];
      //  CGImageRelease(imageRef);
}


- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
    
}

-(void) ExitCameraButtonAction:(id)sender {
    if (numofpics>0) {
        [self ImageslideMode];
    }
}

-(void) TrashButtonAction:(id)sender {
    
    NSLog(@"page=%d",currentpage);
    if (currentpage==0) {
        if (numofpics==1) {
            captureImage.image=nil;
        }
        if (numofpics==2) {
            captureImage.image=captureImage2.image;
            captureImage2.image=nil;
        }
        if (numofpics==3) {
            captureImage.image=captureImage2.image;
            captureImage2.image=captureImage3.image;
            captureImage3.image=nil;
        }
        if (numofpics==4) {
            captureImage.image=captureImage2.image;
            captureImage2.image=captureImage3.image;
            captureImage3.image=captureImage4.image;
            captureImage4.image=nil;
        }

    }
    if (currentpage==1) {
        if (numofpics==2) {
            captureImage2.image=nil;
        }
        if (numofpics==3) {
            captureImage2.image=captureImage3.image;
            captureImage3.image=nil;
        }
        if (numofpics==4) {
            captureImage2.image=captureImage3.image;
            captureImage3.image=captureImage4.image;
            captureImage4.image=nil;
        }
    }
    
    if (currentpage==2) {
        if (numofpics==3) {
            captureImage3.image=nil;
        } else{
        captureImage3.image=captureImage4.image;
        captureImage4.image=nil;
        }
    }

    if (currentpage==3) {
        captureImage4.image=nil;
    }

    numofpics--;
    [self ImageslideMode];
    if (numofpics==0) {
    [self CameraMode];
    }
}

-(void) AddAnotherPicButtonAction:(id)sender{
    [self CameraMode];
}

-(void) RotateCamButtonAction:(id)sender {
    
    if (Flag) {
        FrontCamera = YES;
        Flag = false;
        [self initializeCamera];
    }
    else {
        FrontCamera = NO;
        Flag = true;
        [self initializeCamera];
    }
}

-(void) PicFromLibButtonAction:(id)sender {
    
    self.imagePicker = [[GKImagePicker alloc] init];
  //  self.imagePicker.cropSize = CGSizeMake(310,155);
   self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];

    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:nil];*/
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"here/n/n/n");
    if (numofpics==0) {
        captureImage.image=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    if (numofpics==1) {
        captureImage2.image=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    if (numofpics==2) {
        captureImage3.image=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    if (numofpics==3) {
        captureImage4.image=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    numofpics++;
    [self oreder];
    NSLog(@"numofpicafterlib %d",numofpics);
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.didaddphoto=@"yes";
    [self ImageslideMode];
}


-(void) MoreButtonAction:(id)sender {
    
    if ([morebutton isEqual:@"a"]){
        [MoreButtonButton setImage:[UIImage imageNamed:@"Add Deal (Final)_More Details button (selected).png"] forState:UIControlStateNormal];
        morebutton=@"b";
    }
    
    else {
        [MoreButtonButton setImage:[UIImage imageNamed:@"Add Deal (Final)_More Details button.png"] forState:UIControlStateNormal];
        morebutton=@"a";
    }

    
    if (updown_moreoption) {
        [self EnlargeScroll];
        //[UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 220);}];
        CGRect frame3 = MoreView.frame;
        frame3.origin.y = frame3.origin.y + 190;
        [UIView animateWithDuration:0.6 animations:^{MoreView.frame = frame3;}];

        CGRect frame = AddDealButton.frame;
        frame.origin.y = frame.origin.y + 200;
        [UIView animateWithDuration:0.6 animations:^{AddDealButton.frame = frame;}];
        CGRect frame2 = SocialView.frame;
        frame2.origin.y = frame2.origin.y + 200;
        [UIView animateWithDuration:0.6 animations:^{SocialView.frame = frame2;}];
        updown_moreoption = false;
    } else {
        [self ReduceScroll];
        CGRect frame3 = MoreView.frame;
        frame3.origin.y = frame3.origin.y - 190;
        [UIView animateWithDuration:0.6 animations:^{MoreView.frame = frame3;}];

        CGRect frame = AddDealButton.frame;
        frame.origin.y = frame.origin.y - 200;
        [UIView animateWithDuration:0.6 animations:^{AddDealButton.frame = frame;}];
        CGRect frame2 = SocialView.frame;
        frame2.origin.y = frame2.origin.y - 200;
        [UIView animateWithDuration:0.6 animations:^{SocialView.frame = frame2;}];
        updown_moreoption = true;

    }
}

-(void) EnlargeCameraScroll {
    if (numofpics>=2) {
        [scrollcamera setContentSize:((CGSizeMake(320*numofpics, 155)))];
        [scrollcamera setScrollEnabled:YES];
    } else
    {
        [scrollcamera setScrollEnabled:NO];
        [scrollcamera setContentSize:((CGSizeMake(320, 155)))];
    }

}

-(void) EnlargeScroll {
    [scroll setContentSize:((CGSizeMake(320, 700)))];
}

-(void) ReduceScroll {
    [UIView animateWithDuration:0.6 animations:^{[scroll setContentSize:((CGSizeMake(320, 500)))];}];

     
    //[scroll setContentSize:((CGSizeMake(320, 500)))];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollcamera.frame.size.width;
    currentpage = floor((scrollcamera.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    PageControl.currentPage=currentpage;
    NSLog(@"page=%d",currentpage);

}

-(void) oreder {
    NSLog(@"order and num=%d",numofpics);
    UIImageView *captureImage_temp = [[UIImageView alloc]init];
    captureImage_temp.image=nil;
    if (numofpics==2) {
        captureImage_temp.image=captureImage2.image;
        captureImage2.image=captureImage.image;
        captureImage.image=captureImage_temp.image;
    }
    if (numofpics==3) {
        captureImage_temp.image=captureImage3.image;
        captureImage3.image=captureImage2.image;
        captureImage2.image=captureImage.image;
        captureImage.image=captureImage_temp.image;
    }
    if (numofpics==4) {
        captureImage_temp.image=captureImage4.image;
        captureImage4.image=captureImage3.image;
        captureImage3.image=captureImage2.image;
        captureImage2.image=captureImage.image;
        captureImage.image=captureImage_temp.image;
    }
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    NSLog(@"here/n/n/n");
    if (numofpics==0) {
        captureImage.image=image;
    }
    if (numofpics==1) {
        captureImage2.image=image;
    }
    if (numofpics==2) {
        captureImage3.image=image;
    }
    if (numofpics==3) {
        captureImage4.image=image;
    }
    numofpics++;
    [self oreder];
    NSLog(@"numofpicafterlib %d",numofpics);
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.didaddphoto=@"yes";
    [self ImageslideMode];
}
@end
