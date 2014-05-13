//
//  ProfileViewController.m
//  Dealers
//
//  Created by itzik berrebi on 11/6/13.
//
//

#import "ProfileViewController.h"
#import "ViewonedealViewController.h"
#import "MoreViewController.h"
#import "ExploretableViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"
#import "OnlineViewController.h"

#define OFFSETSHORTCELL 109

@interface ProfileViewController ()

@end

@implementation ProfileViewController

-(void) startLoadingUploadImage {
    _loadingImage.animationImages = [NSArray arrayWithObjects:
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
    _loadingImage.animationDuration = 0.3;
    [_loadingImage startAnimating];
    [UIView animateWithDuration:0.2 animations:^{_loadingImage.alpha=1.0; _loadingImage.transform =CGAffineTransformMakeScale(0,0);
        _loadingImage.transform =CGAffineTransformMakeScale(1,1);}];
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


-(void) loadDataFromDB {
    
    NSMutableArray *TITLEMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *DESCRIPTIONMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *STOREMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *PRICEMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *DISCOUNTMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *EXPIREMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *LIKEMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *COMMENTMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *CLIENTMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *PHOTOIDMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *CATEGORYARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *SIGNARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *DEALIDARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *uploadDateArray_temp = [[NSMutableArray alloc] init];
    NSMutableArray *onlineOrLocalArray_temp = [[NSMutableArray alloc] init];
    
    
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=whatdealstheuseruploaded&Userid=%@",_dealerId];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSArray *dataArray = [DataResult componentsSeparatedByString:@"^"];
    NSLog(@"DATAARRAY=%@",dataArray);
    
    for (int i=0; i+14<([[dataArray copy]count])-1; i=i+15) {
        [TITLEMARRAY_temp addObject:[dataArray objectAtIndex:i]];
        [DESCRIPTIONMARRAY_temp addObject:[dataArray objectAtIndex:i+1]];
        [STOREMARRAY_temp addObject:[dataArray objectAtIndex:i+2]];
        [PRICEMARRAY_temp addObject:[dataArray objectAtIndex:i+3]];
        [DISCOUNTMARRAY_temp addObject:[dataArray objectAtIndex:i+4]];
        [EXPIREMARRAY_temp addObject:[dataArray objectAtIndex:i+5]];
        [LIKEMARRAY_temp addObject:[dataArray objectAtIndex:i+6]];
        [COMMENTMARRAY_temp addObject:[dataArray objectAtIndex:i+7]];
        [PHOTOIDMARRAY_temp addObject:[dataArray objectAtIndex:i+8]];
        [CATEGORYARRAY_temp addObject:[dataArray objectAtIndex:i+9]];
        [CLIENTMARRAY_temp addObject:[dataArray objectAtIndex:i+10]];
        [DEALIDARRAY_temp addObject:[dataArray objectAtIndex:i+11]];
        [SIGNARRAY_temp addObject:[dataArray objectAtIndex:i+12]];
        [uploadDateArray_temp addObject:[dataArray objectAtIndex:i+13]];
        [onlineOrLocalArray_temp addObject:[dataArray objectAtIndex:i+14]];
        
    }
    
    for (int i=0; i<[[TITLEMARRAY_temp copy] count]; i++) {
        NSString *title=[TITLEMARRAY_temp objectAtIndex:i];
        NSString *store=[STOREMARRAY_temp objectAtIndex:i];
        NSString *description=[DESCRIPTIONMARRAY_temp objectAtIndex:i];
        NSString *category=[CATEGORYARRAY_temp objectAtIndex:i];
        category = [category stringByReplacingOccurrencesOfString:@"q9j" withString:@" & "];
        title = [title stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        store = [store stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        description = [description stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        [TITLEMARRAY_temp replaceObjectAtIndex:i withObject:title];
        [STOREMARRAY_temp replaceObjectAtIndex:i withObject:store];
        [CATEGORYARRAY_temp replaceObjectAtIndex:i withObject:category];
        [DESCRIPTIONMARRAY_temp replaceObjectAtIndex:i withObject:description];
    }
    for (int i=0; i<[[PRICEMARRAY_temp copy] count]; i++) {
        NSString *price=[PRICEMARRAY_temp objectAtIndex:i];
        int priceint = [price intValue];
        if ((priceint > 1000) && (priceint < 10000))  {
            priceint=priceint/1000;
            price = [NSString stringWithFormat:@"%d",priceint];
            price = [price stringByAppendingString:@"k"];
        }
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
        [PRICEMARRAY_temp replaceObjectAtIndex:i withObject:price];
    }
    
    
    _TITLEMARRAY = [NSMutableArray arrayWithArray:TITLEMARRAY_temp];
    _DESCRIPTIONMARRAY = [NSMutableArray arrayWithArray:DESCRIPTIONMARRAY_temp];
    _STOREMARRAY = [NSMutableArray arrayWithArray:STOREMARRAY_temp];
    _PRICEMARRAY = [NSMutableArray arrayWithArray:PRICEMARRAY_temp];
    _DISCOUNTMARRAY = [NSMutableArray arrayWithArray:DISCOUNTMARRAY_temp];
    _EXPIREMARRAY = [NSMutableArray arrayWithArray:EXPIREMARRAY_temp];
    _LIKEMARRAY = [NSMutableArray arrayWithArray:LIKEMARRAY_temp];
    _COMMENTMARRAY = [NSMutableArray arrayWithArray:COMMENTMARRAY_temp];
    _CLIENTMARRAY = [NSMutableArray arrayWithArray:CLIENTMARRAY_temp];
    _PHOTOIDMARRAY = [NSMutableArray arrayWithArray:PHOTOIDMARRAY_temp];
    _CATEGORYARRAY = [NSMutableArray arrayWithArray:CATEGORYARRAY_temp];
    _SIGNARRAY = [NSMutableArray arrayWithArray:SIGNARRAY_temp];
    _DEALIDARRAY = [NSMutableArray arrayWithArray:DEALIDARRAY_temp];
    _uploadDateArray = [NSMutableArray arrayWithArray:uploadDateArray_temp];
    _onlineOrLocalArray = [NSMutableArray arrayWithArray:uploadDateArray_temp];
    
    /////////////////
    //for likesview
    /////////////////
    
    NSMutableArray *TITLEMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *DESCRIPTIONMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *STOREMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *PRICEMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *DISCOUNTMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *EXPIREMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *LIKEMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *COMMENTMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *CLIENTMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *PHOTOIDMARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *CATEGORYARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *SIGNARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *DEALIDARRAY_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *uploadDateArray_tempForLikesView = [[NSMutableArray alloc] init];
    NSMutableArray *onlineOrLocalArray_tempForLikesView = [[NSMutableArray alloc] init];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=bringdealstheuserlikes&Userid=%@",_dealerId];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSArray *dataArray2 = [DataResult componentsSeparatedByString:@"^"];
    NSLog(@"array=%d",[dataArray2 count]);
    for (int i=0; i+14<([[dataArray2 copy]count])-1; i=i+15) {
        [TITLEMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i]];
        [DESCRIPTIONMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+1]];
        [STOREMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+2]];
        [PRICEMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+3]];
        [DISCOUNTMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+4]];
        [EXPIREMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+5]];
        [LIKEMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+6]];
        [COMMENTMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+7]];
        [PHOTOIDMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+8]];
        [CATEGORYARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+9]];
        [CLIENTMARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+10]];
        [DEALIDARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+11]];
        [SIGNARRAY_tempForLikesView addObject:[dataArray2 objectAtIndex:i+12]];
        [uploadDateArray_tempForLikesView addObject:[dataArray2 objectAtIndex:i+13]];
        [onlineOrLocalArray_tempForLikesView addObject:[dataArray2 objectAtIndex:i+14]];
        
    }
    
    for (int i=0; i<[[TITLEMARRAY_tempForLikesView copy] count]; i++) {
        NSString *title=[TITLEMARRAY_tempForLikesView objectAtIndex:i];
        NSString *store=[STOREMARRAY_tempForLikesView objectAtIndex:i];
        NSString *description=[DESCRIPTIONMARRAY_tempForLikesView objectAtIndex:i];
        NSString *category=[CATEGORYARRAY_tempForLikesView objectAtIndex:i];
        category = [category stringByReplacingOccurrencesOfString:@"q9j" withString:@" & "];
        title = [title stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        store = [store stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        description = [description stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        [TITLEMARRAY_tempForLikesView replaceObjectAtIndex:i withObject:title];
        [STOREMARRAY_tempForLikesView replaceObjectAtIndex:i withObject:store];
        [CATEGORYARRAY_tempForLikesView replaceObjectAtIndex:i withObject:category];
        [DESCRIPTIONMARRAY_tempForLikesView replaceObjectAtIndex:i withObject:description];
    }
    for (int i=0; i<[[PRICEMARRAY_tempForLikesView copy] count]; i++) {
        NSString *price=[PRICEMARRAY_tempForLikesView objectAtIndex:i];
        int priceint = [price intValue];
        if ((priceint > 1000) && (priceint < 10000))  {
            priceint=priceint/1000;
            price = [NSString stringWithFormat:@"%d",priceint];
            price = [price stringByAppendingString:@"k"];
        }
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
        [PRICEMARRAY_tempForLikesView replaceObjectAtIndex:i withObject:price];
    }
    
    _titleArrayForLikesView = [NSMutableArray arrayWithArray:TITLEMARRAY_tempForLikesView];
    _descriptionArrayForLikesView = [NSMutableArray arrayWithArray:DESCRIPTIONMARRAY_tempForLikesView];
    _storeArrayForLikesView = [NSMutableArray arrayWithArray:STOREMARRAY_tempForLikesView];
    _priceArrayForLikesView = [NSMutableArray arrayWithArray:PRICEMARRAY_tempForLikesView];
    _discountArrayForLikesView = [NSMutableArray arrayWithArray:DISCOUNTMARRAY_tempForLikesView];
    _expireArrayForLikesView = [NSMutableArray arrayWithArray:EXPIREMARRAY_tempForLikesView];
    _likesCountArrayForLikesView = [NSMutableArray arrayWithArray:LIKEMARRAY_tempForLikesView];
    _commentsCountArrayForLikesView = [NSMutableArray arrayWithArray:COMMENTMARRAY_tempForLikesView];
    _clientidArrayForLikesView = [NSMutableArray arrayWithArray:CLIENTMARRAY_tempForLikesView];
    _photoidArrayForLikesView = [NSMutableArray arrayWithArray:PHOTOIDMARRAY_tempForLikesView];
    _categoryArrayForLikesView = [NSMutableArray arrayWithArray:CATEGORYARRAY_tempForLikesView];
    _signArrayForLikesView = [NSMutableArray arrayWithArray:SIGNARRAY_tempForLikesView];
    _dealidArrayForLikesView = [NSMutableArray arrayWithArray:DEALIDARRAY_tempForLikesView];
    _uploadDateArrayForLikesView = [NSMutableArray arrayWithArray:uploadDateArray_tempForLikesView];
    _onlineOrLocalArrayForLikesView = [NSMutableArray arrayWithArray:uploadDateArray_tempForLikesView];
    
}

-(void) allocArrays {
    _TITLEMARRAY = [[NSMutableArray alloc]init];
    _DESCRIPTIONMARRAY = [[NSMutableArray alloc]init];
    _STOREMARRAY = [[NSMutableArray alloc]init];
    _PRICEMARRAY = [[NSMutableArray alloc]init];
    _DISCOUNTMARRAY = [[NSMutableArray alloc]init];
    _EXPIREMARRAY =  [[NSMutableArray alloc]init];
    _LIKEMARRAY = [[NSMutableArray alloc]init];
    _COMMENTMARRAY = [[NSMutableArray alloc]init];
    _CLIENTMARRAY =  [[NSMutableArray alloc]init];
    _PHOTOIDMARRAY = [[NSMutableArray alloc]init];
    _CATEGORYARRAY = [[NSMutableArray alloc]init];
    _SIGNARRAY =  [[NSMutableArray alloc]init];
    _DEALIDARRAY = [[NSMutableArray alloc]init];
    _uploadDateArray = [[NSMutableArray alloc]init];
    _onlineOrLocalArray = [[NSMutableArray alloc]init];
    _photoidConvertedArrayForLikesView = [[NSMutableArray alloc]init];
    _PHOTOIDMARRAYCONVERT = [[NSMutableArray alloc]init];
    
    _titleArrayForLikesView = [[NSMutableArray alloc]init];
    _descriptionArrayForLikesView = [[NSMutableArray alloc]init];
    _storeArrayForLikesView = [[NSMutableArray alloc]init];
    _priceArrayForLikesView = [[NSMutableArray alloc]init];
    _discountArrayForLikesView = [[NSMutableArray alloc]init];
    _expireArrayForLikesView =  [[NSMutableArray alloc]init];
    _likesCountArrayForLikesView = [[NSMutableArray alloc]init];
    _commentsCountArrayForLikesView = [[NSMutableArray alloc]init];
    _clientidArrayForLikesView =  [[NSMutableArray alloc]init];
    _photoidArrayForLikesView = [[NSMutableArray alloc]init];
    _categoryArrayForLikesView = [[NSMutableArray alloc]init];
    _signArrayForLikesView =  [[NSMutableArray alloc]init];
    _dealidArrayForLikesView = [[NSMutableArray alloc]init];
    _uploadDateArrayForLikesView = [[NSMutableArray alloc]init];
    _onlineOrLocalArrayForLikesView = [[NSMutableArray alloc]init];
}

-(void) createDealsTable {
    NSLog(@"in createDealsTable");
    
    isUpdatingNow = YES;
    for (int i=cellNumberInScrollView; ((i<10+cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
        
        if ((i>=[_TITLEMARRAY count])||(i>=[_DESCRIPTIONMARRAY count])||(i>=[_STOREMARRAY count])||(i>=[_PRICEMARRAY count])||(i>=[_DISCOUNTMARRAY count])||(i>=[_EXPIREMARRAY count])||(i>=[_CLIENTMARRAY count])||(i>=[_LIKEMARRAY count])||(i>=[_COMMENTMARRAY count])||(i>=[_PHOTOIDMARRAY count])||(i>=[_CATEGORYARRAY count])||(i>=[_SIGNARRAY count])||(i>=[_DEALIDARRAY count])||(i>=[_uploadDateArray count])||(i>=[_onlineOrLocalArray count])) {
            continue;
        }
        NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
        if ([num isEqualToString:@"0"]) {
            isShortCell = YES;
        } else isShortCell = NO;
        
        UIImageView *imageview;
        if (isShortCell) {
            imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal background & Shadow.png"]];
        } else imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
        
        [imageview setFrame:CGRectMake(2.5, 4+(GAP), 315, 199-(OFFSETSHORTCELL*isShortCell))];
		[[self dealsView] addSubview:imageview];
        
        UIImageView *imageview4;
        if ([[_onlineOrLocalArray objectAtIndex:i] isEqualToString:@"local"]) {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_Local icon_Grey.png"]];
            [imageview4 setFrame:CGRectMake(17, 172+(GAP)-(OFFSETSHORTCELL*isShortCell), 12, 15)];
        } else {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_Online icon_Grey.png"]];
            [imageview4 setFrame:CGRectMake(17, 172+(GAP)-(OFFSETSHORTCELL*isShortCell), 13, 13)];
        }
        [[self dealsView] addSubview:imageview4];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(33, 168+(GAP)-(OFFSETSHORTCELL*isShortCell), 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"Avenir-Light" size:13.0]];
        label2.text=[self.STOREMARRAY objectAtIndex:i];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:(170/255.0) green:(170/255.0) blue:(175/255.0) alpha:1.0];
        [[self dealsView] addSubview:label2];
        
        if ((![[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&([[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.PRICEMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:[self currencySymbol:[_SIGNARRAY objectAtIndex:i]]];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self dealsView] addSubview:label3];
        }
        
        if ((![[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&(![[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(215, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.PRICEMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:[self currencySymbol:[_SIGNARRAY objectAtIndex:i]]];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self dealsView] addSubview:label3];
            
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label4 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label4.text=[self.DISCOUNTMARRAY objectAtIndex:i];
            label4.text = [label4.text stringByAppendingString:@"%"];
            label4.backgroundColor=[UIColor clearColor];
            label4.textColor = [UIColor colorWithRed:(255/255.0) green:(59/255.0) blue:(48/255.0) alpha:1.0];
            [label4 sizeToFit];
            [[self dealsView] addSubview:label4];
        }
        
        if (([[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&(![[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.DISCOUNTMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:@"%"];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self dealsView] addSubview:label3];
        }
        
		GAP=CGRectGetMaxY(imageview.frame)-4;
	}
    cellNumberInScrollView+=10;
    self.dealsView.frame = CGRectMake(0, 225, 320, GAP);
    
    
    for (int i=cellNumberInScrollViewForLikeView; ((i<10+cellNumberInScrollViewForLikeView) && (i<[[self.titleArrayForLikesView copy] count])); i++) {
        
        if ((i>=[_titleArrayForLikesView count])||(i>=[_descriptionArrayForLikesView count])||(i>=[_storeArrayForLikesView count])||(i>=[_priceArrayForLikesView count])||(i>=[_discountArrayForLikesView count])||(i>=[_expireArrayForLikesView count])||(i>=[_clientidArrayForLikesView count])||(i>=[_likesCountArrayForLikesView count])||(i>=[_commentsCountArrayForLikesView count])||(i>=[_photoidArrayForLikesView count])||(i>=[_categoryArrayForLikesView count])||(i>=[_signArrayForLikesView count])||(i>=[_dealidArrayForLikesView count])||(i>=[_uploadDateArrayForLikesView count])||(i>=[_onlineOrLocalArrayForLikesView count])) {
            NSLog(@"sorrrrrrrry");
            continue;
        }
        
        NSString *num=[self.photoidArrayForLikesView objectAtIndex:i];
        
        if ([num isEqualToString:@"0"]) {
            isShortCell = YES;
        } else isShortCell = NO;
        
        UIImageView *imageview;
        if (isShortCell) {
            imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal background & Shadow.png"]];
        } else imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
        
        [imageview setFrame:CGRectMake(2.5, 4+(GAPForLikeView), 315, 199-(OFFSETSHORTCELL*isShortCell))];
		[[self likesView] addSubview:imageview];
        
        UIImageView *imageview4;
        if ([[_onlineOrLocalArrayForLikesView objectAtIndex:i] isEqualToString:@"local"]) {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_Local icon_Grey.png"]];
            [imageview4 setFrame:CGRectMake(17, 172+(GAPForLikeView)-(OFFSETSHORTCELL*isShortCell), 12, 15)];
        } else {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_Online icon_Grey.png"]];
            [imageview4 setFrame:CGRectMake(17, 172+(GAPForLikeView)-(OFFSETSHORTCELL*isShortCell), 13, 13)];
        }
        [[self likesView] addSubview:imageview4];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(33, 168+(GAPForLikeView)-(OFFSETSHORTCELL*isShortCell), 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"Avenir-Light" size:13.0]];
        label2.text=[self.storeArrayForLikesView objectAtIndex:i];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:(170/255.0) green:(170/255.0) blue:(175/255.0) alpha:1.0];
        [[self likesView] addSubview:label2];
        
        if ((![[self.priceArrayForLikesView objectAtIndex:i] isEqualToString:@"0"])&&([[self.discountArrayForLikesView objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAPForLikeView)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.priceArrayForLikesView objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:[self currencySymbol:[_signArrayForLikesView objectAtIndex:i]]];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self likesView] addSubview:label3];
        }
        
        if ((![[self.priceArrayForLikesView objectAtIndex:i] isEqualToString:@"0"])&&(![[self.discountArrayForLikesView objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(215, 169+(GAPForLikeView)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.priceArrayForLikesView objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:[self currencySymbol:[_signArrayForLikesView objectAtIndex:i]]];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self likesView] addSubview:label3];
            
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAPForLikeView)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label4 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label4.text=[self.discountArrayForLikesView objectAtIndex:i];
            label4.text = [label4.text stringByAppendingString:@"%"];
            label4.backgroundColor=[UIColor clearColor];
            label4.textColor = [UIColor colorWithRed:(255/255.0) green:(59/255.0) blue:(48/255.0) alpha:1.0];
            [label4 sizeToFit];
            [[self likesView] addSubview:label4];
        }
        
        if (([[self.priceArrayForLikesView objectAtIndex:i] isEqualToString:@"0"])&&(![[self.discountArrayForLikesView objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAPForLikeView)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.discountArrayForLikesView objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:@"%"];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self likesView] addSubview:label3];
        }
        
		GAPForLikeView=CGRectGetMaxY(imageview.frame)-4;
        NSLog(@"gap=%d",GAPForLikeView);

    }
    NSLog(@"stop");
    self.likesView.frame = CGRectMake(0, 225, 320, GAPForLikeView);
    cellNumberInScrollViewForLikeView+=10;
    
    [[self scrollView] setContentSize:CGSizeMake(319,GAP+350)];
    isUpdatingNow = NO;
    [_loadingImage stopAnimating];
    
}
-(void) fillTheCellsWithImages {
    NSLog(@"in profile filling the images");
    isUpdatingNow = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        for (int i=cellsNumbersInFillWithImages; ((i<cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
            NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
            
            NSString *URLforphoto = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",num];
            
            if (([num isEqualToString:@"0"])||(num==nil)||([num length]==0)) {
                [_PHOTOIDMARRAYCONVERT addObject:@"0"];
                NSLog(@"no image");
            } else{
                NSLog(@"image number %d",[num length]);
                _image2=[[UIImage alloc]init];
                _image2 =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLforphoto]]];
                [_PHOTOIDMARRAYCONVERT addObject:_image2];
            }
        }
        
        for (int i=cellsNumbersInFillWithImagesForLikeView; ((i<cellNumberInScrollViewForLikeView) && (i<[[self.titleArrayForLikesView copy] count])); i++) {
            NSString *num=[self.photoidArrayForLikesView objectAtIndex:i];
            
            NSString *URLforphoto = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",num];
            
            if (([num isEqualToString:@"0"])||(num==nil)||([num length]==0)) {
                [_photoidConvertedArrayForLikesView addObject:@"0"];
                NSLog(@"no image");
            } else{
                NSLog(@"image number %d",[num length]);
                _image2ForLikeView=[[UIImage alloc]init];
                _image2ForLikeView=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLforphoto]]];
                [_photoidConvertedArrayForLikesView addObject:_image2ForLikeView];
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
                    NSLog(@"i=%d",i);
                    imageview2.image=[_PHOTOIDMARRAYCONVERT objectAtIndex:i-1];
                    [imageview2 setFrame:CGRectMake(10, 10+(gap2), 300, 155)];
                    CALayer *mask = [CALayer layer];
                    mask.contents=(id)[[UIImage imageNamed:@"My Feed+View Deal (final)_Deal Pic mask.png"]CGImage];
                    mask.frame = CGRectMake(0, 0, 300, 155);
                    imageview2.layer.mask = mask;
                    imageview2.layer.masksToBounds = YES;
                    imageview2.tag=i;
                    if (!isShortCell) [[self dealsView] addSubview:imageview2];
                }
                UIImageView *imageview3;
                if (isShortCell) {
                    imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal Dark background.png"]];
                    [imageview3 setFrame:CGRectMake(10, 6+(gap2), 300, 48)];
                    
                } else { imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Title & Store shade.png"]];
                    [imageview3 setFrame:CGRectMake(10, 87+(gap2)-(OFFSETSHORTCELL*isShortCell), 300, 78)];
                }
                [[self dealsView] addSubview:imageview3];
                
                UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Likes icon.png"]];
                [imageview5 setFrame:CGRectMake(274, 124+(gap2)-(OFFSETSHORTCELL*isShortCell), 13, 12)];
                [[self dealsView] addSubview:imageview5];
                
                UIImageView *imageview6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Comments icon.png"]];
                [imageview6 setFrame:CGRectMake(274, 143+(gap2)-(OFFSETSHORTCELL*isShortCell), 12, 14)];
                [[self dealsView] addSubview:imageview6];
                
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(18, 119+(gap2)-(OFFSETSHORTCELL*isShortCell), 249, 41)];
                [label setFont:[UIFont fontWithName:@"Avenir-Roman" size:14.0]];
                label.text=[self.TITLEMARRAY objectAtIndex:i];
                label.backgroundColor=[UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.numberOfLines=2;
                [[self dealsView] addSubview:label];
                
                UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(291, 121+(gap2)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label5 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
                label5.text=[self.LIKEMARRAY objectAtIndex:i];
                label5.backgroundColor=[UIColor clearColor];
                label5.textColor = [UIColor whiteColor];
                [label5 sizeToFit];
                [[self dealsView] addSubview:label5];
                
                UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(291, 141+(gap2)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label6 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
                label6.text=[self.COMMENTMARRAY objectAtIndex:i];
                label6.backgroundColor=[UIColor clearColor];
                label6.textColor = [UIColor whiteColor];
                [label6 sizeToFit];
                [[self dealsView] addSubview:label6];
                
                UIButton *selectDealButton=[UIButton buttonWithType:UIButtonTypeCustom];
                [selectDealButton setTitle:@"" forState:UIControlStateNormal];
                selectDealButton.frame=CGRectMake(0, 4+(gap2), 319, 193-(OFFSETSHORTCELL*isShortCell));//193
                selectDealButton.tag=i;
                [selectDealButton addTarget:self action:@selector(selectDealButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
                [[self dealsView] addSubview:selectDealButton];
                gap2=CGRectGetMaxY(imageview.frame)-4;
            }
            cellsNumbersInFillWithImages+=10;
            
            
            for (int i=cellsNumbersInFillWithImagesForLikeView; ((i<cellNumberInScrollViewForLikeView) && (i<[[self.titleArrayForLikesView copy] count])); i++) {
                NSString *num=[self.photoidArrayForLikesView objectAtIndex:i];
                if ([num length]==0) {
                    continue;
                }
                
                if ([num isEqualToString:@"0"]||([num length]==0)) {
                    isShortCell = YES;
                } else isShortCell = NO;
                
                UIImageView *imageview;
                if (isShortCell) {
                    imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal background & Shadow.png"]];
                } else imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
                [imageview setFrame:CGRectMake(2.5, 4+(gap2ForLikeView), 315, 199-(OFFSETSHORTCELL*isShortCell))];
                
                UIImageView *imageview2 = [[UIImageView alloc]init];
                if (isShortCell) {
                } else {
                    imageview2.image=[_photoidConvertedArrayForLikesView objectAtIndex:i-1];
                    [imageview2 setFrame:CGRectMake(10, 10+(gap2ForLikeView), 300, 155)];
                    CALayer *mask = [CALayer layer];
                    mask.contents=(id)[[UIImage imageNamed:@"My Feed+View Deal (final)_Deal Pic mask.png"]CGImage];
                    mask.frame = CGRectMake(0, 0, 300, 155);
                    imageview2.layer.mask = mask;
                    imageview2.layer.masksToBounds = YES;
                    imageview2.tag=i;
                    if (!isShortCell) [[self likesView] addSubview:imageview2];
                }
                UIImageView *imageview3;
                if (isShortCell) {
                    imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal Dark background.png"]];
                    [imageview3 setFrame:CGRectMake(10, 6+(gap2ForLikeView), 300, 48)];
                    
                } else { imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Title & Store shade.png"]];
                    [imageview3 setFrame:CGRectMake(10, 87+(gap2ForLikeView)-(OFFSETSHORTCELL*isShortCell), 300, 78)];
                }
                [[self likesView] addSubview:imageview3];
                
                UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Likes icon.png"]];
                [imageview5 setFrame:CGRectMake(274, 124+(gap2ForLikeView)-(OFFSETSHORTCELL*isShortCell), 13, 12)];
                [[self likesView] addSubview:imageview5];
                
                UIImageView *imageview6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Comments icon.png"]];
                [imageview6 setFrame:CGRectMake(274, 143+(gap2ForLikeView)-(OFFSETSHORTCELL*isShortCell), 12, 14)];
                [[self likesView] addSubview:imageview6];
                
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(18, 119+(gap2ForLikeView)-(OFFSETSHORTCELL*isShortCell), 249, 41)];
                [label setFont:[UIFont fontWithName:@"Avenir-Roman" size:14.0]];
                label.text=[self.titleArrayForLikesView objectAtIndex:i];
                label.backgroundColor=[UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.numberOfLines=2;
                [[self likesView] addSubview:label];
                
                UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(291, 121+(gap2ForLikeView)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label5 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
                label5.text=[self.likesCountArrayForLikesView objectAtIndex:i];
                label5.backgroundColor=[UIColor clearColor];
                label5.textColor = [UIColor whiteColor];
                [label5 sizeToFit];
                [[self likesView] addSubview:label5];
                
                UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(291, 141+(gap2ForLikeView)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label6 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
                label6.text=[self.commentsCountArrayForLikesView objectAtIndex:i];
                label6.backgroundColor=[UIColor clearColor];
                label6.textColor = [UIColor whiteColor];
                [label6 sizeToFit];
                [[self likesView] addSubview:label6];
                
                UIButton *selectDealButton=[UIButton buttonWithType:UIButtonTypeCustom];
                [selectDealButton setTitle:@"" forState:UIControlStateNormal];
                selectDealButton.frame=CGRectMake(0, 4+(gap2ForLikeView), 319, 193-(OFFSETSHORTCELL*isShortCell));//193
                selectDealButton.tag=i;
                [selectDealButton addTarget:self action:@selector(selectDealButtonForLikeViewClicked:) forControlEvents: UIControlEventTouchUpInside];
                [[self likesView] addSubview:selectDealButton];
                gap2ForLikeView=CGRectGetMaxY(imageview.frame)-4;
            }
            cellsNumbersInFillWithImagesForLikeView+=10;
            
            isUpdatingNow = NO;
            [_loadingImage stopAnimating];
            
            //  [self checkIfThereIsNoDeals];
            
        });
    });
    
}

-(void) selectDealButtonForLikeViewClicked:(id)sender {
    ViewonedealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    UIButton *button = (UIButton *)sender;
    controller.titleLabelFromMyFeeds = [self.titleArrayForLikesView objectAtIndex:(button.tag)];
    controller.storeLabelFromMyFeeds = [self.storeArrayForLikesView objectAtIndex:(button.tag)];
    controller.categoryLabelFromMyFeeds = [self.categoryArrayForLikesView objectAtIndex:(button.tag)];
    controller.priceLabelFromMyFeeds = [self.priceArrayForLikesView objectAtIndex:(button.tag)];
    controller.discountLabelFromMyFeeds = [self.discountArrayForLikesView objectAtIndex:(button.tag)];
    controller.expireLabelFromMyFeeds = [self.expireArrayForLikesView objectAtIndex:(button.tag)];
    controller.descriptionLabelFromMyFeeds = [self.descriptionArrayForLikesView objectAtIndex:(button.tag)];
    controller.likeLabelFromMyFeeds = [self.likesCountArrayForLikesView objectAtIndex:(button.tag)];
    controller.commentLabelFromMyFeeds = [self.commentsCountArrayForLikesView objectAtIndex:(button.tag)];
    controller.signLabelFromMyFeeds = [self.signArrayForLikesView objectAtIndex:(button.tag)];
    controller.photoIdLabelFromMyFeeds = [self.photoidArrayForLikesView objectAtIndex:(button.tag)];
    controller.dealidLabelFromMyFeeds = [self.dealidArrayForLikesView objectAtIndex:(button.tag)];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Userid=%@&Indicator=%@",app.UserID,@"whatdealstheuserlikes"];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    _dealsUserLikes=DataResult;
    
    if ([_dealsUserLikes rangeOfString:[self.DEALIDARRAY objectAtIndex:(button.tag)]].location == NSNotFound) {
        controller.likeornotLabelFromMyFeeds=@"no";
        NSLog(@"didnt find");
    } else {
        controller.likeornotLabelFromMyFeeds=@"yes";
    }
    
    [self.navigationController pushViewController:controller animated:YES];
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
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Userid=%@&Indicator=%@",app.UserID,@"whatdealstheuserlikes"];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    _dealsUserLikes=DataResult;
    
    if ([_dealsUserLikes rangeOfString:[self.DEALIDARRAY objectAtIndex:(button.tag)]].location == NSNotFound) {
        controller.likeornotLabelFromMyFeeds=@"no";
        NSLog(@"didnt find");
    } else {
        controller.likeornotLabelFromMyFeeds=@"yes";
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}



-(void) setTopPart {
    _scrollView.frame=CGRectMake(0, 44, 320, [[UIScreen mainScreen] bounds].size.height-110);
    
    if ([_didComeFromLikesTable isEqualToString:@"yes"]){
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            NSString *url = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=%@&Userid=%@",@"bringuserdata",_dealerId];
            NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
            NSArray *array;
            array = [DataResult componentsSeparatedByString:@"."];
            NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[array objectAtIndex:1]];
            URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI on the main thread.
                UIImage *image = [UIImage imageWithData:URLData];
                _dealerProfileImage.image=image;
                CALayer *mask = [CALayer layer];
                mask.contents=(id)[[UIImage imageNamed:@"Registration_Email button.png"]CGImage];
                mask.frame = CGRectMake(0, 0, 80, 80);
                _dealerProfileImage.layer.mask = mask;
                _dealerProfileImage.layer.masksToBounds = YES;
                _dealerName.text=[array objectAtIndex:0];
                
            });
        });

    } else {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIImage *image = app.dealerProfileImage;
    _dealerProfileImage.image=image;
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"Registration_Email button.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 80, 80);
    _dealerProfileImage.layer.mask = mask;
    _dealerProfileImage.layer.masksToBounds = YES;
    _dealerName.text=app.dealerName;
    }
    
    UIImage *image2 = [UIImage imageNamed: @"Profile_Master Dealer.png"];
    _dealerRankImage.image=image2;
    
    _followersCount.text=@"25 Followers";
    
    _followingCount.text=@"40 Following";
    
    
}

-(void) setScrollSize {
    //[_scrollView setContentSize:CGSizeMake(320, 500)];
}

-(void) initialize {
    _deals=@"b";
    _likes=@"a";
    GAP = 0;
    GAP = 0;
    gap2 = 0;
    GAPForLikeView = 0;
    gap2ForLikeView = 0;
    cellNumberInScrollView = 1;
    cellsNumbersInFillWithImages = 1;
    cellNumberInScrollViewForLikeView = 1;
    cellsNumbersInFillWithImagesForLikeView = 1;
    
    _likesView.hidden=YES;
    [self setScrollSize];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"aftertapbar";
    if (_dealerId==NULL) _dealerId=app.UserID;
    
    /*
    if () {
        NSLog(@"prev is like on viewdeal");
        _returnButton.hidden=YES;
        [_myFeedIcon setImage:[UIImage imageNamed:@"My Feed+View Deal_My Feed button@2X.png"]];
        [_profileIcon setImage:[UIImage imageNamed:@"My Feed+View Deal_Profile button (selected)@2X.png"]];
        _myFeedLabel.textColor = [UIColor colorWithRed:(170/255.0) green:(170/255.0) blue:(170/255.0) alpha:1.0];
        _profileLabel.textColor = [UIColor colorWithRed:(150/255.0) green:(0/255.0) blue:(180/255.0) alpha:1.0];
    } else {
        [_myFeedIcon setImage:[UIImage imageNamed:@"My Feed+View Deal_My Feed button(selected)@2X.png"]];
        [_profileIcon setImage:[UIImage imageNamed:@"My Feed+View Deal_Profile button@2X.png"]];
        _profileLabel.textColor = [UIColor colorWithRed:(170/255.0) green:(170/255.0) blue:(170/255.0) alpha:1.0];
        _myFeedLabel.textColor = [UIColor colorWithRed:(150/255.0) green:(0/255.0) blue:(180/255.0) alpha:1.0];
    }*/
    
    _dealsCountLabel.textColor = [UIColor whiteColor];
    _likesCountLabel.textColor = [UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(185/255.0) alpha:1.0];
    
}

-(void)viewDidAppear:(BOOL)animated {
    currentVC=1;
    [self allocArrays];
    [self setTopPart];
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        [self loadDataFromDB];
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            [self createDealsTable];
            [self fillTheCellsWithImages];
        });
    });
    
}
-(void)viewDidDisappear:(BOOL)animated {
    currentVC=0;
}
- (void)viewDidLoad
{
    [self tapBarSet];
    NSLog(@"in profile viewdidload");
    [self startLoadingUploadImage];
    [self initialize];
    
    //[self performSelectorInBackground:@selector(loadDataFromDB) withObject:nil];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    if (currentVC) {
        NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=crash&crashtext='online'"];
        NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
        [self deallocMemory];
        UINavigationController * navigationController = self.navigationController;
        [navigationController popViewControllerAnimated:NO];
    }
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) deallocMemory {
    _TITLEMARRAY=nil;
    _DESCRIPTIONMARRAY =nil;
    _STOREMARRAY=nil;
    _PRICEMARRAY=nil;
    _DISCOUNTMARRAY=nil;
    _EXPIREMARRAY=nil;
    _LIKEMARRAY=nil;
    _COMMENTMARRAY=nil;
    _CLIENTMARRAY=nil;
    _PHOTOIDMARRAY=nil;
    _PHOTOIDMARRAYCONVERT=nil;
    _CATEGORYARRAY=nil;
    _SIGNARRAY=nil;
    _DEALIDARRAY=nil;
    _uploadDateArray=nil;
    
    _titleArrayForLikesView = nil;
    _descriptionArrayForLikesView = nil;
    _storeArrayForLikesView = nil;
    _priceArrayForLikesView = nil;
    _discountArrayForLikesView = nil;
    _expireArrayForLikesView =  nil;
    _likesCountArrayForLikesView = nil;
    _commentsCountArrayForLikesView = nil;
    _clientidArrayForLikesView =  nil;
    _photoidArrayForLikesView = nil;
    _categoryArrayForLikesView = nil;
    _signArrayForLikesView =  nil;
    _dealidArrayForLikesView = nil;
    _uploadDateArrayForLikesView = nil;
    
    _image2=nil;
    _image2ForLikeView=nil;
    _dealerId=nil;
    _dealsUserLikes=nil;
    _didComeFromLikesTable=nil;
    
    static NSCache *_cache = nil;
    [_cache removeAllObjects];
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self.view removeFromSuperview];
    self.view=nil;
}

- (IBAction)myfeedbutton:(id)sender{
    if ([_didComeFromLikesTable isEqualToString:@"yes"]) {
    } else {
        [self deallocMemory];
        NSArray *viewControllers = self.navigationController.viewControllers;
        UINavigationController * navigationController = self.navigationController;
        [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    }
}

- (IBAction)morebutton:(id)sender{
    [self deallocMemory];
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

- (IBAction)explorebutton:(id)sender{
    [self deallocMemory];
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

- (IBAction)dealsViewButtonClicked:(id)sender {
    if ([_deals isEqual:@"b"]){
        [_dealsViewButton setImage:[UIImage imageNamed:@"Profile_Deals List tab (selected).png"] forState:UIControlStateNormal];
        [_likesViewButton setImage:[UIImage imageNamed:@"Profile_Likes List tab.png"] forState:UIControlStateNormal];
        _dealsCountLabel.textColor = [UIColor whiteColor];
        _likesCountLabel.textColor = [UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(185/255.0) alpha:1.0];
        [_dealsCountLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:14.0]];
        [_likesCountLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
        
        _deals=@"a";
        _likes=@"a";
        _likesView.hidden=YES;
        _dealsView.hidden=NO;
        _scrollView.contentSize=CGSizeMake(320,GAP+300);
        
    }
}

- (IBAction)likesViewButtonClicked:(id)sender {
    
    if ([_likes isEqual:@"a"]){
        [_likesViewButton setImage:[UIImage imageNamed:@"Profile_Likes List tab (selected).png"] forState:UIControlStateNormal];
        [_dealsViewButton setImage:[UIImage imageNamed:@"Profile_Deals List tab.png"] forState:UIControlStateNormal];
        [_likesCountLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:14.0]];
        [_dealsCountLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
        _likesCountLabel.textColor = [UIColor whiteColor];
        _dealsCountLabel.textColor = [UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(185/255.0) alpha:1.0];
        _likes=@"b";
        _deals=@"b";
        _dealsView.hidden=YES;
        _likesView.hidden=NO;
        _scrollView.contentSize=CGSizeMake(320,GAPForLikeView+300);
        NSLog(@"like");
    }
}


-(void)OnlineButtonAction:(id)sender{
    
}



- (IBAction)returnButtonClicked:(id)sender {
    _TITLEMARRAY=nil;
    _DESCRIPTIONMARRAY =nil;
    _STOREMARRAY=nil;
    _PRICEMARRAY=nil;
    _DISCOUNTMARRAY=nil;
    _EXPIREMARRAY=nil;
    _LIKEMARRAY=nil;
    _COMMENTMARRAY=nil;
    _CLIENTMARRAY=nil;
    _PHOTOIDMARRAY=nil;
    _PHOTOIDMARRAYCONVERT=nil;
    _CATEGORYARRAY=nil;
    _SIGNARRAY=nil;
    _DEALIDARRAY=nil;
    _uploadDateArray=nil;
    
    _titleArrayForLikesView = nil;
    _descriptionArrayForLikesView = nil;
    _storeArrayForLikesView = nil;
    _priceArrayForLikesView = nil;
    _discountArrayForLikesView = nil;
    _expireArrayForLikesView =  nil;
    _likesCountArrayForLikesView = nil;
    _commentsCountArrayForLikesView = nil;
    _clientidArrayForLikesView =  nil;
    _photoidArrayForLikesView = nil;
    _categoryArrayForLikesView = nil;
    _signArrayForLikesView =  nil;
    _dealidArrayForLikesView = nil;
    _uploadDateArrayForLikesView = nil;
    
    _image2=nil;
    _image2ForLikeView=nil;
    _dealerId=nil;
    _dealsUserLikes=nil;
    _didComeFromLikesTable=nil;
    
    static NSCache *_cache = nil;
    [_cache removeAllObjects];
    NSArray *viewsToRemove = [self.dealsView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    viewsToRemove = [self.likesView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
- (IBAction)profileButtonClicked:(id)sender {
    if ([_didComeFromLikesTable isEqualToString:@"yes"]) {
        [self deallocMemory];
        NSArray *viewControllers = self.navigationController.viewControllers;
        UINavigationController * navigationController = self.navigationController;
        [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
        ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        [navigationController pushViewController:controller animated:NO];
        
    } else {
    }
}


//////////////////////
//// tapbar //////////
//////////////////////


-(void) func {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"foursquare";
    app.onlineOrLocal=@"local";
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) func2 {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"online";
    app.onlineOrLocal=@"online";
    OnlineViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineView"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
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
    
    
    UIImageView *imageview4 = [[UIImageView alloc]init];
    UIImageView *imageview5 = [[UIImageView alloc]init];
    
    imageview4.image=[UIImage imageNamed:@"My Feed+View Deal_My Feed button@2X.png"];
    [imageview4 setFrame:CGRectMake(19, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    
    imageview5.image=[UIImage imageNamed:@"My Feed+View Deal_Profile button (selected)@2X.png"];
    [imageview5 setFrame:CGRectMake(218, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    

    if ([_didComeFromLikesTable isEqualToString:@"yes"]) {
        imageview4.image=[UIImage imageNamed:@"My Feed+View Deal_My Feed button(selected)@2X.png"];
        [imageview4 setFrame:CGRectMake(19, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
        
        imageview5.image=[UIImage imageNamed:@"My Feed+View Deal_Profile button@2X.png"];
        [imageview5 setFrame:CGRectMake(218, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];

    }
    
    [[self view] addSubview:imageview4];
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
    label3.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(200, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label4 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label4.text=@"Profile";
    label4.backgroundColor=[UIColor clearColor];
    label4.textAlignment = NSTextAlignmentCenter;
    
    label4.textColor = [UIColor colorWithRed:150/255.0 green:0/255.0 blue:180/255.0 alpha:1.0];
    label3.textColor = [UIColor lightGrayColor];

    if ([_didComeFromLikesTable isEqualToString:@"yes"]) {
        label3.textColor = [UIColor colorWithRed:150/255.0 green:0/255.0 blue:180/255.0 alpha:1.0];
        label4.textColor = [UIColor lightGrayColor];
    }
    
    [[self view] addSubview:label3];
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
    selectDealButton7.frame=CGRectMake(55, ([[UIScreen mainScreen] bounds].size.height)-210,90,90);
    selectDealButton7.tag=101;
    [selectDealButton7 addTarget:self action:@selector(goToAddDeal) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton7.alpha=0.0;
    [[self view] addSubview:selectDealButton7];
    
    UIButton *selectDealButton8=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton8 setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton8 setImage:[UIImage imageNamed:@"Add Deal (Final)_Online button.png"] forState:UIControlStateNormal];
    selectDealButton8.frame=CGRectMake(175, ([[UIScreen mainScreen] bounds].size.height)-210,90,90);
    selectDealButton8.tag=102;
    [selectDealButton8 addTarget:self action:@selector(goToOnline) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton8.alpha=0.0;
    [[self view] addSubview:selectDealButton8];
    
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(55, ([[UIScreen mainScreen] bounds].size.height)-110, 90, 16)];
    [label5 setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
    label5.text=@"Local Store";
    label5.backgroundColor=[UIColor clearColor];
    label5.textColor = [UIColor colorWithRed:0/255 green:122/255 blue:255/255 alpha:1.0];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.tag=103;
    label5.alpha=0.0;
    [[self view] addSubview:label5];
    
    UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(175, ([[UIScreen mainScreen] bounds].size.height)-110, 90, 16)];
    [label6 setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
    label6.text=@"The Web";
    label6.backgroundColor=[UIColor clearColor];
    label6.textColor = [UIColor colorWithRed:0/255 green:122/255 blue:255/255 alpha:1.0];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.tag=104;
    label6.alpha=0.0;
    [[self view] addSubview:label6];
    
    UILabel *label7=[[UILabel alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height)-251, 320, 22)];
    [label7 setFont:[UIFont fontWithName:@"Avenir-Light" size:22.0]];
    label7.text=@"Add deal from?";
    label7.backgroundColor=[UIColor clearColor];
    label7.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.tag=105;
    label7.alpha=0.0;
    [[self view] addSubview:label7];
    
}

-(void) myFeedClicked:(id)sender {
    [self deallocMemory];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
}

-(void) exploreClicked:(id)sender {
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) moreClicked:(id)sender {
    [self deallocMemory];
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) profileClicked:(id)sender {
}

-(void) hideLocalOrOnlineView {
    NSLog(@"remove cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    UILabel *label3 = (UILabel*)[self.view viewWithTag:105];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        button1.alpha=0.0;
        button2.alpha=0.0;
        button3.alpha=0.0;
        label1.alpha=0.0;
        label2.alpha=0.0;
        label3.alpha=0.0;
    }];
    
}

-(void) showLocalOrOnlineView:(id)sender {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UIButton *button4 = (UIButton*)[self.view viewWithTag:120];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    UILabel *label3 = (UILabel*)[self.view viewWithTag:105];
    [self.view bringSubviewToFront:button4];
    
    [UIView animateWithDuration:0.5 animations:^{
        button1.alpha=0.9;
        button2.alpha=1.0;
        button3.alpha=1.0;
        label1.alpha=1.0;
        label2.alpha=1.0;
        label3.alpha=1.0;
    }];
    
}
-(void) showWhiteCover {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:120];
    [self.view bringSubviewToFront:button1];
    [self.view bringSubviewToFront:button2];
    button1.alpha=0.8;
}

-(void) removeWhiteCover {
    NSLog(@"remove white cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    button1.alpha=0.0;
}


@end
