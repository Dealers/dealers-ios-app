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
-(UIView *) tapBarSet:(UIView *)view VCname:(NSString*)vc;
@end
