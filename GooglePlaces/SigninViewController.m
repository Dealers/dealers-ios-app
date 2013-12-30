//
//  SigninViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "SigninViewController.h"
#import "ViewalldealsViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Functions.h"
@interface SigninViewController ()

@end

@implementation SigninViewController

@synthesize EmailText;
@synthesize PasswordText;
@synthesize Signinbutton,ReturnButton,ReturnButtonFull,LoadingImage;

-(void) BackgroundMethod {
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
    [self performSelectorOnMainThread:@selector(MainMethod) withObject:nil waitUntilDone:NO];
}

-(void) MainMethod {
    ViewalldealsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myfeeds"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void) initialize {
    ReturnButtonFull.alpha=0.0;
    EmailText.text=[[NSUserDefaults standardUserDefaults] stringForKey:@"Email"];
    PasswordText.text=[[NSUserDefaults standardUserDefaults] stringForKey:@"Password"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.EmailText setDelegate:self];
    [self.EmailText setReturnKeyType:UIReturnKeyDone];
    [self.EmailText addTarget:self action:@selector(EmailText) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.PasswordText setDelegate:self];
    [self.PasswordText setReturnKeyType:UIReturnKeyDone];
    [self.PasswordText addTarget:self action:@selector(PasswordText) forControlEvents:UIControlEventEditingDidEndOnExit];
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

-(NSString*)CheckIfUserExist {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getuserphp.php?var1=%@&var2=%@",PasswordText.text,EmailText.text];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSArray *dataarray = [DataResult componentsSeparatedByString:@" "];
    DataResult = [dataarray objectAtIndex:0];
    if ([dataarray count]>1) {
        app.UserID = [dataarray objectAtIndex:1];;
    }
    return DataResult;
}

-(void) StartLoading {
    [UIView animateWithDuration:0.2 animations:^{Signinbutton.alpha=0.0; Signinbutton.transform =CGAffineTransformMakeScale(1,1);
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

- (IBAction)SinginButton:(id)sender {

    NSString *DataResult = [self CheckIfUserExist];

    if (([EmailText.text isEqual:@""]) || ([EmailText.text isEqual:@"Email"])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter Email" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else if (([PasswordText.text isEqual:@"Password"]) || ([PasswordText.text isEqual:@""])) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"You must enter Password" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
    } else if ([DataResult isEqualToString:@"Pass"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Your Password is Incorrect" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else if ([DataResult isEqualToString:@"ok"]) {
        [[NSUserDefaults standardUserDefaults] setObject:EmailText.text forKey:@"Email"];
        [[NSUserDefaults standardUserDefaults] setObject:PasswordText.text forKey:@"Password"];
        [EmailText resignFirstResponder];
        [PasswordText resignFirstResponder];
        [self StartLoading];
        [self performSelectorInBackground:@selector(BackgroundMethod) withObject:nil];
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Your Email is Incorrect" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [EmailText resignFirstResponder];
    [PasswordText resignFirstResponder];
}

- (IBAction)ReturnButtonAction:(id)sender {
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
