//
//  CategoriseVC.m
//  MyService
//
//  Created by ohad kazav on 05/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "CategoriesVC.h"
#import "NewRequestVC.h"
#import "DAL.h"
@interface CategoriesVC ()

@end

@implementation CategoriesVC
@synthesize categoryTable;
@synthesize mainLabel;


bool toReturn = NO;
NSArray *categoryArray;
NSDictionary *categoryDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //MARK: colorize
    [categoryTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    [mainLabel setTextColor:globalMainTextColor];
    //MARK: End colorize
    
    // Query Server for Category list and fill the Table View.
    
    categoryDictionary = [DAL GetChildNamesAndIDs:0];
    categoryArray = [categoryDictionary keysSortedByValueUsingSelector:@selector(compare:)];
}

-(void)viewDidAppear:(BOOL)animated
{
    //setup default EndDate.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 7;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *dateToBeIncremented = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSString *stringFromDate = [formatter stringFromDate:dateToBeIncremented];
    userEndDate = stringFromDate;
    //----------------------
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [categoryArray count];
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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = globalMainTextColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [categoryArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NewRequestVC *newRequestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newRequestVC"];
    newRequestVC.title = cell.textLabel.text;
    globalCategoryID = [[categoryDictionary valueForKey:cell.textLabel.text]integerValue];
    [self.navigationController pushViewController:newRequestVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
