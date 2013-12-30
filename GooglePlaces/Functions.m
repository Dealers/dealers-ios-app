//
//  Functions.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 12/29/13.
//
//

#import "Functions.h"
#import "AppDelegate.h"
#import "SigninViewController.h"

@implementation Functions

-(NSString*) StringToHex : (NSString*) string {
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                          [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                         length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", @" ", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    
    NSLog(@"%@", hexStr);
    return hexStr;
}

@end
