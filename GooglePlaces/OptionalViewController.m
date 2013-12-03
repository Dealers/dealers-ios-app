//
//  OptionalViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/25/13.
//
//

#import "OptionalViewController.h"
#import "AppDelegate.h"
#import "ViewalldealsViewController.h"

@interface OptionalViewController ()

@end

@implementation OptionalViewController
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
@synthesize group;
@synthesize scroll;
@synthesize list;
@synthesize CategoryNavBar;
@synthesize CategoryPicker;
@synthesize PriceNavBar,DollarButton,ShekelButton,DatePicker,DateNavBar,ChagrtoDate,ChagrtoTime,ReturnButton,ReturnButtonFull,ShekelButtonFull,DollarButtonFull,PoundButtonFull,PoundButton,PersentButtonFull,PersentButton,ChangetodateFull,ChangetotimeFull,LoadingDeal,Coverblack,LoadingImage,DoneButton;

-(void) BackgroundMethod {
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if (([app.didaddphoto isEqualToString:@"yes"])) {
        
        dealphoto=app.savedphoto;
        
        NSData *imagedata = UIImageJPEGRepresentation(app.savedphoto.image, 10);
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
    if ([pricelabel.text length]>0) {
        price=pricelabel.text;
    }
    NSString *discount=@"0";
    if ([discountlabel.text length]>0) {
        discount=discountlabel.text;
    }

    
    app.AfterAddDeal = @"yes";

    NSString *newString;
    NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/dealphpFile.php?Title="];
    newString = [strURL stringByAppendingString:app.globaltitlelabel.text];
    newString = [newString stringByAppendingString:@"&Description='"];
    newString = [newString stringByAppendingString:descriptionlabel.text];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Store='"];
    newString = [newString stringByAppendingString:app.globalstorelabel.text];
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
    
    //newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    strURL = newString;
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url=%@\n",strURL);
    
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
    LoadingDeal.hidden=YES;
    UIColor *colorOne = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
    self.scroll.backgroundColor=colorOne;
    sign=@"1";

    facebook = @"a";
    group = @"a";
    twitter = @"a";
    groupbefore.alpha=1.0;
    facebookbefore.alpha=1.0;
    twittbefore.alpha=1.0;
    groupafter.alpha=0.0;
    facebookafter.alpha=0.0;
    twittafter.alpha=0.0;
    ReturnButtonFull.alpha=0.0;
    descriptionlabel.tag=1;
    pricelabel.tag=2;
    discountlabel.tag=3;
    DollarButtonFull.alpha=1.0;
    DollarButton.alpha=0.0;
    ChangetotimeFull.alpha=0.0;
    ChangetodateFull.alpha=1.0;
    ChagrtoDate.alpha=0.0;

    ShekelButtonFull.alpha=0.0;
    PoundButtonFull.alpha=0.0;
    PersentButton.alpha=0.0;
    PersentButtonFull.alpha=1.0;
    Coverblack.alpha=0.0;

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
    [discountlabel setReturnKeyType:UIReturnKeyDone];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    dealphoto.image=app.savedphoto.image;
        
    [super viewDidLoad];

    list = [[NSMutableArray alloc] initWithObjects:@"Amusement & Entertainment",@"amusement_park",@"aquarium",@"bowling_alley",@"movie_theater",@"museum",@"casino",@"movie_rental",@"night_club",@"spa",@"zoo",@"Art",@"art_gallery",@"Automotive",@"car_dealer",@"car_rental",@"car_repair",@"car_wash",@"Beauty & Personal Care",@"beauty_salon",@"hair_care",@"health",@"physiotherapist",@"book_store",@"Books & Magazines",@"library",@"Electronics",@"electronics_store",@"clothing_store",@"department_store",@"Fashion",@"shoe_store",@"bakery",@"convenience_shop",@"Food & Groceries",@"food",@"grocery_or_supermarket",@"liquor_store",@"meal_delivery",@"meal_takeaway",@"pharmacy",@"florist",@"furniture_store",@"hardware_store",@"Home & Furniture",@"home_goods_store",@"laundry",@"locksmith",@"painter",@"Jewelry & Watches",@"jewelry_store",@"Pets",@"pets_store",@"veterinary_care",@"general_contractor",@"Real Estate",@"real_estate_agency",@"bars",@"cafÈ",@"restaurant",@"Restaurants & Bars",@"bicycle_store",@"gym",@"Sports & Outdoor",@"airport",@"lodging",@"Travel",@"travel_agency",@"bank",@"finance",@"insurance_agency",@"Other",@"store", nil];
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

- (void)viewDidUnload {
    [self setGroupbefore:nil];
    [self setGroupafter:nil];
    [self setFacebookbefore:nil];
    [self setFacebookafter:nil];
    [self setTwittbefore:nil];
    [self setTwittafter:nil];
    [self setGroupicon:nil];
    [self setFacebookicon:nil];
    [self setTwiiticon:nil];
    [self setTwittbutton:nil];
    [super viewDidUnload];
}
- (IBAction)groupbutton:(id)sender {
    if ([group isEqual:@"a"]){
        [UIView animateWithDuration:0.3 animations:^{groupafter.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{groupbefore.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{groupicon.center = CGPointMake(83, 290);}];
        group=@"b";
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{groupafter.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{groupbefore.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{groupicon.center = CGPointMake(50, 290);}];
        group=@"a";
    }
}

- (IBAction)facebookbutton:(id)sender {
    
    if ([facebook isEqual:@"a"]){
        [UIView animateWithDuration:0.3 animations:^{facebookafter.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{facebookbefore.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{facebookicon.center = CGPointMake(179, 290);}];
        facebook=@"b";
    }
    
    else {
        
        [UIView animateWithDuration:0.3 animations:^{facebookafter.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{facebookbefore.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{facebookicon.center = CGPointMake(146, 290);}];
        facebook=@"a";
    }
}
    
- (IBAction)twittbutton:(id)sender {
    
    if ([twitter isEqual:@"a"]){
        [UIView animateWithDuration:0.3 animations:^{twittafter.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{twittbefore.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{twiiticon.center = CGPointMake(274, 290);}];
        twitter=@"b";
    }
    
    else {
        
        [UIView animateWithDuration:0.3 animations:^{twittafter.alpha=0.0;}];
        [UIView animateWithDuration:0.3 animations:^{twittbefore.alpha=1.0;}];
        [UIView animateWithDuration:0.3 animations:^{twiiticon.center = CGPointMake(241, 290);}];
        twitter=@"a";
    }
}

- (IBAction)whatappButton:(id)sender {

    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    NSString *strURL = [NSString stringWithFormat:@"whatsapp://send?text=Try my new app:"];
    strURL = [strURL stringByAppendingString:@" "];
    strURL = [strURL stringByAppendingString:app.globaltitlelabel.text];
    strURL = [strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSURL *whatappURL = [NSURL URLWithString:strURL];
    if ([[UIApplication sharedApplication] canOpenURL:whatappURL]) {
        [[UIApplication sharedApplication] openURL:whatappURL];
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
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 80);}];
    
    [scroll setContentSize:((CGSizeMake(320, 650)))];
    [scroll setScrollEnabled:YES];
    [UIView animateWithDuration:0.5 animations:^{DatePicker.center = CGPointMake(160, 352);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 222);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 222);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 222);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 222);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 222);}];

    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 590);}];

    
    
}

- (IBAction)DollarButtonAction:(id)sender {
    sign=@"2";

    //pricelabel.text = [pricelabel.text stringByReplacingOccurrencesOfString:@"₪" withString:@""];
    //pricelabel.text = [pricelabel.text stringByAppendingString:@"$"];
    ShekelButtonFull.alpha=0.0;
    ShekelButton.alpha=1.0;
    PoundButtonFull.alpha=0.0;
    PoundButton.alpha=1.0;
    DollarButtonFull.alpha=1.0;
    DollarButton.alpha=0.0;
}

- (IBAction)CateoryButtonAction:(id)sender {
    [scroll setContentSize:((CGSizeMake(320, 650)))];
    
    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 590);}];

    [scroll setScrollEnabled:YES];
    
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 352);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 222);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 590);}];

}

- (IBAction)Cateory_DoneButtonAction:(id)sender {
    [scroll setScrollEnabled:NO];
    
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 590);}];

}

-(void) keyboardWillShow {
}

-(void) keyboardWillHide {
}


-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    
    [scroll setScrollEnabled:YES ];
    if (textField.tag==1) {
        [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 590);}];
        [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 590);}];
        
        [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 590);}];
        [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 590);}];
        [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 590);}];
        [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 590);}];
        [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 590);}];
        [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 590);}];
        [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 590);}];
        [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 590);}];
        [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 590);}];
        [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 590);}];
        [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 590);}];

        
    } else {
        [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 225);}];
        [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 225);}];
        [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 225);}];
        [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 225);}];
        [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 225);}];
        [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 225);}];
        [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 225);}];
        [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 225);}];
        [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 225);}];
        [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 225);}];

        
        [UIView animateWithDuration:0.5 animations:^{CategoryPicker.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.5 animations:^{CategoryNavBar.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 590);}];
        [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 590);}];
        [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 590);}];
        [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 590);}];
        [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 590);}];

    }
    
    //price
    if (textField.tag==2) {
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
    [scroll setScrollEnabled:NO];
    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 590);}];

    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 590);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 590);}];
    
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    
    return YES;
}

- (IBAction)ShekelButtonAction:(id)sender {
    sign=@"1";

    //pricelabel.text = [pricelabel.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    // pricelabel.text = [pricelabel.text stringByAppendingString:@"₪"];
    ShekelButtonFull.alpha=1.0;
    ShekelButton.alpha=0.0;
    PoundButtonFull.alpha=0.0;
    PoundButton.alpha=1.0;
    DollarButtonFull.alpha=0.0;
    DollarButton.alpha=1.0;
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
    [scroll setScrollEnabled:NO];
    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    [UIView animateWithDuration:0.5 animations:^{DatePicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ChagrtoTime.center = CGPointMake(20, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ChangetotimeFull.center = CGPointMake(20, 590);}];
    
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


- (IBAction)ReturnButtonAction:(id)sender {
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)PersentButtonAction:(id)sender {
    PersentButton.alpha=0.0;
    PersentButtonFull.alpha=1.0;
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

-(void) DoneButtonAction:(id)sender {
    [scroll setScrollEnabled:NO];
    [pricelabel resignFirstResponder];
    [discountlabel resignFirstResponder];
    [descriptionlabel resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{PriceNavBar.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButton.center = CGPointMake(53, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButton.center = CGPointMake(90, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DollarButtonFull.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{ShekelButtonFull.center = CGPointMake(53, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PoundButtonFull.center = CGPointMake(90, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButton.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{PersentButtonFull.center = CGPointMake(18, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DatePicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoTime.center = CGPointMake(20, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChagrtoDate.center = CGPointMake(50, 590);}];
    [UIView animateWithDuration:0.5 animations:^{DateNavBar.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetotimeFull.center = CGPointMake(20, 590);}];
    [UIView animateWithDuration:0.5 animations:^{ChangetodateFull.center = CGPointMake(50, 590);}];
    [UIView animateWithDuration:0.2 animations:^{DoneButton.center = CGPointMake(285, 590);}];

    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];

}
@end
