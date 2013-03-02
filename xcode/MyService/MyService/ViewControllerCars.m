#import "ViewControllerCars.h"

@interface ViewControllerCars()

@end

@implementation ViewControllerCars
@synthesize cameraButton;
@synthesize manText;
@synthesize yearText;
@synthesize modelText;


-(IBAction)screentouch
{
        [manText resignFirstResponder];
        [modelText resignFirstResponder];
        [yearText resignFirstResponder];
}
//         if (yearText.isFirstResponder)
//        {
//            [self textFieldDidEndEditing:yearText];
//            [yearText resignFirstResponder];
//        }

                                 

-(IBAction)getCameraPicture:(id)sender;
{
    BOOL cameraAvailable =
    [UIImagePickerController
     isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (cameraAvailable)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [self selectExitingPicture];
    }
}

-(IBAction)selectExitingPicture
{
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        //picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFieldFinished:(id)sender
{
    manText.keyboardAppearance = false;
    yearText.keyboardAppearance = false;
    modelText.keyboardAppearance = false;
   
    
    }



- (void)viewDidLoad
{
    [self.manText addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.yearText addTarget:self
                     action:@selector(textFieldFinished:)
           forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.modelText addTarget:self
                     action:@selector(textFieldFinished:)
           forControlEvents:UIControlEventEditingDidEndOnExit];
//    [self.yearText addTarget:self action:@selector(textFieldDidBeginEditing:)
//            forControlEvents:UIControlEventEditingDidBegin];
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Distance section (when the keybord is over the text field)


//CGFloat animatedDistance;
//
//static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
//static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
//static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
//static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
//static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    CGRect textFieldRect =
//    [self.view.window convertRect:textField.bounds fromView:textField];
//    CGRect viewRect =
//    [self.view.window convertRect:self.view.bounds fromView:self.view];
//    
//    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
//    CGFloat numerator =
//    midline - viewRect.origin.y
//    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
//    CGFloat denominator =
//    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
//    * viewRect.size.height;
//    CGFloat heightFraction = numerator / denominator;
//    
//    if (heightFraction < 0.0)
//    {
//        heightFraction = 0.0;
//    }
//    else if (heightFraction > 1.0)
//    {
//        heightFraction = 1.0;
//    }
//    
//    UIInterfaceOrientation orientation =
//    [[UIApplication sharedApplication] statusBarOrientation];
//    if (orientation == UIInterfaceOrientationPortrait ||
//        orientation == UIInterfaceOrientationPortraitUpsideDown)
//    {
//        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
//    }
//    else
//    {
//        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
//    }
//    
//    CGRect viewFrame = self.view.frame;
//    viewFrame.origin.y -= animatedDistance;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    
//    [self.view setFrame:viewFrame];
//    
//    [UIView commitAnimations];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    CGRect viewFrame = self.view.frame;
//    viewFrame.origin.y += animatedDistance;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    
//    [self.view setFrame:viewFrame];
//    
//    [UIView commitAnimations];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end