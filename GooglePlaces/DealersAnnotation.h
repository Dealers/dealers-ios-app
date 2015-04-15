//
//  DealersAnnotation.h
//  Dealers
//
//  Created by Gilad Lumbroso on 3/31/15.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DealersAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- initWithPosition:(CLLocationCoordinate2D)coords;
- (void)setPosition:(CLLocationCoordinate2D)position;

@end
