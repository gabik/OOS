//
//  MainMenuVC.m
//  MyService
//
//  Created by ohad shultz on 12/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "MainMenuVC.h"
#import "CategoriesVC.h"
#import "RequestVC.h"

@interface MainMenuVC ()

@end

@implementation MainMenuVC
@synthesize welcomeLabel;
@synthesize requestTable;

NSArray *requestArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //MARK: colorize
    [requestTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    [welcomeLabel setTextColor:globalMainTextColor];
    //MARK: End colorize
	// Do any additional setup after loading the view, typically from a nib.
    welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@",globalUserName];

    
    //get all request from server
    
    //temprary setting up requests.
    requestArray = [[NSArray alloc]initWithObjects:@"123456",@"234567",@"345678",nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [requestArray count];
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
        cell.textLabel.text = [requestArray objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell.textLabel setTextColor:globalMainTextColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RequestVC *requestDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestVC"];
    [requestDetail setCurrentRequestID:[requestArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:requestDetail animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
