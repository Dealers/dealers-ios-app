//
//  BackgroundLayer.m
//  Dealersapp
//
//  Created by itzik berrebi on 10/19/13.
//
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.95 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.97 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.97 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.97 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.92];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.59];
    NSNumber *stopFour = [NSNumber numberWithFloat:0.95];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(245/255.0)  green:(245/255.0)  blue:(245/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0];
    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.5];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

@end
