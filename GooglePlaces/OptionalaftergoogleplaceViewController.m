//
//  OptionalViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/25/13.
//
//

#import "OptionalaftergoogleplaceViewController.h"
#import "AppDelegate.h"
#import "ViewalldealsViewController.h"
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
@synthesize facebookafter;
@synthesize facebookbefore;
@synthesize facebookicon;
@synthesize twiiticon;
@synthesize twittafter;
@synthesize twittbefore;
@synthesize groupafter;
@synthesize groupbefore;
@synthesize groupicon;
@synthesize facebook;
@synthesize twitter;
@synthesize whatsapp,whatsappafter,whatsappbefore,whatsappicon;
@synthesize group;
@synthesize list;
@synthesize scroll;
@synthesize CategoryNavBar;
@synthesize CategoryPicker;
@synthesize PriceNavBar,DollarButton,ShekelButton,DatePicker,DateNavBar,ChagrtoDate,ChagrtoTime,ChangetodateFull,ChangetotimeFull,DollarButtonFull,ShekelButtonFull,PoundButtonFull,PoundButton,PersentButton,PersentButtonFull,LoadingDeal,ReturnButtonFull,ReturnButton,Coverblack,LoadingImage,DoneButton,imagePreview,captureImage,stillImageOutput,titlelabel,mapView,TrashButton,AddAnotherPicButton,PicFromLibButton,RotateCamButton,ExitCameraButton,MoreView,AddDealButton,SocialView,scrollcamera,SnapButton, captureImage2,captureImage3,captureImage_temp,BlackCoverImage;


-(void) BackgroundMethod {
        dealphotoid=@"0";
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([app.didaddphoto isEqualToString:@"yes"]) {
        dealphoto=app.savedphoto;
        
        NSData *imagedata = UIImageJPEGRepresentation(captureImage.image, 10);
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
    newString = [newString stringByAppendingString:categorylabel.text];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Sign='"];
    newString = [newString stringByAppendingString:sign];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Clientid='"];
    newString = [newString stringByAppendingString:app.UserID];
    newString = [newString stringByAppendingString:@"'"];
    strURL = newString;
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

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

-(void) DoneFunc {
    ViewalldealsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myfeeds"];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:nil];

    
}


- (void)viewDidLoad
{
    Flag = true;
    updown_moreoption = true;
    MoreView.alpha=0.0;
    currentpage=0;
    BlackCoverImage.hidden=YES;
    //[self initializeCamera];

    [self ReduceScroll];
    [self EnlargeCameraScroll];
    [scroll setScrollEnabled:YES];
    [scrollcamera setScrollEnabled:YES];

    TrashButton.hidden=YES;
    AddAnotherPicButton.hidden=YES;
    FrontCamera = NO;
    captureImage.hidden = YES;
    LoadingDeal.hidden=YES;
    [super viewDidLoad];
    UIColor *colorOne = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
    self.scroll.backgroundColor=colorOne;

    sign=@"1";
    facebook = @"a";
    whatsapp = @"a";
    group = @"a";
    twitter = @"a";
    groupbefore.alpha=1.0;
    facebookbefore.alpha=1.0;
    twittbefore.alpha=1.0;
    groupafter.alpha=0.0;
    facebookafter.alpha=0.0;
    twittafter.alpha=0.0;
    descriptionlabel.tag=1;
    pricelabel.tag=2;
    discountlabel.tag=3;
    titlelabel.tag=4;
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
    
    list = [[NSMutableArray alloc] initWithObjects:@"Amusement & Entertainment",@"amusement_park",@"aquarium",@"bowling_alley",@"movie_theater",@"museum",@"casino",@"movie_rental",@"night_club",@"spa",@"zoo",@"Art",@"art_gallery",@"Automotive",@"car_dealer",@"car_rental",@"car_repair",@"car_wash",@"Beauty & Personal Care",@"beauty_salon",@"hair_care",@"health",@"physiotherapist",@"book_store",@"Books & Magazines",@"library",@"Electronics",@"electronics_store",@"clothing_store",@"department_store",@"Fashion",@"shoe_store",@"bakery",@"convenience_shop",@"Food & Groceries",@"food",@"grocery_or_supermarket",@"liquor_store",@"meal_delivery",@"meal_takeaway",@"pharmacy",@"florist",@"furniture_store",@"hardware_store",@"Home & Furniture",@"home_goods_store",@"laundry",@"locksmith",@"painter",@"Jewelry & Watches",@"jewelry_store",@"Pets",@"pets_store",@"veterinary_care",@"general_contractor",@"Real Estate",@"real_estate_agency",@"bars",@"cafÈ",@"restaurant",@"Restaurants & Bars",@"bicycle_store",@"gym",@"Sports & Outdoor",@"airport",@"lodging",@"Travel",@"travel_agency",@"bank",@"finance",@"insurance_agency",@"Other",@"store", nil];
    
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
        [UIView animateWithDuration:0.3 animations:^{groupafter.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{groupbefore.alpha=0.0;}];
        group=@"b";
        
        CGRect frame = groupicon.frame;
        frame.origin.x = frame.origin.x + 19;
        [UIView animateWithDuration:0.3 animations:^{groupicon.frame = frame;}];

    }
    else {
        [UIView animateWithDuration:0.3 animations:^{groupafter.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{groupbefore.alpha=1.0;}];
        CGRect frame = groupicon.frame;
        frame.origin.x = frame.origin.x - 19;
        [UIView animateWithDuration:0.3 animations:^{groupicon.frame = frame;}];
        group=@"a";
    }
}

- (IBAction)whatsappbutton:(id)sender {
    if ([whatsapp isEqual:@"a"]){
        [UIView animateWithDuration:0.3 animations:^{whatsappafter.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{whatsappbefore.alpha=0.0;}];
        whatsapp=@"b";
        
        CGRect frame = whatsappicon.frame;
        frame.origin.x = frame.origin.x + 19;
        [UIView animateWithDuration:0.3 animations:^{whatsappicon.frame = frame;}];
        
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{whatsappafter.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{whatsappbefore.alpha=1.0;}];
        CGRect frame = whatsappicon.frame;
        frame.origin.x = frame.origin.x - 19;
        [UIView animateWithDuration:0.3 animations:^{whatsappicon.frame = frame;}];
        whatsapp=@"a";
    }
}
- (IBAction)facebookbutton:(id)sender {
    
    if ([facebook isEqual:@"a"]){
        [UIView animateWithDuration:0.3 animations:^{facebookafter.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{facebookbefore.alpha=0.0;}];
        CGRect frame = facebookicon.frame;
        frame.origin.x = frame.origin.x + 19;
        [UIView animateWithDuration:0.3 animations:^{facebookicon.frame = frame;}];
        facebook=@"b";
    }
    
    else {
        
        [UIView animateWithDuration:0.3 animations:^{facebookafter.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{facebookbefore.alpha=1.0;}];
        CGRect frame = facebookicon.frame;
        frame.origin.x = frame.origin.x - 19;
        [UIView animateWithDuration:0.3 animations:^{facebookicon.frame = frame;}];
        facebook=@"a";
    }
}

- (IBAction)twittbutton:(id)sender {
    
    if ([twitter isEqual:@"a"]){
        [UIView animateWithDuration:0.3 animations:^{twittafter.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{twittbefore.alpha=0.0;}];
        CGRect frame = twiiticon.frame;
        frame.origin.x = frame.origin.x + 19;
        [UIView animateWithDuration:0.3 animations:^{twiiticon.frame = frame;}];
        twitter=@"b";
    }
    
    else {
        
        [UIView animateWithDuration:0.3 animations:^{twittafter.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{twittbefore.alpha=1.0;}];
        CGRect frame = twiiticon.frame;
        frame.origin.x = frame.origin.x - 19;
        [UIView animateWithDuration:0.3 animations:^{twiiticon.frame = frame;}];
        twitter=@"a";
    }
}

/*- (IBAction)whatappButton:(id)sender {
    NSString *strURL = [NSString stringWithFormat:@"whatapp://send?text=dealers"];
    NSURL *whatappURL = [NSURL URLWithString:strURL];
    if ([[UIApplication sharedApplication] canOpenURL:whatappURL]) {
        [[UIApplication sharedApplication] openURL:whatappURL];
    }
}*/


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

        
    } else {
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
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
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
    [self capImage];
    [self ImageslideMode];
}

-(void) CameraMode {
    //[self initializeCamera];
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
    [scrollcamera setContentSize:((CGSizeMake(320, 155)))];
}

-(void) ImageslideMode {
    BlackCoverImage.hidden=NO;
    currentpage=0;
    ExitCameraButton.hidden=YES;
    captureImage.hidden = NO; //show the captured image view
    imagePreview.hidden = YES; //hide the live video feed
    RotateCamButton.hidden=YES;
    SnapButton.hidden=YES;
    TrashButton.hidden=NO;
    AddAnotherPicButton.hidden=NO;
    PicFromLibButton.hidden=YES;
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
    
        UIGraphicsBeginImageContext(CGSizeMake(320, 155));
        [image drawInRect: CGRectMake(0, 0, 320, 155)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGRect cropRect = CGRectMake(0, 0, 300, 155);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    if (numofpics==0) {
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
    }
    if (numofpics==1) {
        [captureImage2 setImage:[UIImage imageWithCGImage:imageRef]];
    }
    if (numofpics==2) {
        [captureImage3 setImage:[UIImage imageWithCGImage:imageRef]];
    }
    numofpics++;
    [self EnlargeCameraScroll];
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.didaddphoto=@"yes";
        CGImageRelease(imageRef);
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
    }
    if (currentpage==1) {
        if (numofpics==2) {
            captureImage2.image=nil;
        }
        if (numofpics==3) {
            captureImage2.image=captureImage3.image;
            captureImage3.image=nil;
        }
    }
    if (currentpage==3) {
        if (numofpics==3) {
            captureImage3.image=nil;
        }
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
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (numofpics==0) {
        captureImage.image=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    if (numofpics==1) {
        captureImage2.image=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    if (numofpics==2) {
        captureImage3.image=[info objectForKey:UIImagePickerControllerEditedImage];
    }
    numofpics++;
    NSLog(@"numofpicafterlib %d",numofpics);
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.didaddphoto=@"yes";
    [self ImageslideMode];
}


-(void) MoreButtonAction:(id)sender {
    
    if (updown_moreoption) {
        [self EnlargeScroll];
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 220);}];
        [UIView animateWithDuration:0.1 animations:^{self.MoreView.alpha=1.0;}];
        CGRect frame = AddDealButton.frame;
        frame.origin.y = frame.origin.y + 245;
        [UIView animateWithDuration:0.1 animations:^{AddDealButton.frame = frame;}];
        updown_moreoption = false;
    } else {
        [self ReduceScroll];
        [UIView animateWithDuration:0.1 animations:^{self.MoreView.alpha=0.0;}];
        CGRect frame = AddDealButton.frame;
        frame.origin.y = frame.origin.y - 245;
        [UIView animateWithDuration:0.1 animations:^{AddDealButton.frame = frame;}];
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
    [scroll setContentSize:((CGSizeMake(320, 460)))];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollcamera.frame.size.width;
    currentpage = floor((scrollcamera.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

@end
