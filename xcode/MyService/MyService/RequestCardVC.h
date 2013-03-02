//
//  RequestCardVC.h
//  MyService
//
//  Created by ohad shultz on 16/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestCardVC : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>;
@property (strong, nonatomic) IBOutlet UITableView *ResponseListTable;
@property NSString *currentRequestID;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITextView *textView;


@end

