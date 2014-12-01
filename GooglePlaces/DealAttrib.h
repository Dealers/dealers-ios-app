//
//  DealAttrib.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/13/14.
//
//

#import <Foundation/Foundation.h>

@interface DealAttrib : NSObject

@property NSNumber *dealAttribID;
@property NSNumber *dealID;

@property NSNumber *objectiveRank;
@property NSNumber *dealReliability;

@property NSMutableArray *dealersThatLiked;
@property NSMutableArray *dealersThatShared;

@end
