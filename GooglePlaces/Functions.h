//
//  Functions.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 12/29/13.
//
//

#import <Foundation/Foundation.h>
#import "MyFeedsViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface Functions : NSObject
-(BOOL)CheckIfCategoryExist:(NSString*) string;
-(NSString*)ConnectOldCategoryToNewCategory:(NSString*) string;
-(NSString *) currencySymbol : (NSString *) sign;
-(NSString *) removeUniqueSigns : (NSString *) string;
-(NSString *) priceAdaptation : (NSString *) price;
-(BOOL) checkIfUserExist : (NSString *) email;
-(void) dataTOdb : (id<FBGraphUser>)user;
-(BOOL) isFacebookAccount: (NSString *)email;
-(BOOL) dbAsFacebookAccount: (id<FBGraphUser>)user;

@end
