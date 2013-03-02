//
//  DAL\.h
//  MyService
//
//  Created by ohad shultz on 27/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface DAL : UIViewController;

+(BOOL)Login:(NSString *)userName password:(NSString *)password;
+(BOOL)isUserIsClient;
+(BOOL*)userSignup:(NSArray *) userDetailsArray parametersArray:(NSArray *)parametersArray;
+(BOOL*)provSignup:(NSArray *) SignUpArray parametersArray:(NSArray *)parametersArray;
+(NSArray*)GetChiled:(NSInteger)parent_ID;
+(NSDictionary*)GetChildNamesAndIDs:(NSInteger)parent_ID;
@end

