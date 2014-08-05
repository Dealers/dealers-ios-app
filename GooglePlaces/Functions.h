//
//  Functions.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 12/29/13.
//
//

#import <Foundation/Foundation.h>
#import "MyFeedsViewController.h"

@interface Functions : NSObject
-(BOOL)CheckIfCategoryExist:(NSString*) string;
-(NSString*)ConnectOldCategoryToNewCategory:(NSString*) string;
-(NSString *) currencySymbol : (NSString *) sign;
-(NSString *) removeUniqueSigns : (NSString *) string;
-(NSString *) priceAdaptation : (NSString *) price;

@end
