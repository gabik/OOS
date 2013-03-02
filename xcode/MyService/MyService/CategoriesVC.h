//
//  CategoriesVC.h
//  MyService
//
//  Created by ohad kazav on 26/12/12.
//  Copyright (c) 2012 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CategoriesVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *categoryTable;
@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@end