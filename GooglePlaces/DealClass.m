//
//  DealClass.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/2/14.
//
//

#import "DealClass.h"
#import "Functions.h"

#define offSetShortCell 109
#define imageViewTag -10
#define imageViewBackgroundTag 10
#define titleBackgroundTag 1000
#define loadingIndicatorTag 100000
#define spinningWheelTag 4444

@implementation DealClass
/*
-(id)init {
    self = [super init];
    if (self) {
        _dealID=@"";
        _dealTitle=@"";
        _dealDescription=@"";
        _dealStore=@"";
        _dealPrice=@"";
        _dealDiscount=@"";
        _dealExpireDate=@"";
        _dealLikesCount=@"";
        _dealCommentCount=@"";
        _dealPhotoID1=@"";
        _dealPhotoID2=@"";
        _dealPhotoID3=@"";
        _dealPhotoID4=@"";
        _dealPhotoSum=@"";
        _dealCategory=@"";
        _dealUserID=@"";
        _dealCurrency=@"";
        _dealUploadDate=@"";
        _dealOnlineOrLocal=@"";
        _dealUrlSite=@"";
        _dealStoreAddress=@"";
        _dealStoreLatitude=@"";
        _dealStoreLongitude=@"";
    }
    
    return self;
}
 */

- (void)setDealTitle:(NSString*)title {
    Functions *func = [[Functions alloc]init];
    _dealTitle = [func removeUniqueSigns:title];
}

-(void) setDealDescription:(NSString*)description {
    Functions *func = [[Functions alloc]init];
    _dealDescription = [func removeUniqueSigns:description];
}

-(void) setDealStore:(NSString*)store{
    Functions *func = [[Functions alloc]init];
    _dealStore=[func removeUniqueSigns:store];
}

-(void) setDealPrice:(NSString*)price{
    _dealPrice = price;
    
    /*
    Functions *func = [[Functions alloc]init];
    if ([price intValue] >= 10000) {
        _dealPrice = [func priceAdaptation:price];
    } else _dealPrice = price;
    */
}

-(void) setDealCategory:(NSString*)category{
    Functions *func = [[Functions alloc]init];
    _dealCategory=[func removeUniqueSigns:category];
}

-(void) setDealCurrency:(NSString*)currency{
    Functions *func = [[Functions alloc]init];
    _dealCurrency = [func currencySymbol:currency];
}

-(void) setDealStoreAddress:(NSString*)storeAddress{
    Functions *func = [[Functions alloc]init];
    _dealStoreAddress = [func removeUniqueSigns:storeAddress];
}

-(void)printClass{
    NSLog(@"my class is=%@,%@,%@,%@",self.dealTitle,self.dealStore,self.dealID,self.dealUserID);
}

- (id)copyWithZone:(NSZone *)zone
{
    DealClass *dealCopy = [[DealClass allocWithZone:zone]init];
    
    dealCopy = [dealCopy mutableCopyWithZone:zone];
    
    return dealCopy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    DealClass *dealCopy = [[DealClass allocWithZone:zone]init];
    
    dealCopy.dealID = [self.dealID mutableCopy];
    dealCopy.dealDescription = [self.dealDescription mutableCopy];
    dealCopy.dealTitle = [self.dealTitle mutableCopy];
    dealCopy.dealStore = [self.dealStore mutableCopy];
    dealCopy.dealPrice = [self.dealPrice mutableCopy];
    dealCopy.dealDiscount = [self.dealDiscount mutableCopy];
    dealCopy.dealExpireDate = [self.dealExpireDate mutableCopy];
    dealCopy.dealLikesCount = [self.dealLikesCount mutableCopy];
    dealCopy.dealCommentCount = [self.dealCommentCount mutableCopy];
    dealCopy.dealPhotoID1 = [self.dealPhotoID1 mutableCopy];
    dealCopy.dealPhotoID2 = [self.dealPhotoID2 mutableCopy];
    dealCopy.dealPhotoID3 = [self.dealPhotoID3 mutableCopy];
    dealCopy.dealPhotoID4 = [self.dealPhotoID4 mutableCopy];
    dealCopy.dealPhotoSum = [self.dealPhotoSum mutableCopy];
    dealCopy.dealCategory = [self.dealCategory mutableCopy];
    dealCopy.dealUserID = [self.dealUserID mutableCopy];
    dealCopy.dealCurrency = [self.dealCurrency mutableCopy];
    dealCopy.dealDiscountType = [self.dealDiscountType mutableCopy];
    dealCopy.dealUploadDate = [self.dealUploadDate mutableCopy];
    dealCopy.dealOnlineOrLocal = [self.dealOnlineOrLocal mutableCopy];
    dealCopy.dealUrlSite = [self.dealUrlSite mutableCopy];
    dealCopy.dealStoreAddress = [self.dealStoreAddress mutableCopy];
    dealCopy.dealStoreLatitude = [self.dealStoreLatitude mutableCopy];
    dealCopy.dealStoreLongitude = [self.dealStoreLongitude mutableCopy];
    
    
    return dealCopy;
}

+ (UIView *)createDealsTableIn:(UIViewController *)viewController withDeals:(NSMutableArray *)deals
{
    int gap = 0;
    int numberOfDealsLoadingAtATime = 10;
    BOOL isShortCell;
    UIView *dealsTable = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    DealClass *dealClass = [[DealClass alloc]init];
    
    for (int i = 0; i < numberOfDealsLoadingAtATime && i < [deals count]; i++) {
        dealClass = [deals objectAtIndex:i];
        NSString *imageID = [dealClass dealPhotoID1];
        
        if ([imageID isEqualToString:@"0"]) {
            isShortCell = YES;
        } else isShortCell = NO;
        
        UIImageView *imageview, *imageViewBackground;
        
        if (isShortCell) {
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"No Pic Deal Background"]];
        } else {
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Deal Background"]];
            imageViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Deal Pic Mask"]];
        }
        
        [imageview setFrame:CGRectMake(2.5, 4 + gap, 315, 199 - (offSetShortCell * isShortCell))];
        [imageViewBackground setFrame:CGRectMake(10, 10 + gap, 300, 155)];
        imageViewBackground.tag = (i + 1) * imageViewBackgroundTag;
        [dealsTable addSubview:imageview];
        [dealsTable addSubview:imageViewBackground];
        
        if (!isShortCell) {
            UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            loading.center = imageViewBackground.center;
            loading.tag = (i + 1) * loadingIndicatorTag;
            [loading startAnimating];
            [dealsTable addSubview:loading];
        }
        
        UIImageView *titleBackground;
        
        if (isShortCell) {
            titleBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"No Pic Title Background"]];
            [titleBackground setFrame:CGRectMake(10, 9 + gap, 300, 47)];
        } else {
            titleBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Title Background"]];
            titleBackground.alpha = 0.7;
            [titleBackground setFrame:CGRectMake(10, 87 + gap - (offSetShortCell * isShortCell), 300, 78)];
            titleBackground.tag = (i + 1) * titleBackgroundTag;
        }
        [dealsTable addSubview:titleBackground];
        
        UIImageView *likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Likes icon.png"]];
        [likeIcon setFrame:CGRectMake(274, 124 + gap - (offSetShortCell * isShortCell), 13, 12)];
        [dealsTable addSubview:likeIcon];
        
        UIImageView *commentIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Comments icon.png"]];
        [commentIcon setFrame:CGRectMake(274, 143 + gap - (offSetShortCell * isShortCell), 12, 14)];
        [dealsTable addSubview:commentIcon];
        
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(18, 119 + gap - (offSetShortCell * isShortCell), 249, 41)];
        [title setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
        title.text = [dealClass dealTitle];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.numberOfLines = 2;
        [dealsTable addSubview:title];
        
        UILabel *likes = [[UILabel alloc]initWithFrame:CGRectMake(291, 121 + gap - (offSetShortCell * isShortCell), 21, 21)];
        [likes setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
        likes.text = [dealClass dealLikesCount];
        likes.backgroundColor = [UIColor clearColor];
        likes.textColor = [UIColor whiteColor];
        [likes sizeToFit];
        [dealsTable addSubview:likes];
        
        UILabel *comments = [[UILabel alloc]initWithFrame:CGRectMake(291, 141 + gap - (offSetShortCell * isShortCell), 21, 21)];
        [comments setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
        comments.text = [dealClass dealCommentCount];
        comments.backgroundColor = [UIColor clearColor];
        comments.textColor = [UIColor whiteColor];
        [comments sizeToFit];
        [dealsTable addSubview:comments];
        
        /*
        UIButton *selectDealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectDealButton setTitle:@"" forState:UIControlStateNormal];
        selectDealButton.frame = CGRectMake(0, 4 + gap, 319, 193 - (offSetShortCell * isShortCell));
        selectDealButton.tag = i;
        [selectDealButton addTarget:self action:@selector(selectDealButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [dealsTable addSubview:selectDealButton];
        */
        
        UIImageView *imageview4;
        if ([[dealClass dealOnlineOrLocal] isEqualToString:@"local"]) {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Local Icon"]];
            [imageview4 setFrame:CGRectMake(18, 173 + gap - (offSetShortCell * isShortCell), 11, 14)];
        } else {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Online Icon"]];
            [imageview4 setFrame:CGRectMake(17, 174 + gap - (offSetShortCell * isShortCell), 13, 13)];
        }
        [dealsTable addSubview:imageview4];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(34, 168 + gap - (offSetShortCell * isShortCell), 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
        label2.text = [dealClass dealStore];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        [dealsTable addSubview:label2];
        
        if ((![[dealClass dealPrice] isEqualToString:@"0"]) && ([[dealClass dealDiscount] isEqualToString:@"0"])) {
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(265, 169 + gap - (offSetShortCell * isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text = [dealClass.dealCurrency stringByAppendingString:dealClass.dealPrice];
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            label3.textAlignment = NSTextAlignmentRight;
            [dealsTable addSubview:label3];
        }
        
        if ((![[dealClass dealPrice] isEqualToString:@"0"]) && (![[dealClass dealDiscount] isEqualToString:@"0"])) {
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(265, 169 + gap - (offSetShortCell * isShortCell), 53, 21)];
            [label4 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label4.text = [dealClass dealDiscount];
            label4.text = [label4.text stringByAppendingString:@"%"];
            label4.backgroundColor = [UIColor clearColor];
            label4.textColor = [UIColor colorWithRed:(255/255.0) green:(59/255.0) blue:(48/255.0) alpha:1.0];
            [label4 sizeToFit];
            label4.textAlignment = NSTextAlignmentRight;
            [dealsTable addSubview:label4];
            
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(215, 169 + gap - (offSetShortCell * isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text = [dealClass.dealCurrency stringByAppendingString:dealClass.dealPrice];
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            label3.textAlignment = NSTextAlignmentRight;
            [label3 sizeToFit];
            [dealsTable addSubview:label3];
        }
        
        if (([[dealClass dealPrice] isEqualToString:@"0"]) && (![[dealClass dealDiscount] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169 + gap - (offSetShortCell * isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text = [dealClass dealDiscount];
            label3.text = [label3.text stringByAppendingString:@"%"];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor redColor];
            [label3 sizeToFit];
            label3.textAlignment=NSTextAlignmentRight;
            [dealsTable addSubview:label3];
        }
        
        gap = CGRectGetMaxY(imageview.frame) - 4;
        
    } // End of for loop.
    
    dealsTable.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, gap);
    return dealsTable;
}




@end
