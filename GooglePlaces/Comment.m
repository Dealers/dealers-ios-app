//
//  Comment.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/27/14.
//
//

#import "Comment.h"

@implementation Comment

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return self;
}

@end
