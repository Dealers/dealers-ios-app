//
//  PaddedTextField.m
//  Dealers
//
//  Created by Gilad Lumbroso on 5/13/15.
//
//

#import "PaddedTextField.h"

@implementation PaddedTextField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _edgeInsets = UIEdgeInsetsMake(0, 5, 0, 3);
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        _edgeInsets = UIEdgeInsetsMake(0, 5, 0, 3);
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

@end
