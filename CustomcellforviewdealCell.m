//
//  CustomcellforviewdealCell.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "CustomcellforviewdealCell.h"
#import "AppDelegate.h"

@implementation CustomcellforviewdealCell
@synthesize YesNo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)selected animated:(BOOL)animated
{
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:236/255.0 alpha:1]];
    [self setSelectedBackgroundView:bgColorView];
    [super setSelected:selected animated:animated];
    }



@end