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
        return self.detail;
    }
    
    else {
        NSArray *messages;
        
        if (self.emailExists) {
            return @"Email already exists!";
        } else if (self.emailFormat) {
            return @"Please enter a valid email address.";
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
