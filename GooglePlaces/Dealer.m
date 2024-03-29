//
//  dealerClass.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import "Dealer.h"
#import "ScreenCounter.h"

@implementation Dealer

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _badReportsCounter = [NSNumber numberWithInt:0];
        _score = [NSNumber numberWithInt:0];
        _reliability = [NSNumber numberWithInt:100];
        
        _uploadedDeals = [[NSMutableArray alloc]init];
        _likedDeals = [[NSMutableArray alloc]init];
        _sharedDeals = [[NSMutableArray alloc]init];
        _followings = [[NSMutableArray alloc]init];
        _followedBy = [[NSMutableArray alloc]init];
        _totalLikes = [NSNumber numberWithInt:0];
        _totalShares = [NSNumber numberWithInt:0];
        
        _invitationCounter = [NSNumber numberWithInteger:5];
        _screenCounters = [[ScreenCounters alloc] init];
    }
    return self;
}

@end
