//
//  main.m
//  MyService
//
//  Created by ohad kazav on 26/12/12.
//  Copyright (c) 2012 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
NSInteger globalUserID;
NSInteger globalCategoryID;
NSString *globalSystemLanguage;
NSMutableArray *globalCategoryArray;
NSString *globalUserName;
NSString *userEndDate;
UIColor *globalBgColor;
UIColor *globalMainTextColor;
UIColor *globalSeconderyTextColor;
UIColor *globalPickerTextColor;

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
