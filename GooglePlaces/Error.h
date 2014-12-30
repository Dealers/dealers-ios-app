//
//  Error.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/18/14.
//
//

#import <Foundation/Foundation.h>

@interface Error : NSObject

@property NSString *detail;
@property NSArray *emailFormat;
@property NSArray *emailExists;

- (NSString *)messagesString;

@end
