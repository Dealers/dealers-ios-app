//
//  SignupViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "SignupViewController.h"
#import "ViewController.h"
@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize Fullname;
@synthesize Email;
@synthesize Password;
@synthesize Datebirth;
@synthesize Genger;
@synthesize ImageAdded;
@synthesize PASSWORDMARRAY;
@synthesize addphotobutton;


- (void)viewDidLoad
{
    
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
    firstornot = @"first";
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

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ViewController *load=[story instantiateViewControllerWithIdentifier:@"ViewController"];
    
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/registercheck.php?var1=%@",Email.text];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSLog(@"email=%@\n",Email.text);
    NSLog(@"data=%@\n",DataResult);
    
    if (([Email.text isEqual:@""]) || ([Fullname.text isEqual:@""]) || ([Password.text isEqual:@""])) {
        NSLog(@"null");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter username,password and email" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else if ([DataResult isEqualToString:@"exist"]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Email already exist" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
            else {
                NSString *strURL = [NSString stringWithFormat:@"http://www.dealers.co.il/phpFile.php?Name=%@&Password=%@&Email=%@&Date=%@&Gender=%@&Photoid=%@",Fullname.text,Password.text,Email.text,Datebirth.text,Genger.text,Photoid];
                // to execute php code
                NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
                
                // to receive the returend value
                NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
                NSLog(@"%@", strResult);

                    load.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:load animated:YES completion:nil];
    }

    
}


- (IBAction)AddphotoButton:(id)sender {
    
    addphotobutton.hidden=YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
    firstornot = @"not";
}

- (IBAction)secondimageButton:(id)sender {
}

- (IBAction)thirdimageButton:(id)sender {
}

- (IBAction)fourthimageButton:(id)sender {
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    ImageAdded.image = [ info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSData *imageData = UIImageJPEGRepresentation(ImageAdded.image, 90);
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
    
    
}

- (void)viewDidUnload {
    [self setScroll:nil];
    [self setAddphotobutton:nil];
    [self setSecondimage:nil];
    [self setThirdimage:nil];
    [self setFourth:nil];
    [self setAddphotobutton:nil];
    [self setSecondimageB:nil];
    [self setThirdimageB:nil];
    [self setFourthimageB:nil];
    [super viewDidUnload];
}
@end
