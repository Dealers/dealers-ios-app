//
//  MyFeedsViewController.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 2/16/14.
//
//

#import "MyFeedsViewController.h"
#import "AppDelegate.h"
#import "ViewonedealViewController.h"
#import "MoreViewController.h"
#import "ProfileViewController.h"
#import "ExploretableViewController.h"
#import "TableViewController.h"
#import "OnlineViewController.h"
#define OFFSETSHORTCELL 109
#import <mach/mach.h>
#import "OptionalaftergoogleplaceViewController.h"
#import "CheckConnection.h"

@interface MyFeedsViewController ()
@end

@implementation MyFeedsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
}

-(void) removeCellsFromSuperview {
    NSArray *viewsToRemove = [self.scrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

-(void) loadDataFromDB {
    
    self.TITLEMARRAY=nil;
    self.DESCRIPTIONMARRAY =nil;
    self.STOREMARRAY=nil;
    self.PRICEMARRAY=nil;
    self.DISCOUNTMARRAY=nil;
    self.EXPIREMARRAY=nil;
    self.LIKEMARRAY=nil;
    self.COMMENTMARRAY=nil;
    self.CLIENTMARRAY=nil;
    self.PHOTOIDMARRAY=nil;
    self.CATEGORYARRAY=nil;
    self.SIGNARRAY=nil;
    self.DEALIDARRAY=nil;
    self.USERSIDSARRAY=nil;
    _onlineOrLocalArray=nil;
    
    NSArray *types = [[NSArray alloc] initWithObjects:@"TITLE",@"DESCRIPTION",@"STORE",@"PRICE",@"DISCOUNT",@"EXPIRE",@"LIKEBUTTON",@"COMMENT",@"CLIENTID",@"PHOTOID",@"CATEGORY",@"SIGN",@"DEALID",@"USERSIDS",@"onlineorlocal", nil];
    
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:0]];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSArray *DataArray = [DataResult componentsSeparatedByString:@"///"];
    NSArray *reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *TITLEMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:1]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *DESCRIPTIONMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:2]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *STOREMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:3]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *PRICEMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:4]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *DISCOUNTMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:5]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *EXPIREMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:6]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *LIKEMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:7]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *COMMENTMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:8]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *CLIENTMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:9]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *PHOTOIDMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:10]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *CATEGORYARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:11]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *SIGNARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:12]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *DEALIDARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:13]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *USERSIDSARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:14]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *onlineOrLocalArray_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"aftersign";
    
    for (int i=0; i<[[TITLEMARRAY_temp copy] count]; i++) {
        NSString *title=[TITLEMARRAY_temp objectAtIndex:i];
        title = [title stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        title = [title stringByReplacingOccurrencesOfString:@"q8j" withString:@"'"];
        [TITLEMARRAY_temp replaceObjectAtIndex:i withObject:title];
    }
    for (int i=0; i<[[STOREMARRAY_temp copy] count]; i++) {
        NSString *store=[STOREMARRAY_temp objectAtIndex:i];
        store = [store stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        store = [store stringByReplacingOccurrencesOfString:@"q8j" withString:@"'"];
        [STOREMARRAY_temp replaceObjectAtIndex:i withObject:store];
    }
    for (int i=0; i<[[DESCRIPTIONMARRAY_temp copy] count]; i++) {
        NSString *description=[DESCRIPTIONMARRAY_temp objectAtIndex:i];
        description = [description stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        description = [description stringByReplacingOccurrencesOfString:@"q8j" withString:@"'"];
        [DESCRIPTIONMARRAY_temp replaceObjectAtIndex:i withObject:description];
    }
    for (int i=0; i<[[CATEGORYARRAY_temp copy] count]; i++) {
        NSString *category=[CATEGORYARRAY_temp objectAtIndex:i];
        category = [category stringByReplacingOccurrencesOfString:@"q9j" withString:@" & "];
        [CATEGORYARRAY_temp replaceObjectAtIndex:i withObject:category];
    }
    
    for (int i=0; i<[[PRICEMARRAY_temp copy] count]; i++) {
        NSString *price=[PRICEMARRAY_temp objectAtIndex:i];
        int priceint = [price intValue];
        if ((priceint > 10000) && (priceint < 100000))  {
            priceint=priceint/10000;
            price = [NSString stringWithFormat:@"%d",priceint];
            price = [price stringByAppendingString:@"k"];
        }
        if ((priceint > 100000) && (priceint < 1000000))  {
            priceint=priceint/100000;
            price = [NSString stringWithFormat:@"%d",priceint];
            price = [price stringByAppendingString:@"k"];
        }
        if (priceint > 1000000) {
            priceint=priceint/1000000;
            price = [NSString stringWithFormat:@"%d",priceint];
            price = [price stringByAppendingString:@"m"];
        }
        
        [PRICEMARRAY_temp replaceObjectAtIndex:i withObject:price];
    }
    
    
    
    self.TITLEMARRAY = [NSMutableArray arrayWithArray:TITLEMARRAY_temp];
    self.DESCRIPTIONMARRAY = [NSMutableArray arrayWithArray:DESCRIPTIONMARRAY_temp];
    self.STOREMARRAY = [NSMutableArray arrayWithArray:STOREMARRAY_temp];
    self.PRICEMARRAY = [NSMutableArray arrayWithArray:PRICEMARRAY_temp];
    self.DISCOUNTMARRAY = [NSMutableArray arrayWithArray:DISCOUNTMARRAY_temp];
    self.EXPIREMARRAY = [NSMutableArray arrayWithArray:EXPIREMARRAY_temp];
    self.LIKEMARRAY = [NSMutableArray arrayWithArray:LIKEMARRAY_temp];
    self.COMMENTMARRAY = [NSMutableArray arrayWithArray:COMMENTMARRAY_temp];
    self.CLIENTMARRAY = [NSMutableArray arrayWithArray:CLIENTMARRAY_temp];
    self.PHOTOIDMARRAY = [NSMutableArray arrayWithArray:PHOTOIDMARRAY_temp];
    self.CATEGORYARRAY = [NSMutableArray arrayWithArray:CATEGORYARRAY_temp];
    self.SIGNARRAY = [NSMutableArray arrayWithArray:SIGNARRAY_temp];
    self.DEALIDARRAY = [NSMutableArray arrayWithArray:DEALIDARRAY_temp];
    self.USERSIDSARRAY = [NSMutableArray arrayWithArray:USERSIDSARRAY_temp];
    _onlineOrLocalArray = [NSMutableArray arrayWithArray:onlineOrLocalArray_temp];
    
}

-(void) hiddenWhiteCoverView {
    //[UIView animateWithDuration:0.5 animations:^{self.whiteCoverView.alpha=0.0;}];
    [self.LoadingImage stopAnimating];
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

-(NSString *) currencySymbol : (NSString *) sign {
    if ([sign isEqualToString:@"1"]) {
        sign=@"₪";
    }
    if ([sign isEqualToString:@"2"]) {
        sign=@"$";
    }
    if ([sign isEqualToString:@"3"]) {
        sign=@"£";
    }
    return sign;
}

-(void) createDealsTable {
    
    isUpdatingNow = YES;
    for (int i=cellNumberInScrollView; ((i<10+cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
        NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
        
        if ([num isEqualToString:@"0"]) {
            isShortCell = YES;
        } else isShortCell = NO;
        
        UIImageView *imageview;
        if (isShortCell) {
            imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal background & Shadow.png"]];
        } else imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
        
        [imageview setFrame:CGRectMake(2.5, 4+(GAP), 315, 199-(OFFSETSHORTCELL*isShortCell))];
		[[self scrollView] addSubview:imageview];
        
        UIImageView *imageview4;
        if ([[_onlineOrLocalArray objectAtIndex:i] isEqualToString:@"local"]) {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_Local icon_Grey.png"]];
            [imageview4 setFrame:CGRectMake(17, 172+(GAP)-(OFFSETSHORTCELL*isShortCell), 12, 15)];
        } else {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_Online icon_Grey.png"]];
            [imageview4 setFrame:CGRectMake(17, 172+(GAP)-(OFFSETSHORTCELL*isShortCell), 15, 14)];
        }
        [[self scrollView] addSubview:imageview4];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(34, 168+(GAP)-(OFFSETSHORTCELL*isShortCell), 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
        label2.text=[self.STOREMARRAY objectAtIndex:i];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:(170/255.0) green:(170/255.0) blue:(175/255.0) alpha:1.0];
        [[self scrollView] addSubview:label2];
        
        if ((![[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&([[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
            label3.text=[self.PRICEMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:[self currencySymbol:[_SIGNARRAY objectAtIndex:i]]];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            label3.textAlignment=NSTextAlignmentRight;
            [[self scrollView] addSubview:label3];
        }
        
        if ((![[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&(![[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(215, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
            label3.text=[self.PRICEMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:[self currencySymbol:[_SIGNARRAY objectAtIndex:i]]];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            label3.textAlignment=NSTextAlignmentRight;
            int priceint = [label3.text intValue];
            if ((priceint>1000)&&(priceint<10000)) {
                label3.frame=CGRectMake(185, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21);
            }
            [label3 sizeToFit];
            [[self scrollView] addSubview:label3];
            
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label4 setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
            label4.text=[self.DISCOUNTMARRAY objectAtIndex:i];
            label4.text = [label4.text stringByAppendingString:@"%"];
            label4.backgroundColor=[UIColor clearColor];
            label4.textColor = [UIColor colorWithRed:(255/255.0) green:(59/255.0) blue:(48/255.0) alpha:1.0];
            [label4 sizeToFit];
            label4.textAlignment=NSTextAlignmentRight;
            [[self scrollView] addSubview:label4];
        }
        
        if (([[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&(![[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
            label3.text=[self.DISCOUNTMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:@"%"];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor redColor];
            [label3 sizeToFit];
            label3.textAlignment=NSTextAlignmentRight;
            [[self scrollView] addSubview:label3];
        }
        
		GAP=CGRectGetMaxY(imageview.frame)-4;
	}
    cellNumberInScrollView+=10;
    [[self scrollView] setContentSize:CGSizeMake(319,GAP)];
    isUpdatingNow = NO;
    [self hiddenWhiteCoverView];
}

-(void) fillTheCellsWithImages {
    isUpdatingNow = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        for (int i=cellsNumbersInFillWithImages; ((i<cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
            NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
            NSString *URLforphoto = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",num];
            
            if (([num isEqualToString:@"0"])||(num==nil)||([num length]==0)) {
                [_PHOTOIDMARRAYCONVERT addObject:@"0"];
            } else{
                _image2=[[UIImage alloc]init];
                _image2 =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLforphoto]]];
                [_PHOTOIDMARRAYCONVERT addObject:_image2];
            }
        }
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            for (int i=cellsNumbersInFillWithImages; ((i<cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
                NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
                if ([num isEqualToString:@"0"]||([num length]==0)) {
                    isShortCell = YES;
                } else isShortCell = NO;
                
                UIImageView *imageview;
                if (isShortCell) {
                    imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal background & Shadow.png"]];
                } else imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
                [imageview setFrame:CGRectMake(2.5, 4+(gap2), 315, 199-(OFFSETSHORTCELL*isShortCell))];
                
                UIImageView *imageview2 = [[UIImageView alloc]init];
                if (isShortCell) {
                } else {
                    imageview2.image=[_PHOTOIDMARRAYCONVERT objectAtIndex:i-1];
                    [imageview2 setFrame:CGRectMake(10, 10+(gap2), 300, 155)];
                    CALayer *mask = [CALayer layer];
                    mask.contents=(id)[[UIImage imageNamed:@"My Feed+View Deal (final)_Deal Pic mask.png"]CGImage];
                    mask.frame = CGRectMake(0, 0, 300, 155);
                    imageview2.layer.mask = mask;
                    imageview2.layer.masksToBounds = YES;
                    imageview2.tag=i;
                    if (!isShortCell) [[self scrollView] addSubview:imageview2];
                }
                UIImageView *imageview3;
                if (isShortCell) {
                    imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal Dark background.png"]];
                    [imageview3 setFrame:CGRectMake(10, 9+(gap2), 300, 47)];
                    
                } else { imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Title & Store shade.png"]];
                    [imageview3 setFrame:CGRectMake(10, 87+(gap2)-(OFFSETSHORTCELL*isShortCell), 300, 78)];
                }
                [[self scrollView] addSubview:imageview3];
                
                UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Likes icon.png"]];
                [imageview5 setFrame:CGRectMake(274, 124+(gap2)-(OFFSETSHORTCELL*isShortCell), 13, 12)];
                [[self scrollView] addSubview:imageview5];
                
                UIImageView *imageview6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Comments icon.png"]];
                [imageview6 setFrame:CGRectMake(274, 143+(gap2)-(OFFSETSHORTCELL*isShortCell), 12, 14)];
                [[self scrollView] addSubview:imageview6];
                
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(18, 119+(gap2)-(OFFSETSHORTCELL*isShortCell), 249, 41)];
                [label setFont:[UIFont fontWithName:@"Avenir-Roman" size:14.0]];
                label.text=[self.TITLEMARRAY objectAtIndex:i];
                label.backgroundColor=[UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.numberOfLines=2;
                [[self scrollView] addSubview:label];
                
                UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(291, 121+(gap2)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label5 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
                label5.text=[self.LIKEMARRAY objectAtIndex:i];
                label5.backgroundColor=[UIColor clearColor];
                label5.textColor = [UIColor whiteColor];
                [label5 sizeToFit];
                [[self scrollView] addSubview:label5];
                
                UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(291, 141+(gap2)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label6 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
                label6.text=[self.COMMENTMARRAY objectAtIndex:i];
                label6.backgroundColor=[UIColor clearColor];
                label6.textColor = [UIColor whiteColor];
                [label6 sizeToFit];
                [[self scrollView] addSubview:label6];
                
                UIButton *selectDealButton=[UIButton buttonWithType:UIButtonTypeCustom];
                [selectDealButton setTitle:@"" forState:UIControlStateNormal];
                selectDealButton.frame=CGRectMake(0, 4+(gap2), 319, 193-(OFFSETSHORTCELL*isShortCell));//193
                selectDealButton.tag=i;
                [selectDealButton addTarget:self action:@selector(selectDealButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
                [[self scrollView] addSubview:selectDealButton];
                gap2=CGRectGetMaxY(imageview.frame)-4;
            }
            cellsNumbersInFillWithImages+=10;
            isUpdatingNow = NO;
            
        });
    });
    
}

-(void) selectDealButtonClicked:(id)sender {
    ViewonedealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    UIButton *button = (UIButton *)sender;
    controller.titleLabelFromMyFeeds = [self.TITLEMARRAY objectAtIndex:(button.tag)];
    controller.storeLabelFromMyFeeds = [self.STOREMARRAY objectAtIndex:(button.tag)];
    controller.categoryLabelFromMyFeeds = [self.CATEGORYARRAY objectAtIndex:(button.tag)];
    controller.priceLabelFromMyFeeds = [self.PRICEMARRAY objectAtIndex:(button.tag)];
    controller.discountLabelFromMyFeeds = [self.DISCOUNTMARRAY objectAtIndex:(button.tag)];
    controller.expireLabelFromMyFeeds = [self.EXPIREMARRAY objectAtIndex:(button.tag)];
    controller.descriptionLabelFromMyFeeds = [self.DESCRIPTIONMARRAY objectAtIndex:(button.tag)];
    controller.likeLabelFromMyFeeds = [self.LIKEMARRAY objectAtIndex:(button.tag)];
    controller.commentLabelFromMyFeeds = [self.COMMENTMARRAY objectAtIndex:(button.tag)];
    controller.signLabelFromMyFeeds = [self.SIGNARRAY objectAtIndex:(button.tag)];
    controller.photoIdLabelFromMyFeeds = [self.PHOTOIDMARRAY objectAtIndex:(button.tag)];
    controller.dealidLabelFromMyFeeds = [self.DEALIDARRAY objectAtIndex:(button.tag)];
    controller.localoronlineLabelFromMyFeeds = [self.onlineOrLocalArray objectAtIndex:(button.tag)];

    if (![[self.PHOTOIDMARRAY objectAtIndex:(button.tag)] isEqualToString:@"0"]) {
    controller.tempImage = [self.PHOTOIDMARRAYCONVERT objectAtIndex:(button.tag-1)];
        controller.isShoetCell = @"no";
    } else controller.isShoetCell = @"yes";

    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Userid=%@&Indicator=%@",app.UserID,@"whatdealstheuserlikes"];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    _dealsUserLikes=DataResult;
    
    NSLog(@"in myfeeds the dealid is: %@ and the deals that user likes is: %@",[self.DEALIDARRAY objectAtIndex:(button.tag)],_dealsUserLikes);
    
    if ([_dealsUserLikes rangeOfString:[self.DEALIDARRAY objectAtIndex:(button.tag)]].location == NSNotFound) {
        controller.likeornotLabelFromMyFeeds=@"no";
        NSLog(@"didnt find");
    } else {
        controller.likeornotLabelFromMyFeeds=@"yes";
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)initializeView {
    [[self scrollView] setBackgroundColor:[UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1.0]];
    isShortCell=NO;
    isUpdatingNow=NO;
    cellNumberInScrollView=1;
    cellsNumbersInFillWithImages=1;
    GAP=0;
    gap2=0;
    myFeedsFirstTime = YES;
    _scrollView.frame=CGRectMake(0, 44, 320, [[UIScreen mainScreen] bounds].size.height-110);
    
}

-(void) allocArrays {
    self.TITLEMARRAY = [[NSMutableArray alloc]init];
    self.DESCRIPTIONMARRAY = [[NSMutableArray alloc]init];
    self.STOREMARRAY = [[NSMutableArray alloc]init];
    self.PRICEMARRAY = [[NSMutableArray alloc]init];
    self.DISCOUNTMARRAY = [[NSMutableArray alloc]init];
    self.EXPIREMARRAY =  [[NSMutableArray alloc]init];
    self.LIKEMARRAY = [[NSMutableArray alloc]init];
    self.COMMENTMARRAY = [[NSMutableArray alloc]init];
    self.CLIENTMARRAY =  [[NSMutableArray alloc]init];
    self.PHOTOIDMARRAY = [[NSMutableArray alloc]init];
    _PHOTOIDMARRAYCONVERT=nil;
    _PHOTOIDMARRAYCONVERT = [[NSMutableArray alloc]init];
    self.CATEGORYARRAY = [[NSMutableArray alloc]init];
    self.SIGNARRAY =  [[NSMutableArray alloc]init];
    self.DEALIDARRAY = [[NSMutableArray alloc]init];
    self.USERSIDSARRAY = [[NSMutableArray alloc]init];
}

-(void) setRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor=[UIColor colorWithRed:150/255.0f green:0/255.0f blue:180/255.0f alpha:1.0];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [[self scrollView] addSubview:refreshControl];
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"refreshing");
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"yes";
    [self viewDidAppear:YES];
    [refreshControl endRefreshing];
}


-(void) didReachFromRegisterOrAddDeal {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([app.AfterAddDeal isEqualToString:@"aftersign"]) {
        app.AfterAddDeal = @"no";
        NSArray *viewsToRemove = [self.scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        [self createDealsTable];
        [self fillTheCellsWithImages];
    }
    
    if ([app.AfterAddDeal isEqualToString:@"yes"]) {
        app.AfterAddDeal = @"no";
        NSArray *viewsToRemove = [self.scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        [self createDealsTable];
        [self fillTheCellsWithImages];
    }
    
    if ([app.AfterAddDeal isEqualToString:@"aftertapbar"]) {
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self deallocPrevViewControllers];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([app.AfterAddDeal isEqualToString:@"yes"]) {
        app.AfterAddDeal = @"no";
        [self startLoadingUploadIcon:_LoadingImage];
        [self initializeView];
        [self allocArrays];
        static NSCache *_cache = nil;
        [_cache removeAllObjects];
        //[self removeCellsFromSuperview];
        CheckConnection *checkconnection = [[CheckConnection alloc]init];
        if ([checkconnection connected]) {
            [self loadDBandUpdateCells];
        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Check Internet Connection" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }

    }
}

-(void) deallocPrevViewControllers {
    if (myFeedsFirstTime) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        id previousController = [viewControllers objectAtIndex:0];
        if ([previousController respondsToSelector:@selector(deallocMemory)])
            [previousController deallocMemory];
        previousController = [viewControllers objectAtIndex:1];
        if ([previousController respondsToSelector:@selector(deallocMemory)])
            [previousController deallocMemory];
        myFeedsFirstTime=NO;
    }
}

-(void) loadDBandUpdateCells {
    [self showWhiteCover];
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        [self loadDataFromDB];
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            [self didReachFromRegisterOrAddDeal];
            [self setRefreshControl];
            [self removeWhiteCover];
        });
    });
}

- (void)viewDidLoad {
    [self tapBarSet];
    [self initializeView];
    [self allocArrays];
    [self startLoadingUploadIcon:_LoadingImage];
    [self removeCellsFromSuperview];
    CheckConnection *checkconnection = [[CheckConnection alloc]init];
    if ([checkconnection connected]){
        [self loadDBandUpdateCells];
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"Check Internet Connection" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    [super viewDidLoad];
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView{
    int scrollOffset = scrollView.contentOffset.y + 300;
    if ((GAP - scrollOffset) < 200) {
        if (!isUpdatingNow) {
            isUpdatingNow = YES;
            [self createDealsTable];
            [self fillTheCellsWithImages];
            
            
        }
    }
}


-(NSString *) convetCurrency: (NSString *) currencyToConvert {
    if ([currencyToConvert isEqualToString:@"1"]) {
        currencyToConvert=@"₪";
    }
    if ([currencyToConvert isEqualToString:@"2"]) {
        currencyToConvert=@"$";
    }
    if ([currencyToConvert isEqualToString:@"3"]) {
        currencyToConvert=@"£";
    }
	return currencyToConvert;
}


//////////////////////
//// tapbar //////////
//////////////////////


-(void) func {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"foursquare";
    app.onlineOrLocal=@"local";
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) func2 {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"online";
    app.onlineOrLocal=@"online";
    OnlineViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineView"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) goToOnline {
    [self hideLocalOrOnlineView];
    [self performSelector:@selector(func2) withObject:nil afterDelay:0.5];
}

-(void) goToAddDeal {
    [self hideLocalOrOnlineView];
    [self performSelector:@selector(func) withObject:nil afterDelay:0.1];
    
}

-(void) tapBarSet {
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Tab Bar@2X.png"]];
    [imageview setFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height)-69, ([[UIScreen mainScreen] bounds].size.width), 50)];
    [[self view] addSubview:imageview];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Explore button@2X.png"]];
    [imageview2 setFrame:CGRectMake(74, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview2];
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_More button@2X.png"]];
    [imageview3 setFrame:CGRectMake(276, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview3];
    
    UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_My Feed button(selected)@2X.png"]];
    [imageview4 setFrame:CGRectMake(19, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview4];
    
    UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Profile button@2X.png"]];
    [imageview5 setFrame:CGRectMake(218, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview5];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(56, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label.text=@"Explore";
    label.backgroundColor=[UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(258, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label2 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label2.text=@"More";
    label2.backgroundColor=[UIColor clearColor];
    label2.textColor = [UIColor lightGrayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label2];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(1, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label3 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label3.text=@"My Feed";
    label3.backgroundColor=[UIColor clearColor];
    label3.textColor = [UIColor colorWithRed:150/255.0 green:0/255.0 blue:180/255.0 alpha:1.0];
    label3.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label3];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(200, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label4 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label4.text=@"Profile";
    label4.backgroundColor=[UIColor clearColor];
    label4.textColor = [UIColor lightGrayColor];
    label4.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label4];
    
    
    UIButton *selectDealButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton setImage:[UIImage imageNamed:@"My Feed+View Deal_Add Deal button@2X.png"] forState:UIControlStateNormal];
    selectDealButton.frame=CGRectMake(129, ([[UIScreen mainScreen] bounds].size.height)-75,62,56);
    [selectDealButton addTarget:self action:@selector(showLocalOrOnlineView:) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton.tag=120;
    [[self view] addSubview:selectDealButton];
    
    UIButton *selectDealButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton2 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton2.frame=CGRectMake(10, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton2 addTarget:self action:@selector(myFeedClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton2];
    
    UIButton *selectDealButton3=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton3 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton3.frame=CGRectMake(65, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton3 addTarget:self action:@selector(exploreClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton3];
    
    UIButton *selectDealButton4=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton4 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton4.frame=CGRectMake(209, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton4 addTarget:self action:@selector(profileClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton4];
    
    UIButton *selectDealButton5=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton5 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton5.frame=CGRectMake(267, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton5 addTarget:self action:@selector(moreClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton5];
    
    
    //////////////////////
    //// blue buttons ////
    //////////////////////
    
    UIButton *selectDealButton6=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton6 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton6.frame=CGRectMake(0, 0,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-68));
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height-44);
    selectDealButton6.tag=100;
    [selectDealButton6 setBackgroundColor:[UIColor whiteColor]];
    [selectDealButton6 addTarget:self action:@selector(hideLocalOrOnlineView) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton6.alpha=0.0;
    [[self view] addSubview:selectDealButton6];
    
    UIButton *selectDealButton9=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton9 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton9.frame=CGRectMake(0, 0,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-68));
    selectDealButton9.tag=110;
    [selectDealButton9 setBackgroundColor:[UIColor whiteColor]];
    selectDealButton9.alpha=0.0;
    [[self view] addSubview:selectDealButton9];
    
    UIButton *selectDealButton7=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton7 setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton7 setImage:[UIImage imageNamed:@"Add Deal (Final)_Local button.png"] forState:UIControlStateNormal];
    selectDealButton7.frame=CGRectMake(45, ([[UIScreen mainScreen] bounds].size.height)-210,100,100);
    selectDealButton7.tag=101;
    [selectDealButton7 addTarget:self action:@selector(goToAddDeal) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton7.alpha=0.0;
    [[self view] addSubview:selectDealButton7];
    
    UIButton *selectDealButton8=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton8 setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton8 setImage:[UIImage imageNamed:@"Add Deal (Final)_Online button.png"] forState:UIControlStateNormal];
    selectDealButton8.frame=CGRectMake(175, ([[UIScreen mainScreen] bounds].size.height)-210,100,100);
    selectDealButton8.tag=102;
    [selectDealButton8 addTarget:self action:@selector(goToOnline) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton8.alpha=0.0;
    [[self view] addSubview:selectDealButton8];
    
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(45, ([[UIScreen mainScreen] bounds].size.height)-103, 100, 16)];
    [label5 setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
    label5.text=@"Local Store";
    label5.backgroundColor=[UIColor clearColor];
    label5.textColor = [UIColor colorWithRed:0/255 green:122/255 blue:255/255 alpha:1.0];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.tag=103;
    label5.alpha=0.0;
    [[self view] addSubview:label5];
    
    UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(175, ([[UIScreen mainScreen] bounds].size.height)-103, 100, 16)];
    [label6 setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
    label6.text=@"The Web";
    label6.backgroundColor=[UIColor clearColor];
    label6.textColor = [UIColor colorWithRed:0/255 green:122/255 blue:255/255 alpha:1.0];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.tag=104;
    label6.alpha=0.0;
    [[self view] addSubview:label6];
    
    UILabel *label7=[[UILabel alloc]initWithFrame:CGRectMake(100, ([[UIScreen mainScreen] bounds].size.height)-236, 320, 16)];
    [label7 setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
    label7.text=@"Add deal from?";
    label7.backgroundColor=[UIColor clearColor];
    label7.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.tag=105;
    label7.alpha=0.0;
    [[self view] addSubview:label7];

}

-(void) myFeedClicked:(id)sender {
}

-(void) exploreClicked:(id)sender {
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) moreClicked:(id)sender {
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) profileClicked:(id)sender {
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) hideLocalOrOnlineView {
    NSLog(@"remove cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    
    [UIView animateWithDuration:0.5 animations:^{button1.alpha=0.0;
        button2.alpha=0.0;
        button3.alpha=0.0;
        label1.alpha=0.0;
        label2.alpha=0.0;
    }];
    
}

-(void) showLocalOrOnlineView:(id)sender {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];

    [UIView animateWithDuration:0.5 animations:^{button1.alpha=0.8;
        button2.alpha=1.0;
        button3.alpha=1.0;
        label1.alpha=1.0;
        label2.alpha=1.0;
    }];

}

-(void) showWhiteCover {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:120];
    [self.view bringSubviewToFront:button1];
    [self.view bringSubviewToFront:button2];
    [self.view bringSubviewToFront:_LoadingImage];
    button1.alpha=0.8;
}

-(void) removeWhiteCover {
    NSLog(@"remove white cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    button1.alpha=0.0;
}


@end

