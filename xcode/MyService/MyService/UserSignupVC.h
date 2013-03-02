//
//  UserSignupVC.h
//  MyService
//
//  Created by ohad shultz on 02/03/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserSignupVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>;
@property (strong, nonatomic) IBOutlet UITableView *SignUpTable;


@end