//
//  OptionalViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 20/3/2014
//
//
#import <Social/Social.h>
#import "OptionalaftergoogleplaceViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"
#import "OnlineViewController.h"
#import <mach/mach.h>
#import "CheckConnection.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface OptionalaftergoogleplaceViewController ()

@end

@implementation OptionalaftergoogleplaceViewController

-(void) uploadImageToAmazon {
    
    
}

-(void) removeUniqueSigns {
    
    _priceText=@"0";
    if ([_pricelabel.text length]>0) {
        _priceText=_pricelabel.text;
    }
    _discountText=@"0";
    if ([_discountlabel.text length]>0) {
        _discountText=_discountlabel.text;
    }
    _categorylabel.text = [_categorylabel.text stringByReplacingOccurrencesOfString:@" & " withString:@"q9j"];
    _storeName= [_storeName stringByReplacingOccurrencesOfString:@"&" withString:@"q9j"];
    _storeName= [_storeName stringByReplacingOccurrencesOfString:@"'" withString:@"q8j"];
    _titleText = _titlelabel.text;
    _titleText = [_titleText stringByReplacingOccurrencesOfString:@"&" withString:@"q9j"];
    _titleText = [_titleText stringByReplacingOccurrencesOfString:@"'" withString:@"q8j"];
    _descriptionText = _DescriptionTextView.text;
    _descriptionText = [_descriptionText stringByReplacingOccurrencesOfString:@"&" withString:@"q9j"];
    _descriptionText = [_descriptionText stringByReplacingOccurrencesOfString:@"'" withString:@"q8j"];
    
}
-(void) BackgroundMethod {
    
    NSMutableArray *photosArray=[[NSMutableArray alloc]init];
    NSMutableArray *photosidArray=[[NSMutableArray alloc]init];
    
    if (numofpics==1) {
        [photosArray addObject:_captureImage.image];
    }
    if (numofpics==2) {
        [photosArray addObject:_captureImage.image];
        [photosArray addObject:_captureImage2.image];
    }
    if (numofpics==3) {
        [photosArray addObject:_captureImage.image];
        [photosArray addObject:_captureImage2.image];
        [photosArray addObject:_captureImage3.image];
    }
    if (numofpics==4) {
        [photosArray addObject:_captureImage.image];
        [photosArray addObject:_captureImage2.image];
        [photosArray addObject:_captureImage3.image];
        [photosArray addObject:_captureImage4.image];
    }
    
    if (numofpics>0) {
        for (int i=0; i<[photosArray count]; i++) {
            NSData *imagedata = UIImageJPEGRepresentation([photosArray objectAtIndex:i], 1);
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
            //dealphotoid = returnString;
            NSString *photoidFormUpload = returnString;
            [photosidArray addObject:photoidFormUpload];
        }
    }
    
    for (int i=0; i<4; i++) {
        [photosidArray addObject:@"0"];
    }
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal = @"yes";
    
    NSString *numofPhotos = [NSString stringWithFormat:@"%d",numofpics];
    
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat =@"yyyy-MM-dd 'at' HH:mm";
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    
    if ([_categorylabel.text length]==0) {
        _categorylabel.text=@"No Category";
    }
    
    if ([app.onlineOrLocal isEqualToString:@"local"]) {
        _urlSite=@"0";
    }
    
    NSString *newString;
    NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/dealphpFile.php?Title='"];
    newString = [strURL stringByAppendingString:_titleText];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Description='"];
    newString = [newString stringByAppendingString:_descriptionText];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Store='"];
    newString = [newString stringByAppendingString:_storeName];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Price='"];
    newString = [newString stringByAppendingString:_priceText];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Discount='"];
    newString = [newString stringByAppendingString:_discountText];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Expire='"];
    newString = [newString stringByAppendingString:_expirationlabel.text];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Photoid='"];
    newString = [newString stringByAppendingString:[photosidArray objectAtIndex:0]];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Photoid2='"];
    newString = [newString stringByAppendingString:[photosidArray objectAtIndex:1]];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Photoid3='"];
    newString = [newString stringByAppendingString:[photosidArray objectAtIndex:2]];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Photoid4='"];
    newString = [newString stringByAppendingString:[photosidArray objectAtIndex:3]];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Photosnum='"];
    newString = [newString stringByAppendingString:numofPhotos];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Category='"];
    newString = [newString stringByAppendingString:_categorylabel.text];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Sign='"];
    newString = [newString stringByAppendingString:sign];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&Clientid='"];
    newString = [newString stringByAppendingString:app.UserID];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&uploaddate='"];
    newString = [newString stringByAppendingString:dateString];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&onlineorlocal='"];
    newString = [newString stringByAppendingString:app.onlineOrLocal];
    newString = [newString stringByAppendingString:@"'"];
    newString = [newString stringByAppendingString:@"&urlSite='"];
    newString = [newString stringByAppendingString:_urlSite];
    newString = [newString stringByAppendingString:@"'"];
    
    strURL = newString;
    NSLog(@"url=%@",strURL);
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    resultFromDb = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"result=%@\n",resultFromDb);
}

//Points nil all strong vars//
-(void) DeallocMemory {
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    static NSCache *_cache = nil;
    [_cache removeAllObjects];
    [self.captureSession startRunning];
    [_imagePreview.layer removeFromSuperlayer];
    self.stillImageOutput=nil;
    self.captureSession=nil;
    _storeName=Nil;
    _categoryListArray=Nil;
    _StoreSearchArray=Nil;
    _imagePicker.delegate=nil;
    _imagePicker=Nil;
    _stillImageOutput=Nil;
    _captureSession=nil;
    _titlelabel.delegate=nil;
    _categorylabel.delegate=nil;
    _pricelabel.delegate=nil;
    _discountlabel.delegate=nil;
    _expirationlabel.delegate=nil;
    _DatePicker=Nil;
    _CategoryPicker.dataSource=Nil;
    _CategoryPicker.delegate=Nil;
    _CategoryPicker=Nil;
}

-(void) waitOneSecond {
    [self performSelector:@selector(reloadMyFeeds) withObject:nil afterDelay:1];
}

//Loads MYFEED vc //
-(void) reloadMyFeeds {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([app.previousViewControllerAddDeal isEqualToString:@"foursquare"]){
        NSArray *viewControllers = self.navigationController.viewControllers;
        int count = [viewControllers count];
        NSLog(@"%@,%d",viewControllers,count);
        id previousController = [viewControllers objectAtIndex:3];
        if ([previousController respondsToSelector:@selector(deallocMemory)])
            [previousController deallocMemory];
        [self DeallocMemory];
        UINavigationController * navigationController = self.navigationController;
        [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    }
    else {
        NSArray *viewControllers = self.navigationController.viewControllers;
        id previousController = [viewControllers objectAtIndex:3];
        if ([previousController respondsToSelector:@selector(deallocOnlineView)]){
            [previousController deallocOnlineView];
        }
        UINavigationController * navigationController = self.navigationController;
        [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    }
}

-(void) initialize {
    _expirationlabel.text=@"";
    _categorylabel.text=_segcategory;
    timeOrDate=@"date";
}

- (void)viewDidLoad
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSLog(@"%@",app.previousViewControllerAddDeal);
    [self initialize];
    _PageControl.hidden=YES;
    Flag = true;
    isMoreOptionViewHidden = true;
    currentpage=0;
    _BlackCoverImage.hidden=YES;
    [self ReduceScroll];
    [self EnlargeCameraScroll];
    [_scroll setScrollEnabled:YES];
    [_scrollcamera setScrollEnabled:YES];
    [_scrollcamera setBackgroundColor:[UIColor blackColor]];
    _TrashButton.hidden=YES;
    _AddAnotherPicButton.hidden=YES;
    FrontCamera = NO;
    _captureImage.hidden = YES;
    _LoadingDeal.hidden=YES;
    sign=@"1";
    _facebook = @"a";
    _whatsapp = @"a";
    _group = @"a";
    _twitter = @"a";
    _morebutton = @"a";
    _ChangetotimeFull.alpha=0.0;
    _ChangetodateFull.alpha=1.0;
    _ChagrtoDate.alpha=0.0;
    _DollarButtonFull.alpha=1.0;
    _DollarButton.alpha=0.0;
    
    _ShekelButtonFull.alpha=0.0;
    _PoundButtonFull.alpha=0.0;
    _PersentButton.alpha=0.0;
    _PersentButtonFull.alpha=1.0;
    _Coverblack.alpha=0.0;
    _FlashView.alpha=0.0;
    _SnapButton2.alpha=0.0;
    
    _titlelabel.delegate=self;
    [_categorylabel setDelegate:self];
    [_categorylabel setReturnKeyType:UIReturnKeyDone];
    [_categorylabel addTarget:self action:@selector(categorylabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pricelabel setDelegate:self];
    [_pricelabel setReturnKeyType:UIReturnKeyDone];
    [_pricelabel addTarget:self action:@selector(pricelabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_discountlabel setDelegate:self];
    [_discountlabel setReturnKeyType:UIReturnKeyDone];
    [_discountlabel addTarget:self action:@selector(discountlabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_expirationlabel setDelegate:self];
    [_expirationlabel setReturnKeyType:UIReturnKeyDone];
    [_expirationlabel addTarget:self action:@selector(expirationlabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _categoryListArray = [[NSMutableArray alloc] initWithObjects:@"No Category",@"Automotive",@"Art",@"Beauty & Personal Care"@"Book & Magazines",@"Electronics",@"Entertainment & Events",@"Fashion",@"Food & Groceries",@"Home & Furniture",@"Kids & Babies",@"Music",@"Pets",@"Restaurants & Bars",@"Sports & Outdoor",@"Travel",@"Other",nil];
    [_scrollcamera setScrollEnabled:NO];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    allocDatePicker=NO;
    allocCategoryPicker=NO;
    [self initializeCamera];
}

- (void)didReceiveMemoryWarning
{
    static NSCache *_cache = nil;
    [_cache removeAllObjects];
    [self.captureSession startRunning];
    [_imagePreview.layer removeFromSuperlayer];
    self.stillImageOutput=nil;
    self.captureSession=nil;
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=crash&crashtext='camera'"];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    _SnapButton.enabled=NO;
    _SnapButton2.enabled=NO;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dismissKeyBoard {
    [_pricelabel resignFirstResponder];
    [_discountlabel resignFirstResponder];
    [_DescriptionTextView resignFirstResponder];
    [_titlelabel resignFirstResponder];
}

//Showing the Loading Icon //
-(void) startLoadingIcon {
    _LoadingImage.animationImages = [NSArray arrayWithObjects:
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
    _LoadingImage.animationDuration = 0.3;
    [_LoadingImage startAnimating];
    [UIView animateWithDuration:0.2 animations:^{_LoadingImage.alpha=1.0; _LoadingImage.transform =CGAffineTransformMakeScale(0,0);
        _LoadingImage.transform =CGAffineTransformMakeScale(1,1);}];
}

- (IBAction)adddealbutton:(id)sender {
    NSLog(@"in add deal function");
    NSString *everyThingsOK = @"no";
    [self dismissKeyBoard];
    
    if ((_titlelabel.text.length == 0)){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter an Title" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else if ((_discountlabel.text.length > 0)){
        int price = [_discountlabel.text intValue];
        if (price>100) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Check your discount" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        } else everyThingsOK=@"yes";
    } else everyThingsOK=@"yes";
    
    if ([everyThingsOK isEqualToString:@"yes"]) {
        [UIView animateWithDuration:0.3 animations:^{_Coverblack.alpha=1.0;}];
        _LoadingDeal.hidden=NO;
        [UIView animateWithDuration:0.3 animations:^{_LoadingDeal.alpha=1.0; _LoadingDeal.transform =CGAffineTransformMakeScale(0.8,0.8);
            _LoadingDeal.transform =CGAffineTransformMakeScale(1,1);}];
        [self startLoadingIcon];
        [self removeUniqueSigns];
        
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            CheckConnection *checkconnection = [[CheckConnection alloc]init];
            if ([checkconnection connected])
            [self BackgroundMethod];
            else resultFromDb=@"";
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI on the main thread.
                NSLog(@"res=%@",resultFromDb);
                if (([resultFromDb length]==0)) {
                    [UIView animateWithDuration:0.3 animations:^{_Coverblack.alpha=0.0;}];
                    _LoadingDeal.hidden=YES;
                    [UIView animateWithDuration:0.3 animations:^{_LoadingDeal.alpha=0.0; _LoadingDeal.transform =CGAffineTransformMakeScale(1.0,1.0);
                        _LoadingDeal.transform =CGAffineTransformMakeScale(0,0);}];
                    [_LoadingImage stopAnimating];
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Could not Upload Your Deal, Please Try Again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    [alert show];
                }
                else if ([resultFromDb rangeOfString:@"fail"].location == NSNotFound) {
                    [self waitOneSecond];
                } else {
                    [UIView animateWithDuration:0.3 animations:^{_Coverblack.alpha=0.0;}];
                    _LoadingDeal.hidden=YES;
                    [UIView animateWithDuration:0.3 animations:^{_LoadingDeal.alpha=0.0; _LoadingDeal.transform =CGAffineTransformMakeScale(1.0,1.0);
                        _LoadingDeal.transform =CGAffineTransformMakeScale(0,0);}];
                    [_LoadingImage stopAnimating];
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Could not Upload Your Deal, Please Try Again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    [alert show];
                    
                }
            });
        });
    }
}

- (IBAction)groupbutton:(id)sender {
    if ([_group isEqual:@"a"]){
        [_groupicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Groups button (selected).png"] forState:UIControlStateNormal];
        _group=@"b";
    }
    else {
        [_groupicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Groups button.png"] forState:UIControlStateNormal];
        _group=@"a";
    }
}

- (IBAction)whatsappbutton:(id)sender {
    if ([_whatsapp isEqual:@"a"]){
        [_whatsappicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via WhatsApp button (selected).png"] forState:UIControlStateNormal];
        _whatsapp=@"b";
        
        NSString *strURL = [NSString stringWithFormat:@"whatsapp://send?text=Check this great deal:"];
        strURL = [strURL stringByAppendingString:@" "];
        strURL = [strURL stringByAppendingString:_titlelabel.text];
        strURL = [strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL *whatappURL = [NSURL URLWithString:strURL];
        if ([[UIApplication sharedApplication] canOpenURL:whatappURL]) {
            [[UIApplication sharedApplication] openURL:whatappURL];
        }
        
    }
    else {
        [_whatsappicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via WhatsApp button.png"] forState:UIControlStateNormal];
        _whatsapp=@"a";
    }
}

- (IBAction)facebookbutton:(id)sender {
    if ([_facebook isEqual:@"a"]){
        [_facebookicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Facebook button (selected).png"] forState:UIControlStateNormal];
        _facebook=@"b";
        
        SLComposeViewController *facebookview = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *post = @"try my new app";
        [facebookview setInitialText:post];
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
    }
    else {
        [_facebookicon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Facebook button.png"] forState:UIControlStateNormal];
        _facebook=@"a";
    }
}

- (IBAction)twittbutton:(id)sender {
    
    if ([_twitter isEqual:@"a"]){
        [_twiiticon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Twitter button (selected).png"] forState:UIControlStateNormal];
        _twitter=@"b";
    }
    
    else {
        [_twiiticon setImage:[UIImage imageNamed:@"Add Deal (Final)_Share via Twitter button.png"] forState:UIControlStateNormal];
        _twitter=@"a";
    }
}


- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _categorylabel.text = [_categoryListArray objectAtIndex:row];
    if ([_categorylabel.text isEqualToString:@"No Category"]) {
        _categorylabel.text=nil;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_categoryListArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_categoryListArray objectAtIndex:row];
}


- (IBAction)ExpireButtonAction:(id)sender {
    [self dismissKeyBoard];
    [self EnlargeScroll:@"expire"];
    
    if (!allocDatePicker) {
        _DatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height), 0, 0)];
        _DatePicker.datePickerMode=UIDatePickerModeDate;
        [self.view addSubview:_DatePicker];
    } allocDatePicker=YES;
    
    int datepickerheight=self.view.frame.size.height - _DatePicker.bounds.size.height/2;
    int datepickerNavigationBarHeight=self.view.frame.size.height - _DatePicker.bounds.size.height-22;
    
    [UIView animateWithDuration:0.5 animations:^{_DatePicker.center = CGPointMake(160, datepickerheight);}];
    [UIView animateWithDuration:0.5 animations:^{_DateNavBar.center = CGPointMake(160, datepickerNavigationBarHeight);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoTime.center = CGPointMake(80, datepickerNavigationBarHeight);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoDate.center = CGPointMake(110, datepickerNavigationBarHeight);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetodateFull.center = CGPointMake(110, datepickerNavigationBarHeight);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetotimeFull.center = CGPointMake(80, datepickerNavigationBarHeight);}];
    [UIView animateWithDuration:0.2 animations:^{_PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButtonFull.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
    [UIView animateWithDuration:0.4 animations:^{_scroll.contentOffset = CGPointMake(0, 340);}];
    [UIView animateWithDuration:0.5 animations:^{_CategoryNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_CategoryPicker.center = CGPointMake(160, 700);}];
}

- (IBAction)CateoryButtonAction:(id)sender {
    [self dismissKeyBoard];
    [self EnlargeScroll:@"category"];
    
    if (!allocCategoryPicker) {
        _CategoryPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height), 0, 0)];
        _CategoryPicker.delegate=self;
        _CategoryPicker.dataSource=self;
        _CategoryPicker.showsSelectionIndicator = YES;
        [self.view addSubview:_CategoryPicker];
    } allocCategoryPicker=YES;

    float height = self.view.frame.size.height - _CategoryNavBar.bounds.size.height/2-216;
    float pickerHeight = self.view.frame.size.height - _CategoryPicker.bounds.size.height/2;
    [UIView animateWithDuration:0.4 animations:^{_scroll.contentOffset = CGPointMake(0, 290);}];
    
    [UIView animateWithDuration:0.2 animations:^{_PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButtonFull.center = CGPointMake(90, 700);}];
    
    [UIView animateWithDuration:0.2 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoTime.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoDate.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetotimeFull.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetodateFull.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_CategoryPicker.center = CGPointMake(160, pickerHeight);}];
    [UIView animateWithDuration:0.5 animations:^{_CategoryNavBar.center = CGPointMake(160, height);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_DateNavBar.center = CGPointMake(160, 700);}];
    
}

- (IBAction)Cateory_DoneButtonAction:(id)sender {
    [self dismissKeyBoard];
    [self ReduceScroll];
    [UIView animateWithDuration:0.5 animations:^{_CategoryPicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_CategoryNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
}

//If the length is 0 then the PALCEHOLDER is shown//
-(void)textViewDidEndEditing:(UITextView *)textView {
    [self dismissKeyBoard];
    [self ReduceScroll];
    NSLog(@"endtext");
    
    if (textView == _titlelabel) {
        if ([textView.text length]==0) {
            _whatIsTheDealLabel.hidden=NO;
            _countlabel.hidden=YES;
        } else _countlabel.hidden=NO;
    }
    if (textView == _DescriptionTextView) {
        if ([textView.text length]==0) {
            _descriptionlabel.hidden=NO;
        }
    }
    //[UIView animateWithDuration:0.4 animations:^{_scroll.contentOffset = CGPointMake(0, 0);}];
    [UIView animateWithDuration:0.2 animations:^{_PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButtonFull.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoTime.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoDate.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetotimeFull.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetodateFull.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
    
    
}
//If the length is 0 then the PALCEHOLDER is hidden//
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"in the func text should begin");
    if (textView == _titlelabel) {
        [self EnlargeScroll:@"title"];
        if ([textView.text length]==0) {
            _whatIsTheDealLabel.hidden=YES;
        }
        [UIView animateWithDuration:0.4 animations:^{_scroll.contentOffset = CGPointMake(0, 150);}];
    }
    
    if (textView == _DescriptionTextView) {
        [self EnlargeScroll:@"description"];
        if ([textView.text length]==0) {
            _descriptionlabel.hidden=YES;
        }
        float height = self.view.frame.size.height - _CategoryNavBar.bounds.size.height/2-216+2;
        [UIView animateWithDuration:0.5 animations:^{_CategoryNavBar.center = CGPointMake(160, height);}];
        [UIView animateWithDuration:0.4 animations:^{_scroll.contentOffset = CGPointMake(0, 350);}];
    }
    
    [UIView animateWithDuration:0.2 animations:^{_PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButtonFull.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_CategoryPicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoTime.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoDate.center = CGPointMake(119, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetotimeFull.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetodateFull.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
    
    return true;
}

// CHANGE THE COUNTLABEL ACCORDING TO THE TITLABEL LENGTH//
- (void)textViewDidChange:(UITextView *)textView {
    if (textView==_titlelabel) {
        NSString *stringlength=[NSString stringWithString:_titlelabel.text];
        _countlabel.text = [NSString stringWithFormat:@"%d/60",stringlength.length];
    }
}

// FORCE THE TITLELABEL LENGHT TO BE UNDER 41 AND DEFINES ENTERKEY FOR DISMISS KEYBOARD //
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _titlelabel) {
        NSUInteger newLength = [textView.text length] + [text length] - range.length;
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            [self Cateory_DoneButtonAction:nil];
            return NO;
        }
        return (newLength > 60) ? NO : YES;
    } else return YES;
}

//If pressed Price or Discount //
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    [self EnlargeScroll:@"price"];
    float height = self.view.frame.size.height - _CategoryNavBar.bounds.size.height/2-216+2;
    
    if ((textField == _pricelabel)||(textField == _discountlabel)) {
        [UIView animateWithDuration:0.3 animations:^{_PriceNavBar.center = CGPointMake(160, height);}];
        [UIView animateWithDuration:0.3 animations:^{_DollarButton.center = CGPointMake(18, height);}];
        [UIView animateWithDuration:0.3 animations:^{_ShekelButton.center = CGPointMake(53, height);}];
        [UIView animateWithDuration:0.3 animations:^{_PoundButton.center = CGPointMake(90, height);}];
        [UIView animateWithDuration:0.3 animations:^{_DollarButtonFull.center = CGPointMake(18, height);}];
        [UIView animateWithDuration:0.3 animations:^{_ShekelButtonFull.center = CGPointMake(53, height);}];
        [UIView animateWithDuration:0.3 animations:^{_PoundButtonFull.center = CGPointMake(90, height);}];
        [UIView animateWithDuration:0.3 animations:^{_CategoryPicker.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.3 animations:^{_CategoryNavBar.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.3 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.3 animations:^{_ChagrtoTime.center = CGPointMake(80, 700);}];
        [UIView animateWithDuration:0.3 animations:^{_ChagrtoDate.center = CGPointMake(110, 700);}];
        [UIView animateWithDuration:0.3 animations:^{_DateNavBar.center = CGPointMake(160, 700);}];
        [UIView animateWithDuration:0.3 animations:^{_ChangetotimeFull.center = CGPointMake(80, 700);}];
        [UIView animateWithDuration:0.3 animations:^{_ChangetodateFull.center = CGPointMake(110, 700);}];
        [UIView animateWithDuration:0.3 animations:^{_PersentButton.center = CGPointMake(18, height);}];
        [UIView animateWithDuration:0.3 animations:^{_PersentButtonFull.center = CGPointMake(18, height);}];
        [UIView animateWithDuration:0.3 animations:^{_DoneButton.center = CGPointMake(285, height);}];
    }
    
    if (textField == _pricelabel) {
        [UIView animateWithDuration:0.4 animations:^{_scroll.contentOffset = CGPointMake(0, 310);}];
        _DollarButtonFull.hidden=NO;
        _DollarButton.hidden=NO;
        _PoundButton.hidden=NO;
        _PoundButtonFull.hidden=NO;
        _ShekelButtonFull.hidden=NO;
        _ShekelButton.hidden=NO;
        _PersentButtonFull.hidden=YES;
        _PersentButton.hidden=YES;
    }
    
    if (textField == _discountlabel) {
        [UIView animateWithDuration:0.4 animations:^{_scroll.contentOffset = CGPointMake(0, 310);}];
        _DollarButtonFull.hidden=YES;
        _DollarButton.hidden=YES;
        _PoundButton.hidden=YES;
        _PoundButtonFull.hidden=YES;
        _ShekelButtonFull.hidden=YES;
        _ShekelButton.hidden=YES;
        _PersentButtonFull.hidden=NO;
        _PersentButton.hidden=NO;
    }
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"textFieldShouldReturn");
    
    [self dismissKeyBoard];
    [self ReduceScroll];
    
    [UIView animateWithDuration:0.2 animations:^{_PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButtonFull.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoTime.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoDate.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetotimeFull.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetodateFull.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
    
    return YES;
}

-(IBAction)ShekelButtonAction:(id)sender {
    sign=@"1";
    _ShekelButtonFull.alpha=1.0;
    _ShekelButton.alpha=0.0;
    _PoundButtonFull.alpha=0.0;
    _PoundButton.alpha=1.0;
    _DollarButtonFull.alpha=0.0;
    _DollarButton.alpha=1.0;
}

-(IBAction)DollarButtonAction:(id)sender {
    sign=@"2";
    _ShekelButtonFull.alpha=0.0;
    _ShekelButton.alpha=1.0;
    _PoundButtonFull.alpha=0.0;
    _PoundButton.alpha=1.0;
    _DollarButtonFull.alpha=1.0;
    _DollarButton.alpha=0.0;
}

-(IBAction)PoundButtonAction:(id)sender{
    sign=@"3";
    _ShekelButtonFull.alpha=0.0;
    _ShekelButton.alpha=1.0;
    _PoundButtonFull.alpha=1.0;
    _PoundButton.alpha=0.0;
    _DollarButtonFull.alpha=0.0;
    _DollarButton.alpha=1.0;
}

-(NSString *)modifyDateString:(NSDate *)dateFromPicker{
    
    NSString *date;
    
    NSString *newDate=[dateFromPicker descriptionWithLocale:[NSLocale systemLocale]];
    NSArray *datearray = [newDate componentsSeparatedByString:@" "];
    //1=year 2=mounth 3=day 4=hour
    NSString *time = [datearray objectAtIndex:4];
    NSString *day = [datearray objectAtIndex:3];
    NSString *mounth = [datearray objectAtIndex:2];
    NSString *year = [datearray objectAtIndex:1];
    NSString *space = @"-";
    NSString *space2 = @"   ";
    
    
    if ([timeOrDate isEqualToString:@"time"]) {
        date = [[NSString alloc] initWithString:day];
        date = [date stringByAppendingString:space];
        date = [date stringByAppendingString:mounth];
        date = [date stringByAppendingString:space];
        date = [date stringByAppendingString:year];
        date = [date stringByAppendingString:space2];
        date = [date stringByAppendingString:time];
    } else {
        date = [[NSString alloc] initWithString:day];
        date = [date stringByAppendingString:space];
        date = [date stringByAppendingString:mounth];
        date = [date stringByAppendingString:space];
        date = [date stringByAppendingString:year];
        date = [date stringByAppendingString:space2];
    }
    return date;
}

-(IBAction)Date_DoneButtonAction:(id)sender {
    
    [self dismissKeyBoard];
    [self ReduceScroll];
    
    [UIView animateWithDuration:0.5 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoDate.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ChagrtoTime.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetodateFull.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ChangetotimeFull.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
    
    NSDate *select = [_DatePicker date];
    NSString *date = [self modifyDateString:select];
    _expirationlabel.text=date;
}

- (IBAction)ChagrtoDateAction:(id)sender {
    NSLog(@"date");
    timeOrDate=@"date";
    _DatePicker.datePickerMode=UIDatePickerModeDate;
    _ChangetotimeFull.alpha=0.0;
    _ChangetodateFull.alpha=1.0;
    _ChagrtoDate.alpha=0.0;
    _ChagrtoTime.alpha=1.0;
}

- (IBAction)ChagrtoTimeAction:(id)sender {
    timeOrDate=@"time";
    _DatePicker.datePickerMode=UIDatePickerModeDateAndTime;
    _ChangetotimeFull.alpha=1.0;
    _ChangetodateFull.alpha=0.0;
    _ChagrtoTime.alpha=0.0;
    _ChagrtoDate.alpha=1.0;
}

- (IBAction)ChangetotimeFullAction:(id)sender {
    _DatePicker.datePickerMode=UIDatePickerModeDateAndTime;
    _ChangetotimeFull.alpha=1.0;
    _ChangetodateFull.alpha=0.0;
    _ChagrtoTime.alpha=0.0;
    _ChagrtoDate.alpha=1.0;
    
}

- (IBAction)ChangetodateFullAction:(id)sender {
    _DatePicker.datePickerMode=UIDatePickerModeDate;
    _ChangetotimeFull.alpha=0.0;
    _ChangetodateFull.alpha=1.0;
    _ChagrtoDate.alpha=0.0;
    _ChagrtoTime.alpha=1.0;
}

-(IBAction)PersentButtonAction:(id)sender {
    _PersentButton.alpha=0.0;
    _PersentButtonFull.alpha=1.0;
}

- (IBAction)ReturnButtonAction:(id)sender {
    _ReturnButtonFull.alpha=1.0;
    _ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{_ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{_ReturnButton.alpha=1.0;}];
    [self DeallocMemory];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) DoneButtonAction:(id)sender {
    [self ReduceScroll];
    [self dismissKeyBoard];
    
    [UIView animateWithDuration:0.2 animations:^{_PriceNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButton.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButton.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DollarButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ShekelButtonFull.center = CGPointMake(53, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PoundButtonFull.center = CGPointMake(90, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButton.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_PersentButtonFull.center = CGPointMake(18, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoTime.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoDate.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetotimeFull.center = CGPointMake(20, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetodateFull.center = CGPointMake(50, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
}

//AVCaptureSession to show live video feed in view
- (void) initializeCamera {
    
    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (videoDevice) {
        NSError *error;
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
        } else {
            _SnapButton.enabled=NO;
            _SnapButton2.enabled=NO;
            return;
        }
    } else {
        _SnapButton.enabled=NO;
        _SnapButton2.enabled=NO;
        return;
    }
    self.captureSession.sessionPreset=AVCaptureSessionPresetPhoto;
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    previewLayer.frame = _imagePreview.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_imagePreview.layer addSublayer:previewLayer];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.captureSession addOutput:self.stillImageOutput];

    [self.captureSession startRunning];
}

- (IBAction)snapImage:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{_FlashView.alpha=1.0;}];
    [UIView animateWithDuration:0.2 animations:^{_SnapButton2.alpha=1.0;}];
    [UIView animateWithDuration:0.2 animations:^{_SnapButton.alpha=0.0;}];
    [self capImage];
    [self Flash];
}

-(void) Flash {
    [UIView animateWithDuration:1.0 animations:^{_FlashView.alpha=0.0;}];
}

-(void) CameraMode {
    //[self initializeCamera];
    //[session startRunning];
    _PageControl.hidden=YES;
    _BlackCoverImage.hidden=YES;
    _captureImage.hidden = YES;
    _imagePreview.hidden = NO;
    _RotateCamButton.hidden=NO;
    _TrashButton.hidden=YES;
    _AddAnotherPicButton.hidden=YES;
    _PicFromLibButton.hidden=NO;
    _SnapButton.hidden=NO;
    _ExitCameraButton.hidden=NO;
    [_scrollcamera setScrollEnabled:NO];
    _SnapButton.alpha=1.0;
    _SnapButton2.alpha=0.0;
    [_scrollcamera setContentSize:((CGSizeMake(320, 155)))];
}

-(void) ImageslideMode {
    //[session stopRunning];
    _imagePicker=nil;
    _imagePicker.delegate=nil;
    if (numofpics>=2) {
        _PageControl.hidden=NO;
    } else _PageControl.hidden=YES;
    _PageControl.numberOfPages=numofpics;
    _SnapButton.alpha=0.0;
    _SnapButton2.alpha=0.0;
    _BlackCoverImage.hidden=NO;
    currentpage=0;
    _ExitCameraButton.hidden=YES;
    _captureImage.hidden = NO; //show the captured image view
    _imagePreview.hidden = YES; //hide the live video feed
    _RotateCamButton.hidden=YES;
    _SnapButton.hidden=YES;
    _PicFromLibButton.hidden=YES;
    _TrashButton.hidden=NO;
    if (numofpics == 4) {
        _AddAnotherPicButton.hidden=YES;
    } else _AddAnotherPicButton.hidden=NO;
    [self EnlargeCameraScroll];
}

- (void) capImage {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        
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
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}


- (void) processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    haveImage = YES;

    UIGraphicsBeginImageContext(CGSizeMake(320, 320*2592/1936));
    [image drawInRect: CGRectMake(0, 0, 320, 320*2592/1936)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cropRect = CGRectMake(2, 55+53+20, 310, 155);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    if (numofpics==0) {
        _captureImage.image=[UIImage imageWithCGImage:imageRef];
    }
    if (numofpics==1) {
        _captureImage2.image=[UIImage imageWithCGImage:imageRef];
    }
    if (numofpics==2) {
        _captureImage3.image=[UIImage imageWithCGImage:imageRef];
    }
    if (numofpics==3) {
        _captureImage4.image=[UIImage imageWithCGImage:imageRef];
    }
    numofpics++;
    [self oreder];
    [self EnlargeCameraScroll];
    [self ImageslideMode];
    
    CGImageRelease(imageRef);
}


-(void) ExitCameraButtonAction:(id)sender {
    if (numofpics>0) {
        [self ImageslideMode];
    }
}

-(void) TrashButtonAction:(id)sender {
    //    [session stopRunning];
    if (currentpage==0) {
        if (numofpics==1) {
            _captureImage.image=nil;
        }
        if (numofpics==2) {
            _captureImage.image=_captureImage2.image;
            _captureImage2.image=nil;
        }
        if (numofpics==3) {
            _captureImage.image=_captureImage2.image;
            _captureImage2.image=_captureImage3.image;
            _captureImage3.image=nil;
        }
        if (numofpics==4) {
            _captureImage.image=_captureImage2.image;
            _captureImage2.image=_captureImage3.image;
            _captureImage3.image=_captureImage4.image;
            _captureImage4.image=nil;
        }
        
    }
    if (currentpage==1) {
        if (numofpics==2) {
            _captureImage2.image=nil;
        }
        if (numofpics==3) {
            _captureImage2.image=_captureImage3.image;
            _captureImage3.image=nil;
        }
        if (numofpics==4) {
            _captureImage2.image=_captureImage3.image;
            _captureImage3.image=_captureImage4.image;
            _captureImage4.image=nil;
        }
    }
    
    if (currentpage==2) {
        if (numofpics==3) {
            _captureImage3.image=nil;
        } else{
            _captureImage3.image=_captureImage4.image;
            _captureImage4.image=nil;
        }
    }
    
    if (currentpage==3) {
        _captureImage4.image=nil;
    }
    
    numofpics--;
    [self ImageslideMode];
    if (numofpics==0) {
        [self CameraMode];
    }
    // report_memory();
}

-(void) AddAnotherPicButtonAction:(id)sender{
    [self CameraMode];
}

-(void) RotateCamButtonAction:(id)sender {
    /*
    if (Flag) {
        FrontCamera = YES;
        Flag = false;
        [self.captureSession stopRunning];
        [self initializeCamera];
    }
    else {
        FrontCamera = NO;
        Flag = true;
        [self.captureSession stopRunning];
        [self initializeCamera];
    }*/
    
}

-(void) PicFromLibButtonAction:(id)sender { /*
                                             _imagePicker=nil;
                                             _imagePicker.delegate=nil;
                                             _imagePicker = [[GKImagePicker alloc] init];
                                             _imagePicker.delegate = self;
                                             [self presentViewController:_imagePicker.imagePickerController animated:YES completion:nil];*/
}

/*-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 NSLog(@"here/n/n/n");
 if (numofpics==0) {
 _captureImage.image=[info objectForKey:UIImagePickerControllerEditedImage];
 }
 if (numofpics==1) {
 _captureImage2.image=[info objectForKey:UIImagePickerControllerEditedImage];
 }
 if (numofpics==2) {
 _captureImage3.image=[info objectForKey:UIImagePickerControllerEditedImage];
 }
 if (numofpics==3) {
 _captureImage4.image=[info objectForKey:UIImagePickerControllerEditedImage];
 }
 [self dismissViewControllerAnimated:YES completion:nil];
 numofpics++;
 [self oreder];
 NSLog(@"numofpicafterlib %d",numofpics);
 [self ImageslideMode];
 }*/


-(void) MoreButtonAction:(id)sender {
    
    if ([_morebutton isEqual:@"a"]){
        [_MoreButtonButton setImage:[UIImage imageNamed:@"Add Deal (Final)_More Details button (selected).png"] forState:UIControlStateNormal];
        _morebutton=@"b";
    }
    
    else {
        [_MoreButtonButton setImage:[UIImage imageNamed:@"Add Deal (Final)_More Details button.png"] forState:UIControlStateNormal];
        _morebutton=@"a";
    }
    
    
    if (isMoreOptionViewHidden) {
        CGRect frame3 = _MoreView.frame;
        frame3.origin.y = frame3.origin.y + 190;
        [UIView animateWithDuration:0.6 animations:^{_MoreView.frame = frame3;}];
        
        CGRect frame = _AddDealButton.frame;
        frame.origin.y = frame.origin.y + 200;
        [UIView animateWithDuration:0.6 animations:^{_AddDealButton.frame = frame;}];
        CGRect frame2 = _SocialView.frame;
        frame2.origin.y = frame2.origin.y + 200;
        [UIView animateWithDuration:0.6 animations:^{_SocialView.frame = frame2;}];
        isMoreOptionViewHidden = false;
        [self performSelector:@selector(scrollOffset) withObject:nil afterDelay:0.1];
        [self ReduceScroll];
        
    } else {
        CGRect frame3 = _MoreView.frame;
        frame3.origin.y = frame3.origin.y - 190;
        [UIView animateWithDuration:0.6 animations:^{_MoreView.frame = frame3;}];
        
        CGRect frame = _AddDealButton.frame;
        frame.origin.y = frame.origin.y - 200;
        [UIView animateWithDuration:0.6 animations:^{_AddDealButton.frame = frame;}];
        CGRect frame2 = _SocialView.frame;
        frame2.origin.y = frame2.origin.y - 200;
        [UIView animateWithDuration:0.6 animations:^{_SocialView.frame = frame2;}];
        isMoreOptionViewHidden = true;
        [self ReduceScroll];
    }
}

-(void) scrollOffset {
    [UIView animateWithDuration:0.7 animations:^{_scroll.contentOffset = CGPointMake(0, 280);}];
}

-(void) EnlargeCameraScroll {
    if (numofpics>=2) {
        [_scrollcamera setContentSize:((CGSizeMake(320*numofpics, 155)))];
        [_scrollcamera setScrollEnabled:YES];
    } else
    {
        [_scrollcamera setScrollEnabled:NO];
        [_scrollcamera setContentSize:((CGSizeMake(320, 155)))];
    }
    
}

-(void) EnlargeScroll:(NSString*)object {
    NSLog(@"enlarge");
    
    if ([object isEqualToString:@"title"]) {
        [_scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(_AddDealButton.frame)+10+216)))];
    }
    if ([object isEqualToString:@"category"]) {
        [_scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(_AddDealButton.frame)+10+216+44)))];
    }
    if ([object isEqualToString:@"price"]) {
        [_scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(_AddDealButton.frame)+10+216+44)))];
    }
    if ([object isEqualToString:@"discount"]) {
        [_scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(_AddDealButton.frame)+10+216+44)))];
    }
    if ([object isEqualToString:@"expire"]) {
        [_scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(_AddDealButton.frame)+10+216+44)))];
    }
    if ([object isEqualToString:@"description"]) {
        [_scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(_AddDealButton.frame)+10+216+44)))];
    }
}

-(void) ReduceScroll {
    NSLog(@"enter reduce= %f",CGRectGetMaxY(_AddDealButton.frame));
    [UIView animateWithDuration:0.5 animations:^{
        [_scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(_AddDealButton.frame)+10)))];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = _scrollcamera.frame.size.width;
    currentpage = floor((_scrollcamera.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _PageControl.currentPage=currentpage;
}

-(void) oreder {
    UIImageView *captureImage_temp = [[UIImageView alloc]init];
    captureImage_temp.image=nil;
    if (numofpics==2) {
        captureImage_temp.image=_captureImage2.image;
        _captureImage2.image=_captureImage.image;
        _captureImage.image=captureImage_temp.image;
    }
    if (numofpics==3) {
        captureImage_temp.image=_captureImage3.image;
        _captureImage3.image=_captureImage2.image;
        _captureImage2.image=_captureImage.image;
        _captureImage.image=captureImage_temp.image;
    }
    if (numofpics==4) {
        captureImage_temp.image=_captureImage4.image;
        _captureImage4.image=_captureImage3.image;
        _captureImage3.image=_captureImage2.image;
        _captureImage2.image=_captureImage.image;
        _captureImage.image=captureImage_temp.image;
    }
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (numofpics==0) {
        _captureImage.image=image;
    }
    if (numofpics==1) {
        _captureImage2.image=image;
    }
    if (numofpics==2) {
        _captureImage3.image=image;
    }
    if (numofpics==3) {
        _captureImage4.image=image;
    }
    numofpics++;
    [self oreder];
    [self ImageslideMode];
}

-(int) isIphone5 {
    if ([[UIScreen mainScreen] bounds].size.height == 568) return 1;
    return 0;
}

-(void) report_memory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %u", info.resident_size);
        NSString *a=[NSString stringWithFormat:@"%u",info.resident_size/1000000];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:a delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
        NSString *a=[NSString stringWithFormat:@"%s",mach_error_string(kerr)];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:a delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
}



- (IBAction)cancelDatePickerPressed:(id)sender {
    
    [self dismissKeyBoard];
    [UIView animateWithDuration:0.5 animations:^{_DatePicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_DateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChagrtoDate.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ChagrtoTime.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_ChangetodateFull.center = CGPointMake(110, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_ChangetotimeFull.center = CGPointMake(80, 700);}];
    [UIView animateWithDuration:0.2 animations:^{_DoneButton.center = CGPointMake(285, 700);}];
    
    _expirationlabel.text=NULL;
}
@end
