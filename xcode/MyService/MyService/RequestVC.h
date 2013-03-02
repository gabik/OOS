//
//  RequestVC.h
//  MyService
//
//  Created by ohad shultz on 14/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestVC : UIViewController;

@property NSString *currentRequestID;
@property (strong, nonatomic) IBOutlet UILabel *requestLabel;
@property (strong, nonatomic) IBOutlet UITableView *requestTable;

@end
