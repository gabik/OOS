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


+(BOOL*)Signup:(NSArray *) SignUpArray parametersArray:(NSArray *)parametersArray postTo:(BOOL)isClient
{
    NSString *post = [[NSString alloc]initWithFormat:@"%@=%@",[parametersArray objectAtIndex:0],[SignUpArray objectAtIndex:0]];
    for (int i=1; i<[SignUpArray count]; i++)
    {
        post = [NSString stringWithFormat:@"%@&%@=%@",post,[parametersArray objectAtIndex:i],[SignUpArray objectAtIndex:i]];
    }
    NSString *postTo = [[NSString alloc]init];
    if (isClient)
    {
        postTo = @"Pnew";
    }
    else
    {
        postTo = @"Pnew_prov";
    }
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://ws.kazav.net/account/%@/",postTo]];
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
    NSError *jsonError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&jsonError];
    NSLog([jsonError description]);
    if ([jsonError code] == 0)
    {
        NSArray *statusArray = [jsonArray objectAtIndex:0];
        NSDictionary *statusDictionary = [statusArray objectAtIndex:0];
        NSDictionary *statusFields = [statusDictionary objectForKey:@"fields"];
        NSString *status = [statusFields objectForKey:@"status"];
        NSString *MSG = [statusFields objectForKey:@"MSG"];
        if ([status isEqual:@"OK"])
        {
            NSString *alertViewString = [[NSString alloc]init];
            if(isClient)
            {
                alertViewString = @"You successfully registerd for our services, you can log-in now.";
            }
            else
            {
                alertViewString = @"Your submit request was sent, our team will verify your detailes and you will get un Email in case that your detailes are correct";
            }
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:alertViewString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return YES;
        }
        else if ([status isEqual:@"WRN"])
        {
            NSMutableString *errorString = [[NSMutableString alloc]init];
            for (NSArray *subArray in jsonArray)
            {
                if (!(subArray == [jsonArray objectAtIndex:0]))
                {
                    for (NSDictionary *subDictionary in subArray)
                    {
                        [errorString appendString:[NSString stringWithFormat:@"error in field %@: %@,",[[subDictionary allKeys]objectAtIndex:0],[[subDictionary allValues]objectAtIndex:0]]];
                        //[errorArray addObject:[NSString stringWithFormat:@"field: %@: %@",[[subDictionary allKeys]objectAtIndex:0],[[subDictionary allValues]objectAtIndex:0]]];
                    }
                }
            }
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Detailes Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            return NO;
        }
        return NO;
    }
    else
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"General Error" message:@"please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        return NO;
    }
}
+(BOOL)submitNewRequest:(NSDictionary *)newRequest
{
    
}

@end
