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

@interface ViewController ()

@end

@implementation ViewController
@synthesize signIn;
@synthesize signInTable;
@synthesize tapRecognizer;
@synthesize ProviderSignupButton;


NSArray *signInArray;
CGFloat cellHight;
NSString *userName;
NSString *password;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //MARK: color initiatig
    
    globalBgColor = [[UIColor alloc] initWithRed:245.0/255.0 green:230.0/255.0 blue:255.0/255.0 alpha:0.85];
    globalMainTextColor= [[UIColor alloc] initWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.85];
    globalSeconderyTextColor= [[UIColor alloc] initWithRed:165.0/255.0 green:130.0/255.0 blue:205.0/255.0 alpha:0.85];
    globalPickerTextColor= [[UIColor alloc] initWithRed:165.0/255.0 green:130.0/255.0 blue:205.0/255.0 alpha:0.85];
    
    //MARK: End coloe init
    
    //MARK: coloring
    [signInTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    signIn.titleLabel.textColor = globalMainTextColor;
    ProviderSignupButton.titleLabel.textColor = globalMainTextColor;
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

- (IBAction)signUp:(id)sender
{
    UserSignupVC *newUserSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"userSignupVC"];
    [self.navigationController pushViewController:newUserSignup animated:YES];
}

- (IBAction)SignIn {
    //check authontiaction with server.
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    UITextField *txtField = (UITextField *)[[[signInTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:0];
    userName = txtField.text;
    ip = [NSIndexPath indexPathForRow:1 inSection:0];
    txtField = (UITextField *)[[[signInTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:1];
    password = txtField.text;
    
//    NSString * post = [[NSString alloc] initWithFormat:@"&username=%@&password=%@",userName,password];
//    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
//    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ws.kazav.net/account/login/"]]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    //[request setValue:password forKey:@"password"];
//    //[request setValue:userName forKey:@"username"];
//    [request setHTTPBody:postData];
//    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    
//    
//    if (conn) NSLog(@"Connection Successful");
    

    //DAL *dal = [[DAL alloc]init];
    BOOL authunticated = NO;
    authunticated = [DAL Login:userName password:password];;
    if (authunticated)
    {
        //get userIsClient from server
        //get userId from server.
        //set globalUserId as user_id.
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
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        cell.textLabel.textColor = [UIColor grayColor];
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.textLabel.text = [signInArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-75, cell.frame.size.height-20)];
        textField.placeholder = [signInArray objectAtIndex:indexPath.row];
        //textField.text = [signInArray objectAtIndex:indexPath.row];
        textField.tag = indexPath.row;
        textField.delegate = self;
        [textField setReturnKeyType:UIReturnKeyDone];
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

- (IBAction)ProviderSignup:(id)sender {
    ProviderSignup *ProviderSignupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderSignupVC"];
    [self.navigationController pushViewController:ProviderSignupVC animated:YES];
    
    
}
@end
