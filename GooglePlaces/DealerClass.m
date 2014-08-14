//
//  dealerClass.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import "DealerClass.h"

@implementation DealerClass

-(int) dealerEmpty: (NSString *) check{
    if ([check isEqualToString:@"0"]) return 0;
    else return 1;
}
@end
