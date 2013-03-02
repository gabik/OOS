//
//  BusinessNewRequestVC.m
//  MyService
//
//  Created by ohad kazav on 14/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "BusinessNewRequestVC.h"
#import "RequestCardVC.h"

@interface BusinessNewRequestVC()

@end

@implementation BusinessNewRequestVC
@synthesize requestTable;
NSArray *newRequestArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //get all new Request For ClientID from server
    //MARK: colorize
    [requestTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    //MARK: End colorize
    
    newRequestArray = [[NSArray alloc]initWithObjects:@"id 1",@"id 2",nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [newRequestArray count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index
    return NULL;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.textLabel.text = [newRequestArray objectAtIndex:indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell.textLabel setTextColor:globalMainTextColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    RequestCardVC *requestDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestCardVC"];
    [requestDetail setCurrentRequestID:[newRequestArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:requestDetail animated:YES];
}

    
   



@end

