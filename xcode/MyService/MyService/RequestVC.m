//
//  RequestVC.m
//  MyService
//
//  Created by ohad shultz on 14/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "RequestVC.h"
#import "businessCardVC.h"

@interface RequestVC ()

@end

@implementation RequestVC
@synthesize currentRequestID;
@synthesize requestLabel;
@synthesize requestTable;

NSArray *priceArray;
NSArray *businessArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //MARK: colorize
    [requestTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    [requestLabel setTextColor:globalMainTextColor];
    //MARK: End colorize
    
    requestLabel.text = [NSString stringWithFormat:@"detaild for Request ID %@",currentRequestID];
    
    //get list of al business that replied to the request.
    
    //temporary arrays.
    priceArray = [[NSArray alloc]initWithObjects:@"1000",@"800",@"750",@"400", nil];
    businessArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",nil];
}

-(void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return businessArray.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index
    return NULL;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        cell.textLabel.text = [businessArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [priceArray objectAtIndex:indexPath.row];
        [cell.textLabel setTextColor:globalMainTextColor];
        [cell.detailTextLabel setTextColor:globalSeconderyTextColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    businessCardVC *businessDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"businessCardVC"];
    [businessDetails setCurrentBusinessID:[businessArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:businessDetails animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
