#import "DAL.h"

@interface DAL ()

@end

@implementation DAL

+(BOOL)Login:(NSString *)userName password:(NSString *)password
{
    NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",userName,password];
    NSURL *url=[NSURL URLWithString:@"http://ws.kazav.net/account/Plogin/"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([error code] == 0)
    {
        NSError *jsonError;
        NSArray *login = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&jsonError];
        if ([jsonError code] == 0) {
            NSDictionary *loginDetails = [login objectAtIndex:0];
            NSDictionary *loginFields = [loginDetails valueForKey:@"fields"];
            NSString *loginStatus = [loginFields valueForKey:@"status"];
            NSString *loginMessage = [loginFields valueForKey:@"MSG"];
            if ([loginStatus isEqual: @"OK"])
            {
                return YES;
            }
            else if ([loginStatus isEqual: @"ERR"])
            {
                if ([loginMessage isEqual:@"NE"])
                {
                    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:@"Incorrect Username Or Password" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
                    [errorAlert show];
                }
                
                else if ([loginMessage isEqual:@"PD"]){
                    UIAlertView *erroralert = [[UIAlertView alloc]initWithTitle: @"Login Error" message:@"Your Account Is Under Review, Please Try Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [erroralert show];
                }
                return NO;
            }
            else if ([loginStatus isEqual: @"WRN"])
            {
                return NO;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"No connection" message:@"please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            return NO;
        }
    }
    else
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"General Error" message:@"please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        return NO;
    }
}
+(BOOL)isUserIsClient
{
    NSString *post =[[NSString alloc] initWithFormat:@"user_id="];
    NSURL *url=[NSURL URLWithString:@"http://ws.kazav.net/oos/get_user/"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([error code] == 0)
    {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&jsonError];
        if ([jsonError code] == 0)
        {
            NSArray *statusArray = [jsonArray objectAtIndex:0];
            NSDictionary *statusDicrionary = [statusArray objectAtIndex:0];
            NSDictionary *statusFieldsDictionary = [statusDicrionary valueForKey:@"fields"];
            NSString *status = [statusFieldsDictionary valueForKey:@"status"];
            NSString *messeage = [statusFieldsDictionary valueForKey:@"MSG"];
            if ([status isEqual:@"OK"])
            {
                NSArray *userInfoArray = [jsonArray objectAtIndex:1];
                NSDictionary *userInfoDictionary = [userInfoArray objectAtIndex:0];
                NSDictionary *userInfoFieldsDictionary = [userInfoDictionary valueForKey:@"fields"];
                NSInteger isClientString = [[userInfoFieldsDictionary valueForKey:@"is_client"]integerValue];
                if (isClientString==0)
                {
                    return NO;
                }
        
                else
                {
                    return YES;
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:messeage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
        }
    }
    return YES;
}

+(NSArray*)GetChiled:(NSInteger)parent_ID
{
    NSLog(@"requesting infor fot parent: %d",parent_ID);
    NSString *post =[[NSString alloc] initWithFormat:@"parent=%d",parent_ID];
    NSURL *url=[NSURL URLWithString:@"http://ws.kazav.net/oos/get_child/"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",data);
    NSArray *myDictionery = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    return myDictionery;
}

+(NSDictionary*)GetChildNamesAndIDs:(NSInteger)parent_ID
{
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
    NSArray *myArray = [self GetChiled:parent_ID];
    for (NSDictionary *dictionary in myArray) {
        NSDictionary *fieldsDictionary = [dictionary objectForKey:@"fields"];
        NSString *categoryName = [fieldsDictionary objectForKey:@"name"];
        NSString *categoryID = [dictionary objectForKey:@"pk"];
        if ( categoryName != nil)
        {
            [myDictionary setValue:categoryID forKey:categoryName];
        }
    }
    NSDictionary *theDictionary = [[NSDictionary alloc]initWithDictionary:myDictionary];
    return theDictionary;
}


+(BOOL*)userSignup:(NSArray *) userDetailsArray parametersArray:(NSArray *)parametersArray
{
    NSString *post = [[NSString alloc]initWithFormat:@"%@=%@",[parametersArray objectAtIndex:0],[userDetailsArray objectAtIndex:0]];
    for (int i=1; i<[userDetailsArray count]; i++)
    {
        post = [NSString stringWithFormat:@"%@&%@=%@",post,[parametersArray objectAtIndex:i],[userDetailsArray objectAtIndex:i]];
    }
    
    NSURL *url=[NSURL URLWithString:@"http://ws.kazav.net/account/Pnew/"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",data);
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    return NO;
}


+(BOOL*)provSignup:(NSArray *) SignUpArray parametersArray:(NSArray *)parametersArray
{
    NSString *post = [[NSString alloc]initWithFormat:@"%@=%@",[parametersArray objectAtIndex:0],[SignUpArray objectAtIndex:0]];
    for (int i=1; i<[SignUpArray count]; i++)
    {
        post = [NSString stringWithFormat:@"%@&%@=%@",post,[parametersArray objectAtIndex:i],[SignUpArray objectAtIndex:i]];
    }
    
    NSURL *url=[NSURL URLWithString:@"http://ws.kazav.net/account/Pnew/"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",data);
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    return NO;
}

@end
