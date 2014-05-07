//
//  CheckConnection.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 4/29/14.
//
//

#import "CheckConnection.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation CheckConnection

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
