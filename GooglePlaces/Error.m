//
//  Error.m
//  Dealers
//
//  Created by Gilad Lumbroso on 12/18/14.
//
//

#import "Error.h"

@implementation Error

- (NSString *)messagesString
{
    if (self.detail) {
        return NSLocalizedString(self.detail, nil);
    }
    
    else {
        NSArray *messages;
        
        if (self.emailExists) {
            return NSLocalizedString(@"Email already exists!", nil);
        } else if (self.emailFormat) {
            return NSLocalizedString(@"Please enter a valid email address.", nil);
        } else if (self.pseudoUserExists) {
            return @"Pseudo user already exists";
        }
        
        
        // The following code is useable only in case we use the actual text from the error message received by Django.
        
        NSMutableString *str = [[NSMutableString alloc] init];
        for (int i = 0; i < messages.count; i++) {
            NSString *msg = [messages objectAtIndex:i];
            if (i == messages.count - 1) {
                [str appendFormat:@"%@", msg];
            }
            else {
                [str appendFormat:@"%@\n", msg];
            }
        }
        
        return str;
    }
}

@end
