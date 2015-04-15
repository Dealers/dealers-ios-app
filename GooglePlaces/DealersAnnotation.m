//
//  DealersAnnotation.m
//  Dealers
//
//  Created by Gilad Lumbroso on 3/31/15.
//
//

#import "DealersAnnotation.h"

@implementation DealersAnnotation


- initWithPosition:(CLLocationCoordinate2D)coords
{
    if (self = [super init]) {
        _coordinate = coords;
    }
    return self;
}

- (void)setPosition:(CLLocationCoordinate2D)position
{
    _coordinate.latitude = position.latitude;
    _coordinate.longitude = position.longitude;
}

@end
