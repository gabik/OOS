//
//  RequestCardVC.m
//  MyService
//
//  Created by ohad shultz on 16/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//


#import "RequestCardVC.h"
#import <QuartzCore/QuartzCore.h>

@interface RequestCardVC ()

@end

@implementation RequestCardVC
@synthesize ResponseListTable;
@synthesize tapGestureRecognizer;
@synthesize textView;
NSDictionary *requestDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //MARK: colorize
    [ResponseListTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    //MARK: End colorize
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer2];
    tapGestureRecognizer2.delegate = self;
    
    NSArray *values = [[NSArray alloc] initWithObjects:@"22-11-2013",@"Ohad",@"Private",@"Mazda",@"Model1", nil];
    NSArray *key = [[NSArray alloc] initWithObjects:@"End date",@"Name",@"Type",@"manufactor",@"Model", nil];
    requestDictionary = [[NSDictionary alloc] initWithObjects:values forKeys:key];
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[[UIColor grayColor]CGColor]];
    [textView.layer setCornerRadius:8.0f];
    [textView.layer setMasksToBounds:YES];
}

//MARK: Distance section (when the keybord is over the text field)
CGFloat animatedDistance;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];

    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;

    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }

    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];

    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];

    [UIView commitAnimations];
}

//MARK: End Distance function




-(void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    NSIndexPath *ip = [NSIndexPath indexPathForRow:([requestDictionary count]) inSection:0];
    UITextField *txtField = (UITextField *)[[[ResponseListTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:0];
    if ([txtField isFirstResponder])
    {
        [txtField resignFirstResponder];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [requestDictionary count]+1;
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
        if(indexPath.row < [requestDictionary count])
        {
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.text = [[requestDictionary allKeys] objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[requestDictionary allValues] objectAtIndex:indexPath.row];
            [cell.textLabel setTextColor:globalMainTextColor];
            [cell.detailTextLabel setTextColor:globalSeconderyTextColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, (ResponseListTable.frame.size.width/2)-65, cell.frame.size.height/2-5)];
            textField.placeholder = @"price";
            //textField.text = [signInArray objectAtIndex:indexPath.row];
            //textField.tag = indexPath.row;
            textField.delegate = self;
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setKeyboardType:UIKeyboardTypeDecimalPad];
            textField.font = [UIFont systemFontOfSize:12];
            textField.textColor = [UIColor blueColor];
            //if (indexPath.row == 1) { [textField setSecureTextEntry:YES]; }
            cell.accessoryView = textField;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.text = @"Estimated Price:";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (ResponseListTable.frame.size.height-20)/([requestDictionary count]+1);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

