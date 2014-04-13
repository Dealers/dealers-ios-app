//
//  SigninViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "SigninViewController.h"
#import "AppDelegate.h"
#import "MyFeedsViewController.h"

@interface SigninViewController ()

@end

@implementation SigninViewController

@synthesize EmailText;
@synthesize PasswordText;
@synthesize Signinbutton,ReturnButton,ReturnButtonFull,LoadingImage;

-(void) MainMethod {
    MyFeedsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"feeds"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController pushViewController:controller animated:YES];
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
        NSLog(@"userid=%@",app.UserID);
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
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([app.UserID length]<=1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Can't Login, Please Try Again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } else if (([EmailText.text isEqual:@""]) || ([EmailText.text isEqual:@"Email"])) {
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
        [self performSelector:@selector(MainMethod) withObject:nil afterDelay:2];
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Your Email is Incorrect" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)ReturnButtonAction:(id)sender {
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
-(NSString *)FilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"DealersDB3.sql"];
}

-(void)OpenDB {
    if (sqlite3_open([[self FilePath] UTF8String], &db) != SQLITE_OK)  {
        sqlite3_close(db);
        NSAssert(0, @"DB failed");
    }else{
        NSLog(@"db opened");
        [self DeleteTable];
        [self CreateTable];
    }
}

-(void)InsertToDB: (NSString *) parameter1 withParameter: (NSString *) parameter2 withParameter: (NSString *) parameter3 withParameter: (NSString *) parameter4 withParameter: (NSString *) parameter5 withParameter: (NSString *) parameter6 withParameter: (NSString *) parameter7 withParameter: (NSString *) parameter8 withParameter: (NSString *) parameter9 withParameter: (NSString *) parameter10 withParameter: (NSString *) parameter11 withParameter: (NSString *) parameter12
    {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO DEALS ('TITLE', 'DESCRIPTION', 'STORE', 'DISCOUNT', 'PRICE', 'EXPIRE', 'PHOTOID', 'CATEGORY', 'SIGN', 'CLIENTID', 'LIKES', 'COMMENTS') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",parameter1,parameter2,parameter3,parameter4,parameter5,parameter6,parameter7,parameter8,parameter9,parameter10,parameter11,parameter12];
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"insert failed");
    }else{
        //NSLog(@"Insert to table");
    }
}

-(void) DeleteTable {
    char *err;
    const char *sql = "DELETE FROM DEALS";
    
    if (sqlite3_exec(db, sql, NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"DB failed");
    }else{
        NSLog(@"TABLE DELETED");
    }
}


-(void) CreateTable {
    char *err;
    const char *sql = "CREATE TABLE IF NOT EXISTS DEALS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, DESCRIPTION TEXT, STORE TEXT, DISCOUNT TEXT, PRICE TEXT, EXPIRE TEXT, PHOTOID TEXT, CATEGORY TEXT, SIGN TEXT, CLIENTID TEXT, LIKES TEXT, COMMENTS TEXT)";
    
    if (sqlite3_exec(db, sql, NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"DB failed");
    }else{
        NSLog(@"TABLE CREATED");
    }
}

- (void) LoadFromTable
{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM DEALS"];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *statement;
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
                
                char *field2 = (char *) sqlite3_column_text(statement,1);
                NSString *field2Str = [[NSString alloc] initWithUTF8String: field2];

              //  [resultArray addObject:field1Str];
                [resultArray addObject:field2Str];
            }
        }
    for (int i=0; i<[resultArray count]; i++) {
        NSLog(@"res=%@", [resultArray objectAtIndex:i]);
    }
    NSLog(@"load=%d",[resultArray count]);
}*/

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void) deallocMemory {
    [LoadingImage stopAnimating];
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self.view removeFromSuperview];
    NSLog(@"dealloc signin");
    self.view=nil;
}



@end
