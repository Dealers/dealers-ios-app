//
//  StoreCategoriesOrganizer.h
//  Dealers
//
//  Created by Gilad Lumbroso on 1/27/15.
//
//

#import <Foundation/Foundation.h>

@interface StoreCategoriesOrganizer : NSObject

+ (BOOL)checkIfCategoryExists:(NSString *)category;
+ (UIImage *)iconForCategory:(NSString *)category;
+ (NSString *)superCategoryForCategory:(NSString *)category;

@end
