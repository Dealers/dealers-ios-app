//
//  Signup2ViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 10/6/13.
//
//

#import "Signup2ViewController.h"
#import "Functions.h"
#import "MyFeedsViewController.h"

@interface Signup2ViewController ()

@end

@implementation Signup2ViewController

@synthesize appDelegate;
@synthesize Fullname;
@synthesize Email;
@synthesize Password;
@synthesize Datebirth;
@synthesize Genger;
@synthesize ImageAdded;
@synthesize addphotobutton;
@synthesize datepick,NavBar,ImageFrame,scroll,GenderNavBar,GenderPicker,ReturnButton,list,ReturnButtonFull,LoadingImage,PurpImage,SignupButton;


-(void) BackgroundMethod {
    
    DealerClass *dealer = [[DealerClass alloc]init];
    
    if (didAddPhoto) {
        NSData *imageData = UIImageJPEGRepresentation(ImageAdded.image, 2);
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
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        Photoid = returnString;
        
        dealer.userPhoto = ImageAdded.image;
        
        didAddPhoto = NO;
    
    } else {
        dealer.userPhoto = [UIImage imageNamed:@"Profile_noPic.jpg"];
    }
    
    NSString *date;
    if ([Datebirth.text length] == 0) {
        date = @"0";
    } else date = Datebirth.text;
    
    NSString *gender;
    if ([Genger.text length] == 0) {
        gender = @"0";
    } else gender = Genger.text;
    
    NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/phpFile.php?Name=%@&Password=%@&Email=%@&Date=%@&Gender=%@&Photoid=%@",Fullname.text,Password.text,Email.text,date,gender,Photoid];
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",strURL);
    
    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    // Filling the information on the user:
    
    dealer.userID = strResult;
    dealer.userName = Fullname.text;
    dealer.userPassword = Password.text;
    dealer.userEmail = Email.text;
    dealer.userDateofBirth = date;
    dealer.userGender = gender;
    dealer.userPhotoID = Photoid;
    
    appDelegate.dealerClass = dealer;
}

-(void) initialize
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    ReturnButtonFull.alpha=0.0;
    ImageFrame.hidden = YES;
    isPopping = NO;
    [scroll setScrollEnabled:NO];
    [scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(SignupButton.frame)+10+216+44)))];
    scrollOriginOffset = scroll.contentOffset;
    [self.Fullname setDelegate:self];
    [self.Fullname setReturnKeyType:UIReturnKeyNext];
    [self.Fullname addTarget:self action:@selector(Fullname) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.Fullname.tag = 1;
    [self.Email setDelegate:self];
    [self.Email setReturnKeyType:UIReturnKeyNext];
    [self.Email addTarget:self action:@selector(Email) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.Email.tag = 2;
    [self.Password setDelegate:self];
    [self.Password setReturnKeyType:UIReturnKeyNext];
    [self.Password addTarget:self action:@selector(Password) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.Password.tag = 3;
    [self.Datebirth setDelegate:self];
    [self.Datebirth setReturnKeyType:UIReturnKeyNext];
    [self.Datebirth addTarget:self action:@selector(Datebirth) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.Datebirth.tag = 4;
    [self.Genger setDelegate:self];
    [self.Genger setReturnKeyType:UIReturnKeyDone];
    [self.Genger addTarget:self action:@selector(Genger) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.Genger.tag = 5;
    [self.NavBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.NavBar setBarTintColor:[UIColor lightGrayColor]];
    [self.NavBar setTranslucent:YES];
    [self.GenderNavBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.GenderNavBar setBarTintColor:[UIColor lightGrayColor]];
    [self.GenderNavBar setTranslucent:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    list = [[NSMutableArray alloc] initWithObjects:@"Gender",@"Male",@"Female", nil];
    Photoid=@"0";
    registerAgain=NO;
}

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title = @"Sign Up";
    [self setElementsLocation];
    [self initialize];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    isPopping = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    isPopping = YES;
    self.app.networkActivityIndicatorVisible = NO;
}

- (void)setElementsLocation
{
    PurpImage.center = CGPointMake(PurpImage.center.x, CGRectGetMaxY(self.textFieldsFrame.frame) + 42);
    SignupButton.center = PurpImage.center;
    LoadingImage.center = PurpImage.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)StartLoading
{
    self.app.networkActivityIndicatorVisible = YES;
    [UIView animateWithDuration:0.3 animations:^{SignupButton.alpha=0.0; SignupButton.transform =CGAffineTransformMakeScale(1,1);
        SignupButton.transform =CGAffineTransformMakeScale(0,0);}];
    
    LoadingImage.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"Loadingwhite.png"],
                                    [UIImage imageNamed:@"Loading5white.png"],
                                    [UIImage imageNamed:@"Loading10white.png"],
                                    [UIImage imageNamed:@"Loading15white.png"],
                                    [UIImage imageNamed:@"Loading20white.png"],
                                    [UIImage imageNamed:@"Loading25white.png"],
                                    [UIImage imageNamed:@"Loading30white.png"],
                                    [UIImage imageNamed:@"Loading35white.png"],
                                    [UIImage imageNamed:@"Loading40white.png"],
                                    [UIImage imageNamed:@"Loading45white.png"],
                                    [UIImage imageNamed:@"Loading50white.png"],
                                    [UIImage imageNamed:@"Loading55white.png"],
                                    [UIImage imageNamed:@"Loading60white.png"],
                                    [UIImage imageNamed:@"Loading65white.png"],
                                    [UIImage imageNamed:@"Loading70white.png"],
                                    [UIImage imageNamed:@"Loading75white.png"],
                                    [UIImage imageNamed:@"Loading80white.png"],
                                    [UIImage imageNamed:@"Loading85white.png"],
                                    nil];
    LoadingImage.animationDuration = 0.3;
    [LoadingImage startAnimating];
    [UIView animateWithDuration:0.3 animations:^{LoadingImage.alpha=1.0; LoadingImage.transform =CGAffineTransformMakeScale(0,0);
        LoadingImage.transform =CGAffineTransformMakeScale(1,1);}];
}

-(void) StopLoading
{
    self.app.networkActivityIndicatorVisible = NO;
    [UIView animateWithDuration:0.3 animations:^{LoadingImage.alpha=0.0; LoadingImage.transform =CGAffineTransformMakeScale(1,1); LoadingImage.transform =CGAffineTransformMakeScale(0,0);}];
    [LoadingImage stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{SignupButton.alpha=1.0; SignupButton.transform =CGAffineTransformMakeScale(0,0);
        SignupButton.transform =CGAffineTransformMakeScale(1,1);}];
}

- (IBAction)SingupButton:(id)sender
{
    self.app = [UIApplication sharedApplication];
    
    if (([Fullname.text isEqual:@""]) ||  ([Fullname.text isEqual:@"Fullname"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You must enter your name." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    } else if (([Email.text isEqual:@""]) || ([Email.text isEqual:@"Email"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You must enter an email address." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    } else if ([Email.text rangeOfString:@"@"].location == NSNotFound) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    
    } else if (([Password.text isEqual:@""]) ||  ([Password.text isEqual:@"Password"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You must enter a password." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    
    } else {
        
        [self StartLoading];
        [self resignFirstResponder];
        [self CleanScreen:@"all"];
        
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueueLoading", NULL);
        dispatch_async(queue, ^{
            NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/registercheck.php?var1=%@",Email.text];
            NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
            NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([DataResult isEqualToString:@"exist"]){
                    [self StopLoading];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Email already exist." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    [alert show];
                
                } else {
                    
                    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
                    dispatch_async(queue, ^{

                        [self BackgroundMethod];

                        dispatch_async(dispatch_get_main_queue(), ^{

                            NSLog(@"usrid=%@",appDelegate.dealerClass.userID);
                            
                            if (([appDelegate.dealerClass.userID isEqualToString:@"0"]) || (appDelegate.dealerClass.userID == nil) || ([appDelegate.dealerClass.userID isEqualToString:@""])) {
                                registerAgain = YES;
                                [self StopLoading];
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Register fail, please try again." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                [alert show];
                                
                            } else if ([appDelegate.dealerClass.userID rangeOfString:@"fail"].location == NSNotFound) {
                                
                                if (!isPopping) {
                                    self.app.networkActivityIndicatorVisible = NO;
                                    [appDelegate setTabBarController];
                                }
                                
                            } else {
                                registerAgain = YES;
                                [self StopLoading];
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Register fail, please try again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                [alert show];
                            }
                        });
                    });
                }
            });
        });
    }
}

- (IBAction)AddphotoButton:(id)sender
{
    UIActionSheet *alert;
    if (ImageAdded.image == nil) {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"Camera", @"Library", nil];
        
    } else {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Remove Photo"
                 otherButtonTitles:@"Camera", @"Library", nil];
    }
    [alert showInView:self.view];
}

-(void)MaskImage
{
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"Registration_Profile Pic Mask.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 100, 100);
    ImageAdded.layer.mask = mask;
    ImageAdded.layer.masksToBounds = YES;
    addphotobutton.hidden = YES;
    ImageFrame.hidden = NO;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    ImageAdded.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self MaskImage];
    didAddPhoto = YES;
}

-(void)CleanScreen:(NSString*)string
{
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, 2*([[UIScreen mainScreen] bounds].size.height));
        GenderNavBar.center = CGPointMake(160, 2*([[UIScreen mainScreen] bounds].size.height));
        datepick.center = CGPointMake(160, 2*([[UIScreen mainScreen] bounds].size.height));
        NavBar.center = CGPointMake(160, 2*([[UIScreen mainScreen] bounds].size.height));
    }];
    [scroll setScrollEnabled:NO];
    
    if (![string isEqualToString:@"text"]) {
        [Fullname resignFirstResponder];
        [Email resignFirstResponder];
        [Password resignFirstResponder];
    }
}

-(void) ShowDatePicker {
    [self CleanScreen:@"DatePicker"];
    float navHeight = self.view.frame.size.height - NavBar.bounds.size.height/2-datepick.bounds.size.height;
    float pickerHeight = self.view.frame.size.height - datepick.bounds.size.height/2;
    [scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(SignupButton.frame)+10+216+44)))];
    [scroll setScrollEnabled:YES];
    if ([self isIphone5]==0) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 140);}];
    } else {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 10);}];
    }
    [UIView animateWithDuration:0.5 animations:^{datepick.center = CGPointMake(160, pickerHeight);}];
    [UIView animateWithDuration:0.5 animations:^{NavBar.center = CGPointMake(160, navHeight);}];
}

-(void) HideDatePicker {
    [self CleanScreen:@"DatePicker"];
    NSDate *select = [datepick date];
    NSString *selecteddate = [[NSString alloc]initWithFormat:@"%@",select];
    NSArray *datearray = [selecteddate componentsSeparatedByString:@" "];
    NSString *first = [datearray objectAtIndex:0];
    NSArray *reversedate = [first componentsSeparatedByString:@"-"];
    NSString *day = [reversedate objectAtIndex:2];
    NSString *mounth = [reversedate objectAtIndex:1];
    NSString *year = [reversedate objectAtIndex:0];
    NSString *space = @"-";
    NSString *date = [[NSString alloc] initWithString:day];
    date = [date stringByAppendingString:space];
    date = [date stringByAppendingString:mounth];
    date = [date stringByAppendingString:space];
    date = [date stringByAppendingString:year];
    Datebirth.text=date;
    self.optional_date.hidden=YES;
    [self performSelector:@selector(GenderButton:) withObject:nil];
}

-(void) keyboardWillShow {
}

-(void) keyboardWillHide {
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    [self CleanScreen:@"text"];
    [scroll setScrollEnabled:YES ];
    [scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(SignupButton.frame)+10+216+44)))];
    float shouldScrollTo = CGRectGetMinY(Fullname.frame) - self.navigationController.navigationBar.frame.size.height - 40;
    if ([self isIphone5]==0) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, shouldScrollTo);}];
    } else {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 10);}];
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
        case 1:
            [Email becomeFirstResponder];
            break;
        case 2:
            [Password becomeFirstResponder];
            break;
        case 3:
            [textField resignFirstResponder];
            [self ShowDatePicker];
            break;
        default:
            break;
    }
    return NO;
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)GenderButton:(id)sender {
    [self CleanScreen:@"GenderPicker"];
    float navHeight = self.view.frame.size.height - GenderNavBar.bounds.size.height/2-GenderPicker.bounds.size.height;
    float pickerHeight = self.view.frame.size.height - GenderPicker.bounds.size.height/2;
    [scroll setContentSize:((CGSizeMake(320, CGRectGetMaxY(SignupButton.frame)+10+216+44)))];
    if ([self isIphone5]==0) {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 140);}];
    } else {
        [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 10);}];
    }
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, pickerHeight);}];
    [UIView animateWithDuration:0.5 animations:^{GenderNavBar.center = CGPointMake(160, navHeight);}];
    [scroll setScrollEnabled:YES];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (ImageAdded.image == nil)
    {
        if (buttonIndex == 0) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        if (buttonIndex == 1) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else {
        if (buttonIndex == 1) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        if (buttonIndex==2) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing=YES;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        if (buttonIndex==0) {
            ImageAdded.image=NULL;
            didAddPhoto = NO;
        }
    }
    
}

- (IBAction)GenderDoneButton:(id)sender
{
    [self CleanScreen:@"GenderPicker"];
    [scroll setScrollEnabled:NO];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = scrollOriginOffset;}];
}

- (IBAction)ReturnButtonAction:(id)sender
{
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[list objectAtIndex:row] isEqualToString:@"Gender"]) {
        Genger.text=NULL;
        self.optional_gender.hidden=NO;
    } else {
        Genger.text = [list objectAtIndex:row];
        self.optional_gender.hidden=YES;
    }
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

- (IBAction)tapGesturePressed:(id)sender {
    [Fullname resignFirstResponder];
    [Email resignFirstResponder];
    [Password resignFirstResponder];
    [self CleanScreen:@"GenderPicker"];
    [scroll setScrollEnabled:NO];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = scrollOriginOffset;}];
}



-(int) isIphone5 {
    if ([[UIScreen mainScreen] bounds].size.height == 568) return 1;
    return 0;
}

@end
