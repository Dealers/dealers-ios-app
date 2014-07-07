//
//  EditProfileViewController.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import "EditProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DealerClass.h"
#import "CheckConnection.h"
#import "AppDelegate.h"
@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

-(void) dealerClassSetting {
    
    CheckConnection *checkconnection = [[CheckConnection alloc]init];
    if ([checkconnection connected]) {
        
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSString * url= [NSString stringWithFormat:@"http://www.dealers.co.il/editProfile.php?Userid=%@",app.UserID];
            NSURL *dbRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            NSData *data = [NSData dataWithContentsOfURL: dbRequestURL];
            NSError* error;
            
            if (data!=nil) {
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
                NSDictionary *responseData = json[@"respone"];
                NSArray *user = responseData[@"users"];
                NSLog(@"%@",user);
                
                for (int i=0; i<[user count]-1 && user!=NULL; i++)
                {
                    _dealerClass = [[DealerClass alloc]init];
                    NSDictionary *userDictionary = [user objectAtIndex:i];
                    [_dealerClass setUserName:[userDictionary objectForKey:@"name"]];
                    [_dealerClass setUserEmail:[userDictionary objectForKey:@"email"]];
                    [_dealerClass setUserGender:[userDictionary objectForKey:@"gender"]];
                    [_dealerClass setUserDateofBirth:[userDictionary objectForKey:@"dateOfBirth"]];
                    [_dealerClass setUserPhotoID:[userDictionary objectForKey:@"photoID"]];
                    [_dealerClass setUserLocation:[userDictionary objectForKey:@"location"]];
                    [_dealerClass setUserAbout:[userDictionary objectForKey:@"about"]];
                    [_dealerClass setUserPassword:[userDictionary objectForKey:@"password"]];

                }
            }
            NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealerClass getUserPhotoID]];
            NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI on the main thread.
                UIImage *image = [UIImage imageWithData:URLData];
                _userImage.image=image;
                CALayer *mask = [CALayer layer];
                mask.contents=(id)[[UIImage imageNamed:@"Registration_Email button.png"]CGImage];
                mask.frame = CGRectMake(0, 0, 80, 80);
                _userImage.layer.mask = mask;
                _userImage.layer.masksToBounds = YES;
                _userNameTF.text=[_dealerClass getUserName];
                _userEmailTF.text=[_dealerClass getUserEmail];
                _userAboutTF.text=[_dealerClass dealerEmpty:[_dealerClass getUserAbout]] ? [_dealerClass getUserAbout] : NULL;
                _userLocationTF.text=[_dealerClass dealerEmpty:[_dealerClass getUserLocation]] ? [_dealerClass getUserLocation] : NULL;
                _userGenderTF.text=[_dealerClass dealerEmpty:[_dealerClass getUserGender]] ? [_dealerClass getUserGender] : NULL;
                _userBirthTF.text=[_dealerClass dealerEmpty:[_dealerClass getUserDateofBirth]] ? [_dealerClass getUserDateofBirth] : NULL;
                _userPasswordTF.text=[_dealerClass dealerEmpty:[_dealerClass getUserPassword]] ? [_dealerClass getUserPassword] : NULL;

                [self removeWhiteCover];
                [_LoadingImage stopAnimating];
                
                
            });
        });
        
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) showWhiteCover {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    [self.view bringSubviewToFront:button1];
    [self.view bringSubviewToFront:_LoadingImage];
    
    [UIView animateWithDuration:0.3 animations:^{
        button1.alpha=0.8;
    }];
}

-(void) removeWhiteCover {
    NSLog(@"remove white cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    
    [UIView animateWithDuration:0.3 animations:^{
        button1.alpha=0.0;
    }];
}

-(void) startLoadingUploadIcon:(UIImageView*)image {
    
    image.animationImages = [NSArray arrayWithObjects:
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
    image.animationDuration = 0.3;
    [image startAnimating];
    [UIView animateWithDuration:0.2 animations:^{image.alpha=1.0; image.transform =CGAffineTransformMakeScale(0,0);
        image.transform =CGAffineTransformMakeScale(1,1);}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *selectDealButton9=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton9 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton9.frame=CGRectMake(0, 0,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height));
    selectDealButton9.tag=110;
    [selectDealButton9 setBackgroundColor:[UIColor whiteColor]];
    selectDealButton9.alpha=0.0;
    [[self view] addSubview:selectDealButton9];
    [self showWhiteCover];
    [self startLoadingUploadIcon:_LoadingImage];
    _genderList = [[NSMutableArray alloc] initWithObjects:@"Gender",@"Male",@"Female", nil];
    _scrollView.frame=CGRectMake(0, 44, 320, [[UIScreen mainScreen] bounds].size.height);
    [_scrollView setContentSize:((CGSizeMake(320, CGRectGetMaxY(_scrollEnd.frame)+44)))];
    [self dealerClassSetting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnButtonClicked:(id)sender {
    _dealerClass=Nil;
    _datePicker=Nil;
    _genderPicker=Nil;
    _userImage=Nil;
    _genderList=Nil;
    UINavigationController * navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];

}

-(void)removeAllKeyboards{
    [self hideDatePicker];
    [self hideGenderPicker];
    [_userEmailTF resignFirstResponder];
    [_userAboutTF resignFirstResponder];
    [_userLocationTF resignFirstResponder];
    [_userNameTF resignFirstResponder];
    [_userPasswordTF resignFirstResponder];
}

-(BOOL) checkFields {
    if (_userPasswordTF==NULL) {
        return 0;
    }
    if (_userNameTF==NULL) {
        return 0;
    }
    if (_userEmailTF==NULL) {
        return 0;
    }

    return 1;
}

-(void) uploadImage {
    NSData *imageData = UIImageJPEGRepresentation(_userImage.image, 2);
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
    [_dealerClass setUserPhotoID:returnString];
}

-(BOOL) uploadUserData {
    if (_userAboutTF==NULL) {
        [_dealerClass setUserAbout:@"0"];
    } else     [_dealerClass setUserAbout:_userAboutTF.text];
    if (_userGenderTF==NULL) {
        [_dealerClass setUserGender:@"0"];
    } else     [_dealerClass setUserGender:_userGenderTF.text];
    if (_userBirthTF==NULL) {
        [_dealerClass setUserDateofBirth:@"0"];
    } else     [_dealerClass setUserDateofBirth:_userBirthTF.text];
    if (_userLocationTF==NULL) {
        [_dealerClass setUserLocation:@"0"];
    } else     [_dealerClass setUserLocation:_userLocationTF.text];
    
    
    [_dealerClass setUserName:_userNameTF.text];
    [_dealerClass setUserPassword:_userPasswordTF.text];
    [_dealerClass setUserEmail:_userEmailTF.text];

    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/editProfileUpdating.php?Name=%@&Password=%@&Email=%@&Date=%@&Gender=%@&Photoid=%@&About=%@&Location=%@&Userid=%@",[_dealerClass getUserName],[_dealerClass getUserPassword],[_dealerClass getUserEmail],[_dealerClass getUserDateofBirth],[_dealerClass getUserGender],[_dealerClass getUserPhotoID],[_dealerClass getUserAbout],[_dealerClass getUserLocation],app.UserID];
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",strURL);
    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    if ([strResult isEqualToString:@"success"]) {
        app.dealerName=[_dealerClass getUserName];
        app.dealerProfileImage = _userImage.image;
        return 1;
    } else return 0;
}

-(void) errorUpadting {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Register fail, please try again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)updateButtonClicked:(id)sender {
    [self removeAllKeyboards];
    BOOL flag=[self checkFields];
    if (flag) {
        [self showWhiteCover];
        [self LoadingImage];
        [self uploadImage];
        BOOL flag2=[self uploadUserData];
        if (flag2) {
            [self returnButtonClicked:NO];
        } else {
            [self errorUpadting];
            [self removeWhiteCover];
            [_LoadingImage stopAnimating];
        }
    }
}

- (IBAction)editButtonClicked:(id)sender
{
    UIActionSheet *alert;
    if (_userImage.image == nil) {
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

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_userImage.image==NULL)
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
            _userImage.image=[UIImage imageNamed:@"Profile_noPic.jpg"];
            photoFlag = NO;
        }
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _userImage.image = [ info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self MaskImage];
    photoFlag = YES;
}

-(void)MaskImage
{
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"Registration_Profile Pic Mask.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 80, 80);
    _userImage.layer.mask = mask;
    _userImage.layer.masksToBounds = YES;
}

-(void)scrollSetting:(NSString*)string
{
    if ([string isEqualToString:@"name"]) {
        [self hideDatePicker];
        [self hideGenderPicker];
        [UIView animateWithDuration:0.5 animations:^{
            [_scrollView setContentSize:((CGSizeMake(320, CGRectGetMaxY(_userPasswordTF.frame)+20+216+44)))];
        }];
        [UIView animateWithDuration:0.4 animations:^{_scrollView.contentOffset = CGPointMake(0, 100);}];
        
    }
    
    if ([string isEqualToString:@"gender"]) {
        [_userEmailTF resignFirstResponder];
        [_userAboutTF resignFirstResponder];
        [_userLocationTF resignFirstResponder];
        [_userNameTF resignFirstResponder];
        [_userPasswordTF resignFirstResponder];
        [self hideDatePicker];
        [UIView animateWithDuration:0.5 animations:^{
            [_scrollView setContentSize:((CGSizeMake(320, CGRectGetMaxY(_userPasswordTF.frame)+20+216+88)))];
        }];
        [UIView animateWithDuration:0.4 animations:^{_scrollView.contentOffset = CGPointMake(0, 200);}];
        
    }
    
    if ([string isEqualToString:@"date"]) {
        [_userEmailTF resignFirstResponder];
        [_userAboutTF resignFirstResponder];
        [_userLocationTF resignFirstResponder];
        [_userNameTF resignFirstResponder];
        [_userPasswordTF resignFirstResponder];
        [self hideGenderPicker];
        [UIView animateWithDuration:0.5 animations:^{
            [_scrollView setContentSize:((CGSizeMake(320, CGRectGetMaxY(_userPasswordTF.frame)+20+216+88)))];
        }];
        [UIView animateWithDuration:0.4 animations:^{_scrollView.contentOffset = CGPointMake(0, 200);}];
        
    }
    
    
    if ([string isEqualToString:@"email"]) {
        [self hideDatePicker];
        [self hideGenderPicker];
        [UIView animateWithDuration:0.5 animations:^{
            [_scrollView setContentSize:((CGSizeMake(320, CGRectGetMaxY(_userPasswordTF.frame)+20+216+44)))];
        }];
        [UIView animateWithDuration:0.4 animations:^{_scrollView.contentOffset = CGPointMake(0, 300);}];
        
        
    }
    
    if ([string isEqualToString:@"default"]) {
        [_userEmailTF resignFirstResponder];
        [_userAboutTF resignFirstResponder];
        [_userLocationTF resignFirstResponder];
        [_userNameTF resignFirstResponder];
        [_userPasswordTF resignFirstResponder];
        [self scrollDefaultSize];
    }
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField==_userNameTF || textField==_userAboutTF || textField==_userLocationTF) {
        [self scrollSetting:@"name"];
    } else if (textField==_userEmailTF || textField==_userPasswordTF) {
        [self scrollSetting:@"email"];
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn");
    [self scrollSetting:@"default"];
    return YES;
}

- (IBAction)userBirthButtonClicked:(id)sender
{
    [self scrollSetting:@"date"];
    if (!allocDatePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height), 0, 0)];
        _datePicker.datePickerMode=UIDatePickerModeDate;
        [self.view addSubview:_datePicker];
    } allocDatePicker=YES;
    
    int datepickerheight=self.view.frame.size.height - _datePicker.bounds.size.height/2;
    int datepickerNavigationBarHeight=self.view.frame.size.height - _datePicker.bounds.size.height-22;
    NSLog(@"%d,%d",datepickerheight,datepickerNavigationBarHeight);
    [UIView animateWithDuration:0.5 animations:^{_datePicker.center = CGPointMake(160, datepickerheight);}];
    [UIView animateWithDuration:0.5 animations:^{_dateNavBar.center = CGPointMake(160, datepickerNavigationBarHeight);}];
    
}

- (IBAction)userGenderButtonClicked:(id)sender
{
    [self scrollSetting:@"gender"];
    if (!allocGenderPicker) {
        _genderPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height), 0, 0)];
        _genderPicker.delegate=self;
        _genderPicker.dataSource=self;
        _genderPicker.showsSelectionIndicator=YES;
        [self.view addSubview:_genderPicker];
    } allocGenderPicker=YES;
    
    int genderpickerheight=self.view.frame.size.height - _genderPicker.bounds.size.height/2;
    int genderpickerNavigationBarHeight=self.view.frame.size.height - _genderPicker.bounds.size.height-22;
    
    [UIView animateWithDuration:0.5 animations:^{_genderPicker.center = CGPointMake(160, genderpickerheight);}];
    [UIView animateWithDuration:0.5 animations:^{_genderNavBar.center = CGPointMake(160, genderpickerNavigationBarHeight);}];
}

- (IBAction)dataDoneButtonClicked:(id)sender {
    [self hideDatePicker];
    [self scrollDefaultSize];
    
    NSDate *select = [_datePicker date];
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
    _userBirthTF.text=date;
}

- (IBAction)dateCancleButtonClicked:(id)sender {
    [self hideDatePicker];
    [self scrollDefaultSize];
    _userBirthTF.text=NULL;
}

- (IBAction)genderDoneButtonClicked:(id)sender {
    [self hideGenderPicker];
    [self scrollDefaultSize];
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[_genderList objectAtIndex:row] isEqualToString:@"Gender"]) {
        _userGenderTF.text=NULL;
    } else {
        _userGenderTF.text = [_genderList objectAtIndex:row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_genderList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_genderList objectAtIndex:row];
}

-(void) hideDatePicker
{
    [UIView animateWithDuration:0.5 animations:^{_dateNavBar.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_datePicker.center = CGPointMake(160, 700);}];
    
}

-(void) hideGenderPicker
{
    [UIView animateWithDuration:0.5 animations:^{_genderPicker.center = CGPointMake(160, 700);}];
    [UIView animateWithDuration:0.5 animations:^{_genderNavBar.center = CGPointMake(160, 700);}];
}

-(void) scrollDefaultSize {
    [UIView animateWithDuration:0.5 animations:^{
        [_scrollView setContentSize:((CGSizeMake(320, CGRectGetMaxY(_scrollEnd.frame)+44)))];
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}
@end
