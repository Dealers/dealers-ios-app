//
//  ResaftergoogleplaceViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/25/13.
//
//

#import "ResaftergoogleplaceViewController.h"
#import "OptionalaftergoogleplaceViewController.h"
#import "AppDelegate.h"

@interface ResaftergoogleplaceViewController ()

@end

@implementation ResaftergoogleplaceViewController
@synthesize titlelabel;
@synthesize storelabel;
@synthesize OKbutton,OKButtonFull;
@synthesize addedphoto;
@synthesize secondimage,secondimageB,thirdimage,thirdimageB,fourth,fourthimageB,addedphotobutton,WhereistheDeal,WhatisheDeal,StoreLabel,TitleLabel,mapView,Scroll,ReturnButtonFull,Returnbutton,secondimageBFull,thirdimageBFull,fourthimageBFull,secondimageBS,thirdimageBS,fourthimageBS,StarImage,Secondary4Image,Secondary3Image,Secondary2Image,ShadowButton,ShadowImage;


- (void)viewDidLoad
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.savedphoto=0;
    app.didaddphoto=@"no";

    secondimageBFull.alpha=0.0;
    thirdimageBFull.alpha=0.0;
    fourthimageBFull.alpha=0.0;
    StarImage.alpha=0.0;
    ReturnButtonFull.alpha=0.0;
    storelabel.text=self.segstore;
    OKButtonFull.alpha=0.0;
    [self.titlelabel setDelegate:self];
    [self.titlelabel setReturnKeyType:UIReturnKeyDone];
    [self.titlelabel addTarget:self action:@selector(titlelabel) forControlEvents:UIControlEventEditingDidEndOnExit];
    [titlelabel addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    
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


    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitlelabel:nil];
    [self setStorelabel:nil];
    [self setAddedphoto:nil];
    [super viewDidUnload];
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
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{secondimageB.center = CGPointMake(241, 247);}completion:^(BOOL finished){}];
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
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{ thirdimageB.center = CGPointMake(271, 247);}completion:^(BOOL finished){}];
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
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{fourthimageB.center = CGPointMake(301, 247);}completion:^(BOOL finished){}];
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
        if ((titlelabel.text.length == 0)){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter an Title and Store" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        } else {
            
            OKButtonFull.alpha=1.0;
            OKbutton.alpha=0.0;
            [UIView animateWithDuration:0.2 animations:^{OKButtonFull.alpha=0.0;}];
            [UIView animateWithDuration:0.2 animations:^{OKbutton.alpha=1.0;}];
            
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            app.globaltitlelabel.text=titlelabel.text;
            app.globalstorelabel.text=storelabel.text;
            
        OptionalaftergoogleplaceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Optional"];
        [self.navigationController pushViewController:controller animated:YES];
}
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [Scroll setScrollEnabled:YES];
    [Scroll setContentSize:((CGSizeMake(320, 300)))];
    [UIView animateWithDuration:0.9 animations:^{Scroll.contentOffset = CGPointMake(0, 0);}];
    
    [titlelabel addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    
    [Scroll setScrollEnabled:YES];
    [Scroll setContentSize:((CGSizeMake(320, 420)))];
    [UIView animateWithDuration:0.4 animations:^{Scroll.contentOffset = CGPointMake(0, 220);}];
    [titlelabel addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    
    return YES;
}

-(void) keyboardWillShow {
}

-(void) keyboardWillHide {
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

-(void) ReturnButtonAction:(id)sender {
    ReturnButtonFull.alpha=1.0;
    Returnbutton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.Returnbutton.alpha=1.0;}];
    [self.navigationController popViewControllerAnimated:YES];
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
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{secondimageB.center = CGPointMake(241, 247);}completion:^(BOOL finished){}];
        thirdimageB.hidden=YES;
        thirdimageBS.hidden=YES;
        fourthimageB.hidden=YES;
        fourthimageBS.hidden=YES;
    }
    
    if ([firstornot isEqualToString:@"third"]){
        thirdimageB.hidden=NO;
        thirdimageBS.hidden=NO;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{thirdimageB.center = CGPointMake(271, 247);}completion:^(BOOL finished){}];
        fourthimageB.hidden=YES;
        fourthimageBS.hidden=YES;
    }
    if ([firstornot isEqualToString:@"fourth"]){
        fourthimageB.hidden=NO;
        fourthimageBS.hidden=NO;
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{fourthimageB.center = CGPointMake(301, 247);}completion:^(BOOL finished){}];

    }
}

@end
