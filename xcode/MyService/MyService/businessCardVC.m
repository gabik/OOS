//
//  businessCardVC.m
//  MyService
//
//  Created by ohad shultz on 14/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "businessCardVC.h"

@interface businessCardVC ()

@end

@implementation businessCardVC
@synthesize currentBusinessID;
@synthesize businessIDLabel;
@synthesize businessCardTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //MARK: colorize
    [businessCardTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    [businessIDLabel setTextColor:globalMainTextColor];
    //MARK: End colorize
    businessIDLabel.text = [[NSString alloc] initWithFormat:@"detail for business ID: %@",currentBusinessID ];
}

-(void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return 1;
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
        [cell.textLabel setTextColor:globalMainTextColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

