

#import "ViewController.h"
#import "AppDelegate.h"
#import "ViewalldealsViewController.h"
#import "OptionalViewController.h"
#import "BackgroundLayer.h"
#import "TableViewController.h"

@interface ViewController ()


@end

@implementation ViewController
@synthesize addedphoto;
@synthesize titlelabel;
@synthesize storelabel;
@synthesize OKbutton;
@synthesize mapView;
@synthesize BackButton,BackButtonSelected,YesButton,NoButton,CoverButton,AreYouThere,Scroll,FillBox,TitleLabel,StoreLabel,AddPhotoButton_noaction,CoverBlack,YesButtonSelected,NoButtonSelected,OKButtonFull,Shade,Shade2,WhiteButton,WhereistheDeal,WhatisheDeal,Add_deal_text,NoFill,MapView2,AreyouthereView;
@synthesize secondimage,secondimageB,thirdimage,thirdimageB,fourth,fourthimageB,secondimageBFull,thirdimageBFull,fourthimageBFull,secondimageBS,thirdimageBS,fourthimageBS,StarImage,Secondary4Image,Secondary3Image,Secondary2Image;

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.Scroll.layer insertSublayer:bgLayer atIndex:0];
    storelabel.tag=2;
    titlelabel.tag=1;
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.savedphoto=0;
    app.didaddphoto=@"no";
    
    secondimageBFull.alpha=0.0;
    thirdimageBFull.alpha=0.0;
    fourthimageBFull.alpha=0.0;
    StarImage.alpha=0.0;
    Add_deal_text.alpha=0.0;
    BackButton.alpha=0.0;
    NoFill.alpha=0.0;
    WhiteButton.hidden=NO;
    BackButtonSelected.alpha=0.0;
    OKButtonFull.alpha=0.0;
    YesButtonSelected.alpha=0.0;
    NoButtonSelected.alpha=0.0;
    MapView2.alpha=0.0;
    CoverBlack.alpha=0.0;
    AreyouthereView.alpha=0.0;
    [Scroll setScrollEnabled:NO];
    [Scroll setContentSize:((CGSizeMake(320, 334)))];

    [self.titlelabel setDelegate:self];
    [self.titlelabel setReturnKeyType:UIReturnKeyDone];
    [self.titlelabel addTarget:self action:@selector(titlelabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.storelabel setDelegate:self];
    [self.storelabel setReturnKeyType:UIReturnKeyDone];
    [self.storelabel addTarget:self action:@selector(storelabel) forControlEvents:UIControlEventEditingDidEndOnExit];
   // OKbutton.hidden=YES;

    [super viewDidLoad];
    
    firstornot = @"first";
    secondimageB.hidden=YES;
    thirdimageB.hidden=YES;
    fourthimageB.hidden=YES;
    secondimageBS.hidden=YES;
    fourthimageBS.hidden=YES;
    thirdimageBS.hidden=YES;
    Secondary2Image.hidden=YES;
    Secondary3Image.hidden=YES;
    Secondary4Image.hidden=YES;

    
    mapView.showsUserLocation = NO;
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
    [UIView animateWithDuration:0.5 animations:^{CoverBlack.alpha=7.0;}];
    [UIView animateWithDuration:0.5 animations:^{MapView2.alpha=1.0;}];

    [UIView animateWithDuration:0.2 animations:^{NoFill.alpha=1.0;}];
    [UIView animateWithDuration:0.2 animations:^{Add_deal_text.alpha=1.0;}];
    [UIView animateWithDuration:0.2 animations:^{BackButton.alpha=1.0;}];
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         Scroll.center = CGPointMake(160, 316);
                         Shade.center = CGPointMake(160, 161);
                     }
                     completion:^(BOOL finished){
                     }];

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];


}

- (IBAction)Addphotobutton:(id)sender {
    
    UIActionSheet *alert;
    if (addedphoto.image == nil) {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"Camera", @"Library", nil];
        alert.tag=1;
        
        
    } else {
        
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Remove Photo"
                 otherButtonTitles:@"Camera", @"Library", nil];
        alert.tag=1;
        
    }
    [alert showInView:self.view];
}

- (IBAction)secondimageButton:(id)sender {
    secondimageBFull.alpha=1.0;
    secondimageB.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.secondimageBFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.secondimageB.alpha=1.0;}];
    
    
    UIActionSheet *alert;
    if (secondimage.image == nil) {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"Camera", @"Library", nil];
        alert.tag=2;
    }
    [alert showInView:self.view];
}

- (IBAction)thirdimageButton:(id)sender {
    thirdimageBFull.alpha=1.0;
    thirdimageB.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.thirdimageBFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.thirdimageB.alpha=1.0;}];
    
    
    UIActionSheet *alert;
    if (thirdimage.image == nil) {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"Camera", @"Library", nil];
        alert.tag=3;
    }
    [alert showInView:self.view];
}

- (IBAction)fourthimageButton:(id)sender {
    fourthimageBFull.alpha=1.0;
    fourthimageB.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.fourthimageBFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.fourthimageB.alpha=1.0;}];
    
    UIActionSheet *alert;
    if (fourth.image == nil) {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"Camera", @"Library", nil];
        alert.tag=4;
    }
    [alert showInView:self.view];
}

- (IBAction)secondimageSquare:(id)sender {
    UIActionSheet *alert;
    if (secondimage.image != nil) {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Remove Photo"
                 otherButtonTitles:@"Camera", @"Library", nil];
        alert.tag=5;
        
    }
    [alert showInView:self.view];
    
}

- (IBAction)fourthimagesSquare:(id)sender {
    UIActionSheet *alert;
    if (thirdimage.image != nil) {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Remove Photo"
                 otherButtonTitles:@"Camera", @"Library", nil];
        alert.tag=7;
    }
    [alert showInView:self.view];
}

- (IBAction)thirdimagrSquare:(id)sender {
    
    UIActionSheet *alert;
    if (thirdimage.image != nil) {
        alert = [[UIActionSheet alloc]
                 initWithTitle:@"Please Choose"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Remove Photo"
                 otherButtonTitles:@"Camera", @"Library", nil];
        alert.tag=6;
    }
    [alert showInView:self.view];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([firstornot isEqualToString:@"first"]){
        addedphoto.image = [ info objectForKey:UIImagePickerControllerEditedImage];
        CALayer *mask = [CALayer layer];
        mask.contents=(id)[[UIImage imageNamed:@"Add Deal_Pic Mask.png"]CGImage];
        mask.frame = CGRectMake(0, 0, 118, 118);
        addedphoto.layer.mask = mask;
        addedphoto.layer.masksToBounds = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        app.savedphoto=addedphoto;
        app.didaddphoto=@"yes";
        StarImage.alpha=1.0;
        secondimageB.hidden=NO;
        secondimageBS.hidden=NO;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{secondimageB.center = CGPointMake(241, 113);}completion:^(BOOL finished){}];
        firstornot=@"second";
    }
    
    else if ([firstornot isEqualToString:@"second"]) {
        secondimage.image = [ info objectForKey:UIImagePickerControllerEditedImage];
        Secondary2Image.hidden=NO;
        CALayer *mask = [CALayer layer];
        mask.contents=(id)[[UIImage imageNamed:@"Add Deal_Pic Mask.png"]CGImage];
        mask.frame = CGRectMake(0, 0, 104, 104);
        secondimage.layer.mask = mask;
        secondimage.layer.masksToBounds = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        secondimageB.hidden=YES;
        secondimageBFull.hidden=YES;
        thirdimageB.hidden=NO;
        thirdimageBS.hidden=NO;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{ thirdimageB.center = CGPointMake(271, 113);}completion:^(BOOL finished){}];
        firstornot=@"third";
    }
    else if ([firstornot isEqualToString:@"third"]) {
        thirdimage.image = [ info objectForKey:UIImagePickerControllerEditedImage];
        Secondary3Image.hidden=NO;
        CALayer *mask = [CALayer layer];
        mask.contents=(id)[[UIImage imageNamed:@"Add Deal_Pic Mask.png"]CGImage];
        mask.frame = CGRectMake(0, 0, 90, 90);
        thirdimage.layer.mask = mask;
        thirdimage.layer.masksToBounds = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        thirdimageB.hidden=YES;
        thirdimageBFull.hidden=YES;
        fourthimageB.hidden=NO;
        fourthimageBS.hidden=NO;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{fourthimageB.center = CGPointMake(301, 113);}completion:^(BOOL finished){}];
        firstornot=@"fourth";
    }
    else if ([firstornot isEqualToString:@"fourth"]) {
        fourth.image = [ info objectForKey:UIImagePickerControllerEditedImage];
        Secondary4Image.hidden=NO;
        CALayer *mask = [CALayer layer];
        mask.contents=(id)[[UIImage imageNamed:@"Add Deal_Pic Mask.png"]CGImage];
        mask.frame = CGRectMake(0, 0, 76, 76);
        fourth.layer.mask = mask;
        fourth.layer.masksToBounds = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        fourthimageB.hidden=YES;
    }
    
}
-(void) change:(UITextView *) textview{
    
    if (titlelabel.text.length == 0) {
        WhatisheDeal.hidden=NO;
        TitleLabel.hidden=NO;
    } else {
        WhatisheDeal.hidden=YES;
        TitleLabel.hidden=YES;
    }
    
    if ((storelabel.text.length == 0)) {
        WhereistheDeal.hidden=NO;
        StoreLabel.hidden=NO;

    } else {
        WhereistheDeal.hidden=YES;
        StoreLabel.hidden=YES;
    }
    
}

- (IBAction)OKbutton:(id)sender {

    if ((titlelabel.text.length == 0) || (storelabel.text.length == 0)) {

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter an Title and Store" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else if (addedphoto.image==NULL) {
    
    OKButtonFull.alpha=1.0;
    OKbutton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{OKButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{OKbutton.alpha=1.0;}];

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Hey!" message:@"You will get more points by enterin photo" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:@"Continue",nil];
        [alert show];
    } else {
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.globaltitlelabel.text=titlelabel.text;
        app.globalstorelabel.text=storelabel.text;
        
        OptionalViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionalafterNO"];
        [self.navigationController pushViewController:controller animated:YES];

        
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
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

-(void) AddDealFunction {
    [UIView animateWithDuration:0.2 animations:^{AreyouthereView.alpha=1.0; AreyouthereView.transform =CGAffineTransformMakeScale(0.85,0.85);
    AreyouthereView.transform =CGAffineTransformMakeScale(1,1);}];
    
}

- (IBAction)BackButtonAction:(id)sender {
    
    BackButtonSelected.alpha=1.0;
    BackButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{BackButtonSelected.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{BackButton.alpha=1.0;}];

    [self.navigationController popViewControllerAnimated:NO];

}

-(void) NoButton:(id)sender {
    
    mapView.showsUserLocation = YES;

    //OKbutton.hidden=NO;
   // NoButtonSelected.alpha=1.0;
  //  NoButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{CoverBlack.alpha=0.0;}];

  //  [UIView animateWithDuration:0.2 animations:^{NoButtonSelected.alpha=0.0;}];
   // [UIView animateWithDuration:0.2 animations:^{NoButton.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{AreyouthereView.alpha=0.0;}];
    CoverButton.hidden=YES;
   // [UIView animateWithDuration:0.2 animations:^{FillBox.alpha=1.0;}];
   // [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    
    //[UIView animateWithDuration:0.2 animations:^{TitleLabel.alpha=1.0;}];
    //[UIView animateWithDuration:0.2 animations:^{titlelabel.alpha=1.0;}];
    ////[UIView animateWithDuration:0.2 animations:^{StoreLabel.alpha=1.0;}];
    //[UIView animateWithDuration:0.2 animations:^{WhereistheDeal.center = CGPointMake(195, 262);}];
    //[UIView animateWithDuration:0.2 animations:^{WhereistheDeal.alpha=1.0;}];
   // [UIView animateWithDuration:0.2 animations:^{WhatisheDeal.alpha=1.0;}];

    //[UIView animateWithDuration:0.2 animations:^{storelabel.alpha=1.0;}];
//
    //[UIView animateWithDuration:0.2 animations:^{AddPhotoButton_noaction.alpha=1.0;}];
   // [UIView animateWithDuration:0.2 animations:^{addedphoto.alpha=1.0;}];
    WhiteButton.hidden=NO;
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag==1) {
        NSLog(@"1");
        
        if (addedphoto.image==NULL) {
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
        }
        else {
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
                NSLog(@"first delete");
                addedphoto.image=NULL;
                [self ChecktheOrder];
            }
        }
    }
    
    if (actionSheet.tag==2) {
        if (secondimage.image==nil) {
            NSLog(@"2");
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
        }}
    
    if (actionSheet.tag==5) {
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
            secondimage.image=NULL;
            Secondary2Image.hidden=YES;
            
            NSLog(@"second delete");
            [self ChecktheOrder];
        }
    }
    
    if (actionSheet.tag==3) {
        if (thirdimage.image==NULL) {
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
        }}
    if (actionSheet.tag==6) {
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
            thirdimage.image=NULL;
            Secondary3Image.hidden=YES;
            
            NSLog(@"third delete");
            [self ChecktheOrder];
            
        }
    }
    
    if (actionSheet.tag==4) {
        if (fourth.image==NULL) {
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
        }}
    if (actionSheet.tag==7) {
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
            fourth.image=NULL;
            Secondary4Image.hidden=YES;
            NSLog(@"third fourth");
            [self ChecktheOrder];
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [Scroll setScrollEnabled:NO];
    [Scroll setContentSize:((CGSizeMake(320, 300)))];
    [UIView animateWithDuration:0.4 animations:^{Scroll.center = CGPointMake(160, 300);}];
    [UIView animateWithDuration:0.4 animations:^{MapView2.center = CGPointMake(160, 106);}];

    [titlelabel addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    [storelabel addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    
    if (titlelabel.text.length == 0) {
        WhatisheDeal.hidden=NO;
        TitleLabel.hidden=NO;
    } else {
        WhatisheDeal.hidden=YES;
        TitleLabel.hidden=YES;
    }
    
    if ((storelabel.text.length == 0)) {
        WhereistheDeal.hidden=NO;
        StoreLabel.hidden=NO;
        
    } else {
        WhereistheDeal.hidden=YES;
        StoreLabel.hidden=YES;
    }

    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    
    [Scroll setScrollEnabled:YES];
    [Scroll setContentSize:((CGSizeMake(320, 350)))];
    if (textField.tag==1) {
        WhatisheDeal.hidden=YES;
        TitleLabel.hidden=YES;
    }
    if (textField.tag==2) {
        WhereistheDeal.hidden=YES;
        StoreLabel.hidden=YES;
    }
    
    //[UIView animateWithDuration:0.4 animations:^{Scroll.contentOffset = CGPointMake(0, 200);}];
    [UIView animateWithDuration:0.4 animations:^{Scroll.center = CGPointMake(160, 100);}];
    [UIView animateWithDuration:0.4 animations:^{MapView2.center = CGPointMake(160, -46);}];

    //[titlelabel addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    //[storelabel addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];

    return YES;
}

-(void) keyboardWillShow {
}

-(void) keyboardWillHide {
}

-(void) YesButton:(id)sender {
    YesButtonSelected.alpha=1.0;
    YesButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{YesButtonSelected.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{YesButton.alpha=1.0;}];
   
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:nil];



}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Continue"])
    {
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.globaltitlelabel.text=titlelabel.text;
        app.globalstorelabel.text=storelabel.text;
        OptionalViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionalafterNO"];
        controller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:controller animated:NO completion:nil];
        

    }
}

-(void) ChecktheOrder {
    
    if (fourth.image==NULL) {
        firstornot=@"fourth";
    }
    if (thirdimage.image==NULL) {
        firstornot=@"third";
    }
    if (secondimage.image==NULL) {
        firstornot=@"second";
    }
    if (addedphoto.image==NULL) {
        firstornot=@"first";
    }
    
    
    if ((addedphoto.image==NULL) && (secondimage.image==NULL)) {
        addedphoto.image=NULL;
        StarImage.alpha=0.0;
        firstornot=@"first";
    }
    
    if ((addedphoto.image==NULL) && (secondimage.image!=NULL)) {
        addedphoto.image=secondimage.image;
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.savedphoto=addedphoto;
        
        secondimage.image=NULL;
        Secondary2Image.hidden=YES;
        
        firstornot=@"second";
    }
    if ((secondimage.image==NULL) && (thirdimage.image!=NULL)) {
        secondimage.image=thirdimage.image;
        thirdimage.image=NULL;
        Secondary3Image.hidden=YES;
        Secondary2Image.hidden=NO;
        
        firstornot=@"third";
    }
    if ((thirdimage.image==NULL) && (fourth.image!=NULL)) {
        thirdimage.image=fourth.image;
        fourth.image=NULL;
        Secondary4Image.hidden=YES;
        Secondary3Image.hidden=NO;
        
        firstornot=@"fourth";
    }
    
    if ([firstornot isEqualToString:@"first"]){
        secondimageB.hidden=YES;
        secondimageBS.hidden=YES;
    }
    
    
    if ([firstornot isEqualToString:@"second"]){
        secondimageB.hidden=NO;
        secondimageBS.hidden=NO;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{secondimageB.center = CGPointMake(241, 113);}completion:^(BOOL finished){}];
        thirdimageB.hidden=YES;
        thirdimageBS.hidden=YES;
        fourthimageB.hidden=YES;
        fourthimageBS.hidden=YES;
    }
    
    if ([firstornot isEqualToString:@"third"]){
        thirdimageB.hidden=NO;
        thirdimageBS.hidden=NO;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{thirdimageB.center = CGPointMake(271, 113);}completion:^(BOOL finished){}];
        fourthimageB.hidden=YES;
        fourthimageBS.hidden=YES;
    }
    if ([firstornot isEqualToString:@"fourth"]){
        fourthimageB.hidden=NO;
        fourthimageBS.hidden=NO;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{fourthimageB.center = CGPointMake(301, 113);}completion:^(BOOL finished){}];
        
    }
}

@end
