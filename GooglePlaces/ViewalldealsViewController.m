//
//  ViewalldealsViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "ViewalldealsViewController.h"
#import "CustomcellforviewdealCell.h"
#import "AppDelegate.h"
#import "BackgroundLayer.h"
#import "ViewonedealViewController.h"
#import "ViewController.h"
#import "MoreViewController.h"
#import "ProfileViewController.h"
#import "ExploretableViewController.h"
#import "TableViewController.h"

@interface ViewalldealsViewController ()
{
    
    NSArray *TitleLabel;
    NSArray *SubtitleLabel;
    NSArray *myImageView;
    NSArray *LikeLabel;
    NSArray *CommentLabel;
    NSArray *Discount;
    
}

@end

@implementation ViewalldealsViewController
@synthesize field;
@synthesize TITLEMARRAY;
@synthesize DESCRIPTIONMARRAY;
@synthesize STOREMARRAY;
@synthesize PRICEMARRAY;
@synthesize DISCOUNTMARRAY;
@synthesize EXPIREMARRAY;
@synthesize LIKEMARRAY;
@synthesize COMMENTMARRAY;
@synthesize CLIENTMARRAY;
@synthesize PHOTOIDMARRAY;
@synthesize CATEGORYARRAY;
@synthesize SIGNARRAY;
@synthesize DEALIDARRAY,USERSIDSARRAY,PHOTOIDMARRAYCONVERT,FAVARRAY,CoveView,LoadingImage,myfeedsImage,exploreImage,profileImage,moreImage,BlueButtonsView,LocalButton,OnlineButton,LocalText,OnlineText,LockTableButton;

@synthesize button2,DealersTitle,myTableView;

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
    PHOTOIDMARRAY = [[NSMutableArray alloc] initWithArray:reversed];
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
    

    NSArray *passagru=[[NSArray alloc]initWithObjects:app.TITLEMARRAY,app.DESCRIPTIONMARRAY,app.STOREMARRAY,app.PRICEMARRAY,app.DISCOUNTMARRAY,app.EXPIREMARRAY,app.LIKEMARRAY,app.COMMENTMARRAY,app.CLIENTMARRAY,app.PHOTOIDMARRAYCONVERT,app.CATEGORYARRAY,app.SIGNARRAY,app.DEALIDARRAY,app.USERSIDSARRAY,app.FAVARRAY, nil];
    [self performSelectorOnMainThread:@selector(MainMethod:) withObject:passagru waitUntilDone:NO];
    
}

-(void) MainMethod:(NSArray*) pass {
    TITLEMARRAY = [pass objectAtIndex:0];
    DESCRIPTIONMARRAY = [pass objectAtIndex:1];
    STOREMARRAY = [pass objectAtIndex:2];
    PRICEMARRAY = [pass objectAtIndex:3];
    DISCOUNTMARRAY = [pass objectAtIndex:4];
    EXPIREMARRAY = [pass objectAtIndex:5];
    LIKEMARRAY = [pass objectAtIndex:6];
    COMMENTMARRAY = [pass objectAtIndex:7];
    CLIENTMARRAY = [pass objectAtIndex:8];
    PHOTOIDMARRAYCONVERT = [pass objectAtIndex:9];
    CATEGORYARRAY = [pass objectAtIndex:10];
    SIGNARRAY = [pass objectAtIndex:11];
    DEALIDARRAY = [pass objectAtIndex:12];
    USERSIDSARRAY = [pass objectAtIndex:13];
    FAVARRAY = [pass objectAtIndex:14];
    [self.myTableView reloadData];

    [UIView animateWithDuration:0.2 animations:^{LoadingImage.alpha=1.0; LoadingImage.transform =CGAffineTransformMakeScale(1,1);
    LoadingImage.transform =CGAffineTransformMakeScale(0,0);}];
    
    [self performSelector:@selector(coverviewhidden) withObject:nil afterDelay:0.5];
    
    
    NSLog(@"pics=%d",[PHOTOIDMARRAYCONVERT count]);
    NSLog(@"tile=%d",[TITLEMARRAY count]);
    
    
}

-(void) coverviewhidden {
    [UIView animateWithDuration:0.5 animations:^{CoveView.alpha=0.0;}];
    [LoadingImage stopAnimating];
}


-(void) Loadingafterdealy {
    LoadingImage.animationImages = [NSArray arrayWithObjects:
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
    LoadingImage.animationDuration = 0.3;
    [LoadingImage startAnimating];
    [UIView animateWithDuration:0.2 animations:^{LoadingImage.alpha=1.0; LoadingImage.transform =CGAffineTransformMakeScale(0,0);
        LoadingImage.transform =CGAffineTransformMakeScale(1,1);}];
    
    
}

-(void) MainMethodAfterSign:(NSArray*) pass {
    
    TITLEMARRAY = [pass objectAtIndex:0];
    DESCRIPTIONMARRAY = [pass objectAtIndex:1];
    STOREMARRAY = [pass objectAtIndex:2];
    PRICEMARRAY = [pass objectAtIndex:3];
    DISCOUNTMARRAY = [pass objectAtIndex:4];
    EXPIREMARRAY = [pass objectAtIndex:5];
    LIKEMARRAY = [pass objectAtIndex:6];
    COMMENTMARRAY = [pass objectAtIndex:7];
    CLIENTMARRAY = [pass objectAtIndex:8];
    PHOTOIDMARRAYCONVERT = [pass objectAtIndex:9];
    CATEGORYARRAY = [pass objectAtIndex:10];
    SIGNARRAY = [pass objectAtIndex:11];
    DEALIDARRAY = [pass objectAtIndex:12];
    USERSIDSARRAY = [pass objectAtIndex:13];
    FAVARRAY = [pass objectAtIndex:14];
    [self.myTableView reloadData];
    
    [self performSelector:@selector(coverviewhidden) withObject:nil afterDelay:0];
}

- (void)viewDidLoad
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    button2.alpha=0.0;
    BlueButtonsView.alpha=0.0;
    LockTableButton.alpha=0.0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:field.text forKey:@"name"];

    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //[self performSelector:@selector(Loadingafterdealy) withObject:nil afterDelay:0.5];

    /*if ([app.TITLEMARRAY count]==0) {
        NSLog(@"MEMORY IS EMPTY");
        [self performSelectorInBackground:@selector(BackgroundMethod) withObject:nil];
    } *//*else  {
        NSLog(@"MEMORY IS NOT EMPTY, USE APP");
        NSArray *passagru=[[NSArray alloc]initWithObjects:app.TITLEMARRAY,app.DESCRIPTIONMARRAY,app.STOREMARRAY,app.PRICEMARRAY,app.DISCOUNTMARRAY,app.EXPIREMARRAY,app.LIKEMARRAY,app.COMMENTMARRAY,app.CLIENTMARRAY,app.PHOTOIDMARRAYCONVERT,app.CATEGORYARRAY,app.SIGNARRAY,app.DEALIDARRAY,app.USERSIDSARRAY,app.FAVARRAY, nil];
        [self performSelector:@selector(MainMethod:) withObject:passagru];
    }*/
    if ([app.AfterAddDeal isEqualToString:@"aftersign"]) {
        app.AfterAddDeal = @"no";
        CoveView.alpha=1.0;
        NSArray *passagru=[[NSArray alloc]initWithObjects:app.TITLEMARRAY,app.DESCRIPTIONMARRAY,app.STOREMARRAY,app.PRICEMARRAY,app.DISCOUNTMARRAY,app.EXPIREMARRAY,app.LIKEMARRAY,app.COMMENTMARRAY,app.CLIENTMARRAY,app.PHOTOIDMARRAYCONVERT,app.CATEGORYARRAY,app.SIGNARRAY,app.DEALIDARRAY,app.USERSIDSARRAY,app.FAVARRAY, nil];
        [self performSelector:@selector(MainMethodAfterSign:) withObject:passagru afterDelay:0.5];
    }

    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor=[UIColor colorWithRed:150/255.0f green:0/255.0f blue:180/255.0f alpha:1.0];
   [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    if ([app.AfterAddDeal isEqualToString:@"yes"]) {
        CoveView.alpha=1.0;
        [self performSelector:@selector(Loadingafterdealy) withObject:nil afterDelay:0.5];
        app.AfterAddDeal = @"no";
        NSLog(@"\nafterdeal");
        [self performSelectorInBackground:@selector(BackgroundMethod) withObject:nil];
    }
    
    if ([app.AfterAddDeal isEqualToString:@"aftertapbar"]) {
        CoveView.alpha=0.0;
        NSArray *passagru=[[NSArray alloc]initWithObjects:app.TITLEMARRAY,app.DESCRIPTIONMARRAY,app.STOREMARRAY,app.PRICEMARRAY,app.DISCOUNTMARRAY,app.EXPIREMARRAY,app.LIKEMARRAY,app.COMMENTMARRAY,app.CLIENTMARRAY,app.PHOTOIDMARRAYCONVERT,app.CATEGORYARRAY,app.SIGNARRAY,app.DEALIDARRAY,app.USERSIDSARRAY,app.FAVARRAY, nil];
        [self performSelector:@selector(MainMethodAfterSign:) withObject:passagru afterDelay:0];
        NSLog(@"\naftertapbar");
    }
    [self.myTableView addSubview:refreshControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView 
{
    NSLog(@"end");

}



- (void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"stop updating");
    [self performSelectorInBackground:@selector(BackgroundMethod) withObject:nil];

    [refreshControl endRefreshing];


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([TITLEMARRAY count ]-1) ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellviewdeal";
    CustomcellforviewdealCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!Cell) {
        Cell = [[CustomcellforviewdealCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Cell.TitleLabel.text = [TITLEMARRAY objectAtIndex:(indexPath.row)+1];
    NSString *price = [[NSString alloc] initWithString:[PRICEMARRAY objectAtIndex:(indexPath.row)+1]];
    NSString *dicount = [[NSString alloc] initWithString:[DISCOUNTMARRAY objectAtIndex:(indexPath.row)+1]];
    NSString *sign=@"0";
    if ([[SIGNARRAY objectAtIndex:(indexPath.row)+1] isEqualToString:@"1"]) {
        sign=@"₪";
    }
    if ([[SIGNARRAY objectAtIndex:(indexPath.row)+1] isEqualToString:@"2"]) {
        sign=@"$";
    }
    if ([[SIGNARRAY objectAtIndex:(indexPath.row)+1] isEqualToString:@"3"]) {
        sign=@"£";
    }

    
    Cell.LikeLabel.text = [LIKEMARRAY objectAtIndex:(indexPath.row)+1];
    if ([Cell.LikeLabel.text isEqualToString:@"0"]) {
        Cell.LikeLabel.hidden=YES;
        Cell.LikeImageView.hidden=YES;
    }

    Cell.CommentLabel.text = [COMMENTMARRAY objectAtIndex:(indexPath.row)+1];
    if ([Cell.CommentLabel.text isEqualToString:@"0"]) {
        Cell.CommentLabel.hidden=YES;
        Cell.CommentImageView.hidden=YES;
    }
    
    NSString *per=@"%";
    if (![dicount isEqualToString:@"0"]) {
        dicount = [dicount stringByAppendingString:per];
        Cell.Discountlabel.text=dicount;
    } else Cell.Discountlabel.text=@"";

    if (![price isEqualToString:@"0"]) {
        price = [price stringByAppendingString:sign];
        Cell.PriceLabel.text=price;
    } else     Cell.PriceLabel.text=@"";

    
    Cell.StoreLabel.text = [STOREMARRAY objectAtIndex:(indexPath.row)+1];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor cyanColor];
    Cell.selectedBackgroundView = bgColorView;
    Cell.textLabel.highlightedTextColor = [UIColor grayColor];
    //Cell.SavetoFavSelected.alpha=0.0;
    //Cell.SavetoFavSelected.hidden=YES;
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    NSString *found =@"no";
    for (int i=0; i<[USERSIDSARRAY count]; i++) {
        if ([[USERSIDSARRAY objectAtIndex:i] isEqualToString:app.UserID]) {
            found = @"yes";
        }
    }

    UIImageView *temp=[PHOTOIDMARRAYCONVERT objectAtIndex:(indexPath.row)+1];
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"My Feed+View Deal (final)_Deal Pic mask.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 300, 155);
    Cell.myImageView.layer.mask = mask;
    Cell.myImageView.layer.masksToBounds = YES;

    Cell.myImageView.image =temp.image;;
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];

    return Cell;
}

-(void)buttonClicked:(id)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:touchPoint];
    UIButton *button = (UIButton *)sender;
    if([[FAVARRAY objectAtIndex:(indexPath.row)+1] isEqualToString:@"0"])
    {
        [button setImage:[UIImage imageNamed:@"My Feed+View Deal_SaveToFav quick-button (selected)@2X"] forState:UIControlStateNormal];
        [FAVARRAY replaceObjectAtIndex:(indexPath.row)+1 withObject:@"1"];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"My Feed+View Deal_SaveToFav quick-button@2X"] forState:UIControlStateNormal];
        [FAVARRAY replaceObjectAtIndex:(indexPath.row)+1 withObject:@"0"];
    }
    [self.myTableView reloadData];
    NSLog(@"%@",FAVARRAY);
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    if ([[segue identifier] isEqualToString:@"showdetail"]) {
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];

        NSString *string=nil;
        NSIndexPath *indexpath = nil;
        
        indexpath = [self.myTableView indexPathForSelectedRow];
        
        string = self.TITLEMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setTitlefromseg:string];
        string = self.STOREMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setStorefromseg:string];
        string = self.DESCRIPTIONMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setDescriptionfromseg:string];
        string = self.PRICEMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setPricefromseg:string];
        string = self.DISCOUNTMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setDiscountfromseg:string];
        string = self.EXPIREMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setExpirefromseg:string];
        string = self.LIKEMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setLikefromseg:string];
        string = self.COMMENTMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setCommentfromseg:string];
        string = self.CLIENTMARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setClientfromseg:string];
        app.imageforviewdeal = self.PHOTOIDMARRAYCONVERT[(indexpath.row)+1];
        //string = self.PHOTOIDMARRAYCONVERT[(indexpath.row)+1];
        //[[segue destinationViewController] setPhotoidfromseg:string];
        string = self.CATEGORYARRAY[(indexpath.row)+1];
        [[segue destinationViewController] setCategoryfromseg:string];

    
    }
    
    
}

- (IBAction)Adddeal:(id)sender {
    LockTableButton.alpha=1.0;
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.myTableView.alpha=0.3;}];

}

-(IBAction)UNLockButtonAction:(id)sender{
    LockTableButton.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{self.myTableView.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=0.0;}];

}

-(void) AddDealFunction {
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:NO completion:nil];
    
    BlueButtonsView.alpha=0.0;
    LockTableButton.alpha=0.0;

    [UIView animateWithDuration:0.5 animations:^{DealersTitle.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.TapBar.center = CGPointMake(160, 436);}];
    [UIView animateWithDuration:0.5 animations:^{self.moreImage.center = CGPointMake(290, 430);}];
    [UIView animateWithDuration:0.5 animations:^{self.MoreButton.center = CGPointMake(290, 436);}];

    [UIView animateWithDuration:0.5 animations:^{self.MoreText.center = CGPointMake(290, 452);}];
    [UIView animateWithDuration:0.5 animations:^{self.profileImage.center = CGPointMake(232, 430);}];
    [UIView animateWithDuration:0.5 animations:^{self.ProfileButton.center = CGPointMake(232, 436);}];

    [UIView animateWithDuration:0.5 animations:^{self.ProfileText.center = CGPointMake(232, 452);}];
    [UIView animateWithDuration:0.5 animations:^{self.AddDealButton.center = CGPointMake(160, 433);}];
    [UIView animateWithDuration:0.5 animations:^{self.ExploreButton.center = CGPointMake(88, 436);}];
    [UIView animateWithDuration:0.5 animations:^{self.exploreImage.center = CGPointMake(88, 430);}];
    [UIView animateWithDuration:0.5 animations:^{self.ExploreText.center = CGPointMake(88, 452);}];
    [UIView animateWithDuration:0.5 animations:^{self.MyFeedButton.center = CGPointMake(33, 436);}];
    [UIView animateWithDuration:0.5 animations:^{self.myfeedsImage.center = CGPointMake(33, 430);}];
    [UIView animateWithDuration:0.5 animations:^{self.MyFeedText.center = CGPointMake(33, 452);}];
    [UIView animateWithDuration:0.5 animations:^{self.myTableView.alpha=1.0;}];

}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
    }
}

- (IBAction)viewdealbutton:(id)sender{
    ViewonedealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    [self.navigationController pushViewController:controller animated:NO];
}
- (IBAction)morebutton:(id)sender{
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)profilebutton:(id)sender{
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self.navigationController pushViewController:controller animated:NO];
    
}
- (IBAction)explorebutton:(id)sender{
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    [self.navigationController pushViewController:controller animated:NO];
    
    
}

-(void)LocalButtonAction:(id)sender{
    
    [UIView animateWithDuration:0.5 animations:^{DealersTitle.alpha=0.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.TapBar.center = CGPointMake(160, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.MoreButton.center = CGPointMake(290, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.MoreText.center = CGPointMake(290, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.moreImage.center = CGPointMake(290, 500);}];
    
    [UIView animateWithDuration:0.5 animations:^{self.ProfileButton.center = CGPointMake(232, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.ProfileText.center = CGPointMake(232, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.profileImage.center = CGPointMake(232, 500);}];
    
    [UIView animateWithDuration:0.5 animations:^{self.AddDealButton.center = CGPointMake(160, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.ExploreButton.center = CGPointMake(88, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.ExploreText.center = CGPointMake(88, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.exploreImage.center = CGPointMake(88, 500);}];
    
    [UIView animateWithDuration:0.5 animations:^{self.MyFeedButton.center = CGPointMake(30, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.MyFeedText.center = CGPointMake(30, 500);}];
    [UIView animateWithDuration:0.5 animations:^{self.myfeedsImage.center = CGPointMake(30, 500);}];
    
    [UIView animateWithDuration:0.5 animations:^{self.myTableView.alpha=0.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.BlueButtonsView.alpha=0.0;}];

    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];
}

-(void)OnlineButtonAction:(id)sender{
    
}

@end
