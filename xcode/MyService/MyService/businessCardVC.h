//
//  businessCardVC.h
//  MyService
//
//  Created by ohad shultz on 14/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface businessCardVC : UIViewController;

@property (strong, nonatomic) IBOutlet UILabel *businessIDLabel;
@property (strong, nonatomic) IBOutlet UITableView *businessCardTable;
@property NSString *currentBusinessID;
@end

