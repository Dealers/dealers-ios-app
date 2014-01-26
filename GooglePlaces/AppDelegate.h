//
//  AppDelegate.h
//  GooglePlaces
//
//  Created by van Lint Jason on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIImageView *savedphoto;
    UIImageView *savedphoto2;
    UIImageView *savedphoto3;
    UIImageView *savedphoto4;


}
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UIImageView *savedphoto;
@property (strong,nonatomic) UIImageView *imageforviewdeal;

@property (strong, nonatomic)  UITextField *globaltitlelabel;
@property (strong, nonatomic)  UITextField *globalstorelabel;
@property (strong, nonatomic)  NSString *photoid;
@property (strong, nonatomic)  NSString *Animate_first;
@property (strong, nonatomic)  NSString *FavButtonDidPress;
@property (strong, nonatomic)  NSString *didaddphoto;
@property (strong, nonatomic)  NSString *UserID;
@property (nonatomic, strong) NSMutableArray *TITLEMARRAY;
@property (nonatomic, strong) NSMutableArray *DESCRIPTIONMARRAY;
@property (nonatomic, strong) NSMutableArray *STOREMARRAY;
@property (nonatomic, strong) NSMutableArray *PRICEMARRAY;
@property (nonatomic, strong) NSMutableArray *DISCOUNTMARRAY;
@property (nonatomic, strong) NSMutableArray *EXPIREMARRAY;
@property (nonatomic, strong) NSMutableArray *LIKEMARRAY;
@property (nonatomic, strong) NSMutableArray *COMMENTMARRAY;
@property (nonatomic, strong) NSMutableArray *CLIENTMARRAY;
@property (nonatomic, strong) NSMutableArray *PHOTOIDMARRAY;
@property (nonatomic, strong) NSMutableArray *PHOTOIDMARRAYCONVERT;
@property (nonatomic, strong) NSMutableArray *FAVARRAY;
@property (nonatomic, strong) NSMutableArray *CATEGORYARRAY;
@property (nonatomic, strong) NSMutableArray *SIGNARRAY;
@property (nonatomic, strong) NSMutableArray *DEALIDARRAY;
@property (nonatomic, strong) NSMutableArray *USERSIDSARRAY;
@property (strong, nonatomic)  NSString *AfterAddDeal;
@property (strong, nonatomic)  NSString *CategoryName;



@end
