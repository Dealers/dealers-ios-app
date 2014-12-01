//
//  dealerClass.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import "Dealer.h"

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
        
    }
    return self;
}

@end
