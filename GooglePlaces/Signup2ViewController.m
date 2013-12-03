//
//  Signup2ViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 10/6/13.
//
//

#import "Signup2ViewController.h"
#import "ViewalldealsViewController.h"
#import "AppDelegate.h"

@interface Signup2ViewController ()

@end

@implementation Signup2ViewController


@synthesize Fullname;
@synthesize Email;
@synthesize Password;
@synthesize Datebirth;
@synthesize Genger;
@synthesize ImageAdded;
@synthesize PASSWORDMARRAY;
@synthesize addphotobutton;
@synthesize datepick,NavBar,ImageFrame,scroll,GenderNavBar,GenderPicker,ReturnButton,list,ReturnButtonFull,LoadingImage,PurpImage,SignupButton;

-(void) BackgroundMethod {
    NSLog(@"backgroud");
    
    NSArray *types = [[NSArray alloc] initWithObjects:@"TITLE",@"DESCRIPTION",@"STORE",@"PRICE",@"DISCOUNT",@"EXPIRE",@"LIKEBUTTON",@"COMMENT",@"CLIENTID",@"PHOTOID",@"CATEGORY",@"SIGN",@"DEALID",@"USERSIDS", nil];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:0]];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSArray *DataArray = [DataResult componentsSeparatedByString:@"///"];
    NSArray *reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.TITLEMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:1]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.DESCRIPTIONMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:2]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.STOREMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:3]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.PRICEMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:4]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.DISCOUNTMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:5]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.EXPIREMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:6]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.LIKEMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:7]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.COMMENTMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:8]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.CLIENTMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:9]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *PHOTOIDMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    NSMutableArray *convert = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[PHOTOIDMARRAY count]; i++) {
        UIImageView *tempimage = [[UIImageView alloc]init];
        
        NSString *num=[PHOTOIDMARRAY objectAtIndex:i];
        if ([num isEqualToString:@"0"]) {
            tempimage.image =[UIImage imageNamed:@"My Feed+View Deal_NoPic icon.png"];
        }
        else {
            NSString *URLforphoto = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[PHOTOIDMARRAY objectAtIndex:i]];
            tempimage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLforphoto]]];
        }
        [convert addObject:tempimage];
    }
    app.PHOTOIDMARRAYCONVERT = [[NSMutableArray alloc]initWithArray:convert];
    
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:10]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.CATEGORYARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:11]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.SIGNARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:12]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.DEALIDARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:13]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    app.USERSIDSARRAY = [[NSMutableArray alloc] initWithArray:reversed];
    
    app.FAVARRAY = [[NSMutableArray alloc]init];
    for (int i=0; i<[app.TITLEMARRAY count]; i++) {
        [app.FAVARRAY addObject:@"0"];
    }
    app.AfterAddDeal=@"aftersign";
    
    if ([didaddphoto isEqualToString:@"yes"]) {
        NSData *imageData = UIImageJPEGRepresentation(ImageAdded.image, 30);
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
        NSLog(@"%@",Photoid);
        didaddphoto = @"no";
        NSLog(@"loglo");
    }
    NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/phpFile.php?Name=%@&Password=%@&Email=%@&Date=%@&Gender=%@&Photoid=%@",Fullname.text,Password.text,Email.text,Datebirth.text,Genger.text,Photoid];
    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSLog(@"the url is:%@", strURL);
    // to receive the returend value
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    app.UserID = strResult;
    

    [self performSelectorOnMainThread:@selector(MainMethod) withObject:nil waitUntilDone:NO];
    
}

-(void) MainMethod {
    
    ViewalldealsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myfeeds"];
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ReturnButtonFull.alpha=0.0;
    [scroll setScrollEnabled:NO];
    [scroll setContentSize:((CGSizeMake(320, 460)))];

    ImageFrame.hidden = YES;
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
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SingupButton:(id)sender{
    
    NSString *user_email=Email.text;
    NSString *user_password=Password.text;
    [[NSUserDefaults standardUserDefaults] setObject:user_email forKey:@"user_email"];
    [[NSUserDefaults standardUserDefaults] setObject:user_password forKey:@"user_password"];
    
    
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/registercheck.php?var1=%@",Email.text];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSLog(@"email=%@\n",Email.text);
    NSLog(@"data=%@\n",DataResult);
    
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
        [self performSelectorInBackground:@selector(BackgroundMethod) withObject:nil];

    }
    
    
}


- (IBAction)AddphotoButton:(id)sender {
    
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


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    ImageAdded.image = [ info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"Registration_Profile Pic Mask.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 100, 100);
    ImageAdded.layer.mask = mask;
    ImageAdded.layer.masksToBounds = YES;
    addphotobutton.hidden=YES;
    ImageFrame.hidden=NO;
    didaddphoto = @"yes";

    
 
   
    }

-(void) Showuidate {
    [scroll setContentSize:((CGSizeMake(320, 650)))];

    [scroll setScrollEnabled:YES];

    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 140);}];
    [Fullname resignFirstResponder];
    [Email resignFirstResponder];
    [Password resignFirstResponder];

    [UIView animateWithDuration:0.5 animations:^{datepick.center = CGPointMake(160, 352);}];
    [UIView animateWithDuration:0.5 animations:^{NavBar.center = CGPointMake(160, 222);}];
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{GenderNavBar.center = CGPointMake(160, 546);}];

}

-(void) DateButton {
    [scroll setScrollEnabled:NO];

    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    [UIView animateWithDuration:0.5 animations:^{datepick.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{NavBar.center = CGPointMake(160, 546);}];
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
    
    [scroll setScrollEnabled:YES ];
    [scroll setContentSize:((CGSizeMake(320, 650)))];


    [UIView animateWithDuration:0.5 animations:^{datepick.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{NavBar.center = CGPointMake(160, 546);}];
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{GenderNavBar.center = CGPointMake(160, 546);}];

    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 110);}];
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [scroll setScrollEnabled:NO];
    
    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];

    return YES;


    

}
- (void)viewDidUnload {
    [self setAddphotobutton:nil];
    [self setAddphotobutton:nil];
    [super viewDidUnload];
}
- (IBAction)GenderButton:(id)sender {
    
    [scroll setContentSize:((CGSizeMake(320, 650)))];

    [Fullname resignFirstResponder];
    [Email resignFirstResponder];
    [Password resignFirstResponder];

    [scroll setScrollEnabled:YES];

    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 140);}];
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, 352);}];
    [UIView animateWithDuration:0.5 animations:^{GenderNavBar.center = CGPointMake(160, 222);}];
    [UIView animateWithDuration:0.5 animations:^{datepick.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{NavBar.center = CGPointMake(160, 546);}];

}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (ImageAdded.image==NULL) {
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
    }else {
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
    
    }
        }
    
}
- (IBAction)GenderDoneButton:(id)sender {
    
    [scroll setScrollEnabled:NO];

    [UIView animateWithDuration:0.4 animations:^{scroll.contentOffset = CGPointMake(0, 0);}];
    [UIView animateWithDuration:0.5 animations:^{GenderPicker.center = CGPointMake(160, 590);}];
    [UIView animateWithDuration:0.5 animations:^{GenderNavBar.center = CGPointMake(160, 546);}];
}


- (IBAction)ReturnButtonAction:(id)sender {
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  //  [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[list objectAtIndex:row] isEqualToString:@"Gender"]) {
        NSLog(@"GENDER");
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

@end
