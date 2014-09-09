//
//  Store.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/25/14.
//
//

#import <Foundation/Foundation.h>

@interface Store : NSObject


@property NSString *foursquareID;
@property NSString *name;
@property NSArray *categories;

@property NSNumber *latitude;
@property NSNumber *longitude;
@property NSNumber *distance;

@property NSString *address;
@property NSString *cc;
@property NSString *city;
@property NSString *state;
@property NSString *country;

@property NSString *url;
@property NSString *phone;

@property NSString *verifiedByFoursquare;


@end
