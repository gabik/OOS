//
//  ViewController.m
//  MyService
//
//  Created by ohad kazav on 26/12/12.
//  Copyright (c) 2012 ohad kazav. All rights reserved.
//

#import "ViewController.h"
#import "CategoriesVC.h"
#import "MainMenuVC.h"
#import "DAL.h"
#import "ProviderSignup.h"
#import "UserSignupVC.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize signInButton;
@synthesize signInTable;
@synthesize tapRecognizer;
@synthesize ProviderSignupButton;
@synthesize forgotPasswordButton;
@synthesize userSignUpButton;


NSArray *signInArray;
CGFloat cellHight;
NSString *userName;
NSString *password;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //MARK: color initiatig
    
    globalBgColor = [[UIColor alloc] initWithRed:238.0/255.0 green:227.0/255.0 blue:129.0/255.0 alpha:1.0];
    globalMainTextColor= [[UIColor alloc] initWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.85];
    globalSeconderyTextColor= [[UIColor alloc] initWithRed:165.0/255.0 green:130.0/255.0 blue:205.0/255.0 alpha:0.85];
    globalPickerTextColor= [[UIColor alloc] initWithRed:165.0/255.0 green:130.0/255.0 blue:205.0/255.0 alpha:0.85];
    globalTableBgColor = [[UIColor alloc] initWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1];
    globalTextFieldBgColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:0.4];
    //MARK: End coloe init
    
    //MARK: coloring
    [signInTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    signInButton.titleLabel.textColor = globalMainTextColor;
    [signInButton setTitleColor:globalTextFieldBgColor forState:UIControlStateNormal];
    signInButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2];
    signInButton.layer.borderColor = [UIColor blackColor].CGColor;
    signInButton.layer.borderWidth = 0.0f;
    signInButton.layer.cornerRadius = 10.0f;
    [ProviderSignupButton setTitleColor:globalMainTextColor forState:UIControlStateNormal];
    [userSignUpButton setTitleColor:globalMainTextColor forState:UIControlStateNormal];

    //MARK: end coloring
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [[self view] addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    //Get user System Language
    NSLocale *locale = [NSLocale currentLocale];
    NSString * localLanguage = [locale objectForKey:NSLocaleIdentifier];

    //set globalLanguage
    globalSystemLanguage = localLanguage;
    signInArray = [[NSArray alloc]initWithObjects:@"Username",@"Password",nil];
}
-(void)viewDidAppear:(BOOL)animated
{

}

-(void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    UITextField *txtField = (UITextField *)[[[signInTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:0];
    if ([txtField isFirstResponder])
    {
        [txtField resignFirstResponder];
    }
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    txtField = (UITextField *)[[[signInTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:1];
    if ([txtField isFirstResponder])
    {
        [txtField resignFirstResponder];
    }
}

- (IBAction)SignIn {
    //check authontiaction with server.
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    UITextField *txtField = (UITextField *)[[[signInTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:0];
    userName = txtField.text;
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    txtField = (UITextField *)[[[signInTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:1];
    password = txtField.text;
    
    BOOL authunticated = NO;
    authunticated = [DAL Login:userName password:password];;
    if (authunticated)
    {
        globalUserID = 111;
        globalUserName = userName;
        
        BOOL userIsClient = [DAL isUserIsClient];
        if (userIsClient)
        {
            UITabBarController *mainMenuController = [self.storyboard instantiateViewControllerWithIdentifier:@"clientBarController"];
            [self.navigationController pushViewController:mainMenuController animated:YES];
        }
        else
        {
            UITabBarController *mainMenuCotroller = [self.storyboard instantiateViewControllerWithIdentifier:@"businessBarController"];
            [self.navigationController pushViewController:mainMenuCotroller animated:YES];
        }
    }
    else
    {
        [forgotPasswordButton setHidden:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
        UITextField *txtField = (UITextField *)[[[signInTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:1];
        [txtField becomeFirstResponder];
    }
    else
    {
        [self SignIn];
    }
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return signInArray.count;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-75, cell.frame.size.height-20)];
        textField.placeholder = [signInArray objectAtIndex:indexPath.row];
        textField.tag = indexPath.row;
        textField.delegate = self;
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        if (indexPath.row == 1) { [textField setSecureTextEntry:YES]; }
        cell.accessoryView = textField;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (signInTable.frame.size.height-20)/[signInArray count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ProviderSignup:(id)sender
{
    ProviderSignup *ProviderSignupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderSignupVC"];
    [ProviderSignupVC setIsClient:NO];
    [self.navigationController pushViewController:ProviderSignupVC animated:YES];
}
- (IBAction)signUp:(id)sender
{
    ProviderSignup *newUserSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderSignupVC"];
    [newUserSignup setIsClient:YES];
    [self.navigationController pushViewController:newUserSignup animated:YES];
}
@end
