//
//  NewRequestVC.m
//  MyService
//
//  Created by ohad shultz on 07/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "NewRequestVC.h"
#import "datePickerVC.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import "DAL.h"

@interface NewRequestVC ()

@end

@implementation NewRequestVC
@synthesize infoTable;
@synthesize infoPicker;
@synthesize currentIndex;
@synthesize textField;
@synthesize textView;
@synthesize swipeGustereReco;
@synthesize secondView;
@synthesize imageView;
@synthesize valuesTable;
@synthesize swipeImage;
@synthesize swipeImage2;
@synthesize SwipeLabel;
@synthesize infoArray;

UIDatePicker *datePicker;
UIImage *dragUpImage;
UIImage *dragDownImage;
NSDictionary *theDictionary;
NSArray *infoPickerArray;
NSDictionary *infoPickerDictionary;

int numOfSubArrays;
bool swiped = NO;
const int KEYBOARD_HIGHT = 216;
const int SWIPE_UP_HIGHT = 30;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //MARK: colorize
    [infoTable setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:globalBgColor];
    //MARK: End colorize
    
    //init datePicker
    datePicker = [[UIDatePicker alloc]init];
    
    //hide views
    swiped = NO;
    [secondView setHidden:YES];
    [infoPicker setHidden:YES];
    
    // get the infoTable fields from server
    theDictionary= [DAL GetChildNamesAndIDs:globalCategoryID];
    infoArray = [theDictionary keysSortedByValueUsingSelector:@selector(compare:)];

    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[[UIColor grayColor]CGColor]];
    [textView.layer setCornerRadius:8.0f];
    [textView.layer setMasksToBounds:YES];
    
    UISwipeGestureRecognizer *oneFingerSwipeUp =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeUp:)];
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:oneFingerSwipeUp];
    
    UISwipeGestureRecognizer *oneFingerSwipeDown =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)];
    [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:oneFingerSwipeDown];
    
    dragUpImage = [UIImage imageNamed:@"Arrow_Up.png"];
    dragDownImage = [UIImage imageNamed:@"Arrow_Down.png"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(SubmitNewRequest)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) viewDidAppear:(BOOL)animated
{
    infoPicker.frame = CGRectMake(infoPicker.frame.origin.x, infoPicker.frame.origin.y, infoPicker.frame.size.width, 162.0);
    CGFloat newSize = infoPicker.frame.size.height;
    infoPicker.frame=CGRectMake(infoPicker.frame.origin.x,self.view.frame.size.height-newSize-SWIPE_UP_HIGHT, infoPicker.frame.size.width, infoPicker.frame.size.height);
    [infoPicker.layer setCornerRadius:8.0f];
    [infoPicker.layer setMasksToBounds:YES];
    [infoPicker setHidden:NO];
    secondView.frame = CGRectMake(0, self.view.frame.size.height-SWIPE_UP_HIGHT, secondView.frame.size.width, secondView.frame.size.height);
    [secondView.layer setBorderWidth:2.0];
    [secondView.layer setBorderColor:[[UIColor grayColor]CGColor]];
    [secondView.layer setCornerRadius:8.0f];
    [secondView.layer setMasksToBounds:YES];
    [secondView setHidden:NO];
  
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[infoArray count] inSection:0];
    UITableViewCell *cell = [infoTable cellForRowAtIndexPath:ip];
    cell.detailTextLabel.text = userEndDate;
    [infoTable reloadData];
    
}

-(void) SubmitNewRequest
{
    NSString *successString = @"";
    int i =0;
    for(NSString *cell in infoArray)
    {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        if (i==0)
        {
            successString = [NSString stringWithFormat:@"%@ - %@ ",[infoArray objectAtIndex:i],[[[infoTable cellForRowAtIndexPath:ip] detailTextLabel] text]];
            
        }
        else
        {
            successString = [NSString stringWithFormat:@"%@, %@ - %@ ",successString,[infoArray objectAtIndex:i],[[[infoTable cellForRowAtIndexPath:ip] detailTextLabel] text]];
        }
        i++;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:successString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    //send information to server
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)oneFingerSwipeUp:(id)sender
{
    if ([sender locationInView:self.view].y > self.view.frame.size.height-SWIPE_UP_HIGHT)
    {
        if (swiped == NO)
        {
            CGRect secondViewFrame = secondView.frame;
            secondViewFrame.origin.y -= secondView.frame.size.height+KEYBOARD_HIGHT-SWIPE_UP_HIGHT;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:NO];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
            [secondView setFrame:secondViewFrame];
            [UIView commitAnimations];
            [textView becomeFirstResponder];
            swipeImage.image = dragDownImage;
            swipeImage2.image = dragDownImage;
            SwipeLabel.text = @"Swipe Down To Hide";
            swiped = YES;
        }
    }
}

-(IBAction)animationDidStop:(NSString *)animationID finished:(BOOL *)finished context:(void *)context
{
    //[self.textView setDelegate:self];
    //[self.textView becomeFirstResponder];
}

-(IBAction)oneFingerSwipeDown:(id)sender
{
    if (swiped == YES)
    {
        CGRect secondViewFrame = secondView.frame;
        secondViewFrame.origin.y += secondView.frame.size.height+KEYBOARD_HIGHT-SWIPE_UP_HIGHT;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        
        [secondView setFrame:secondViewFrame];
        [UIView commitAnimations];
        [textView resignFirstResponder];
        swipeImage.image = dragUpImage;
        swipeImage2.image = dragUpImage;
        SwipeLabel.text = @"Swipe Up To Add Free Text";
        swiped = NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //    CGRect secondViewFrame = secondView.frame;
    //    secondViewFrame.origin.y -= KEYBOARD_HIGHT;
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationBeginsFromCurrentState:NO];
    //    [UIView setAnimationDuration:0.3];
    //    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    //    [secondView setFrame:secondViewFrame];
    //    [UIView commitAnimations];
    //    //[textView becomeFirstResponder];
    //    swiped = YES;
    return YES;
}

-(IBAction)SelectExistingPicture:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

-(IBAction)TakeNewPhoto:(id)sender
{
    BOOL cameraAvailable =
    [UIImagePickerController
     isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (cameraAvailable)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Camera Found" message:@"Please Select Photo From Camera Roll" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self SelectExistingPicture:self];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage : (UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [imageView setImage:image];
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[self textView] resignFirstResponder];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//MARK: init table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    if (tableView.tag == 0)
    {
        return [infoArray count]+1;
    }
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    if (tableView.tag ==0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.85];
        if (indexPath.row < ([infoArray count]))
        {
            cell.textLabel.text = [infoArray objectAtIndex:indexPath.row];
            cell.textLabel.tag = [theDictionary objectForKey:[infoArray objectAtIndex:indexPath.row]];
        }
        else
        {
            cell.textLabel.text = @"End Date";
            //cell.detailTextLabel.text = userEndDate;
        }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell.textLabel setTextColor:globalMainTextColor];
    [cell.detailTextLabel setTextColor:globalSeconderyTextColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (tableView.frame.size.height-20)/([infoArray count]+1);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag ==0)
    {
        currentIndex = indexPath.row;
        if (indexPath.row == [infoArray count])
        {
            datePickerVC *datePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"datePickerVC"];
            [self.navigationController pushViewController:datePicker animated:YES];
        }
        else if (indexPath.row ==0)
        {
            infoPickerDictionary = [DAL GetChildNamesAndIDs:[[[theDictionary allValues]objectAtIndex:indexPath.row]integerValue]];
            infoPickerArray = [infoPickerDictionary allKeys];
            [infoPicker reloadAllComponents];
        }
        else
        {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
            NSInteger *parentID = [[[infoTable cellForRowAtIndexPath:ip]detailTextLabel]tag];
            if (parentID > 0)
            {
                infoPickerDictionary = [DAL GetChildNamesAndIDs:parentID];
                infoPickerArray = [infoPickerDictionary allKeys];
                [infoPicker reloadAllComponents];
            }
            else
            {
                infoPickerArray = [NSArray arrayWithObjects:@"",nil];
                [infoPicker reloadAllComponents];
            }
        }
    }
}

//MARK: init picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [infoPickerArray count];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        tView.font = [UIFont systemFontOfSize:16.0];
        tView.textColor = globalMainTextColor;
        tView.textAlignment = NSTextAlignmentCenter;
        tView.backgroundColor = [UIColor clearColor];
    }
    // Fill the label text here
    tView.text = [infoPickerArray objectAtIndex:row];
    return tView;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Get the first cell of the first section
    NSIndexPath *ip = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    UITableViewCell *cell = [infoTable cellForRowAtIndexPath:ip];
    
    //Change the textLabel contents
    cell.detailTextLabel.text = [[infoPickerDictionary allKeys] objectAtIndex:row];
    cell.detailTextLabel.tag = [[[infoPickerDictionary allValues] objectAtIndex:row]integerValue];
    
    //Refresh the tableView
    [infoTable reloadData];
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
