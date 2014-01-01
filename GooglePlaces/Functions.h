//
//  Functions.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 12/29/13.
//
//

#import <Foundation/Foundation.h>

@interface Functions : NSObject
-(NSString*) StringToHex : (NSString*) string;
-(void) funconbackground;
-(BOOL)CheckIfCategoryExist:(NSString*) string;
-(NSString*)ConnectOldCategoryToNewCategory:(NSString*) string;
@end
