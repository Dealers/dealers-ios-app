//
//  Signup2ViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 10/6/13.
//
//

#import "Signup2ViewController.h"
#import "AppDelegate.h"
#import "Functions.h"
#import "MyFeedsViewController.h"

@interface Signup2ViewController ()

@end

@implementation Signup2ViewController


@synthesize Fullname;
@synthesize Email;
@synthesize Password;
@synthesize Datebirth;
@synthesize Genger;
@synthesize ImageAdded;
@synthesize addphotobutton;
@synthesize datepick,NavBar,ImageFrame,scroll,GenderNavBar,GenderPicker,ReturnButton,list,ReturnButtonFull,LoadingImage,PurpImage,SignupButton;

-(void) BackgroundMethod {
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
        didAddPhoto = NO;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/phpFile.php?Name=%@&Password=%@&Email=%@&Date=%@&Gender=%@&Photoid=%@",Fullname.text,Password.text,Email.text,Datebirth.text,Genger.text,Photoid];
    NSLog(@"the url is= %@",strURL);
    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.UserID = strResult;
}

-(void) MainMethod {
    list=nil;
    MyFeedsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"feeds"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController pushViewController:controller animated:YES];
}

-(void) initialize
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ReturnButtonFull.alpha=0.0;
    ImageFrame.hidden = YES;
    [scroll setScrollEnabled:NO];
    [scroll setContentSize:((CGSizeMake(320, 460)))];
    [self.Fullname setDelegate:self];
    [self.Fullname setReturnKeyType:UIReturnKeyDone];
    [self.Fullname addTarget:self action:@selector(Fullname) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.Email setDelegate:self];
    [self.Email setReturnKeyType:UIReturnKeyDone];
    [self.Email addTarget:self action:@selector(Email) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.Password setDelegate:self];
    [self.Password setReturnKeyType:UIReturnKeyDone];
    [self.Password addTarget:self action:@selector(Password) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.Datebirth setDelegate:self];
    [self.Datebirth setReturnKeyType:UIReturnKeyDone];
    [self.Datebirth addTarget:self action:@selector(Datebirth) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.Genger setDelegate:self];
    [self.Genger setReturnKeyType:UIReturnKeyDone];
    [self.Genger addTarget:self action:@selector(Genger) forControlEvents:UIControlEventEditingDidEndOnExit];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    list = [[NSMutableArray alloc] initWithObjects:@"Gender",@"Male",@"Female", nil];
    Photoid=@"0";
    registerAgain=NO;
}

- (void)viewDidLoad
{
    [self initialize];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)StartLoading
{
    [UIView animateWithDuration:0.2 animations:^{SignupButton.alpha=0.0; SignupButton.transform =CGAffineTransformMakeScale(1,1);
        LoadingImage.transform =CGAffineTransformMakeScale(0,0);}];
    
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
    [UIView animateWithDuration:0.2 animations:^{LoadingImage.alpha=1.0; LoadingImage.transform =CGAffineTransformMakeScale(0,0);
        LoadingImage.transform =CGAffineTransformMakeScale(1,1);}];
}

-(IBAction)SingupButton:(id)sender
{
    
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/registercheck.php?var1=%@",Email.text];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    
    if (([Email.text isEqual:@""]) || ([Email.text isEqual:@"Email"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter an Email Address" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    } else if ([Email.text rangeOfString:@"@"].location == NSNotFound) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Email is incorrect" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    
    else if (([Fullname.text isEqual:@""]) ||  ([Fullname.text isEqual:@"Fullname"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter your name" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    } else if (([Password.text isEqual:@""]) ||  ([Password.text isEqual:@"Password"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter a Password" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    } else if ([DataResult isEqualToString:@"exist"]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Email already exist" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [Fullname resignFirstResponder];
        [Email resignFirstResponder];
        [Password resignFirstResponder];
        [self StartLoading];
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            [self BackgroundMethod];
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI on the main thread.
                AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                NSLog(@"usrid=%@",app.UserID);
                if (([app.UserID isEqualToString:@"0"])||(app.UserID==nil)||([app.UserID isEqualToString:@""])) {
                    registerAgain=YES;
                    [LoadingImage stopAnimating];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Register fail, please try again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    [alert show];
                } else
                [self MainMethod];
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
    addphotobutton.hidden=YES;
    ImageFrame.hidden=NO;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    ImageAdded.image = [ info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self MaskImage];
    didAddPhoto = YES;
}

-(void)CleanScreen:(NSString*)string
{
    
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{GenderNavBar.center = CGPointMake(160, 546);}];
    [UIView animateWithDuration:0.5 animations:^{datepick.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{NavBar.center = CGPointMake(160, 546);}];
    [scroll setScrollEnabled:NO];
    
    if (![string isEqualToString:@"text"]) {
        [Fullname resignFirstResponder];
        [Email resignFirstResponder];
        [Password resignFirstResponder];
    }
}

-(void) ShowDatePicker {
    [self CleanScreen:@"DatePicker"];
    [scroll setContentSize:((CGSizeMake(320, 650)))];
    [scroll setScrollEnabled:YES];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 140);}];
    [UIView animateWithDuration:0.5 animations:^{datepick.center = CGPointMake(160, 352);}];
    [UIView animateWithDuration:0.5 animations:^{NavBar.center = CGPointMake(160, 222);}];
}

-(void) HideDatePicker {
    [self CleanScreen:@"DatePicker"];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
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
}

-(void) keyboardWillShow {
}

-(void) keyboardWillHide {
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    [self CleanScreen:@"text"];
    [scroll setScrollEnabled:YES ];
    [scroll setContentSize:((CGSizeMake(320, 650)))];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 110);}];
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [scroll setScrollEnabled:NO];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    return YES;
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)GenderButton:(id)sender {
    [self CleanScreen:@"GenderPicker"];
    [scroll setContentSize:((CGSizeMake(320, 650)))];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 140);}];
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, 352);}];
    [UIView animateWithDuration:0.5 animations:^{GenderNavBar.center = CGPointMake(160, 222);}];
    [scroll setScrollEnabled:YES];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (ImageAdded.image==NULL)
    {
        if (buttonIndex == 0) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing=YES;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        if (buttonIndex==1) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing=YES;
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
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
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
    [scroll setScrollEnabled:NO];
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
}
@end
