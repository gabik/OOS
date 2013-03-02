#import "ViewControllerPro.h"
#import "ViewControllerCars.h"

@interface ViewControllerPro ()

@end

@implementation ViewControllerPro
@synthesize pickerView;
@synthesize arrayColors;
@synthesize indexPicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    arrayColors = [[NSMutableArray alloc] init];
    [arrayColors addObject:@"Cars"];
    [arrayColors addObject:@"Constraction"];
    [arrayColors addObject:@"Electrical"];
    [arrayColors addObject:@"Events"];
    [arrayColors addObject:@"fournetuer"];
    [arrayColors addObject:@"Computers"];
    [arrayColors addObject:@"Musicals"];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(SelectCategory)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)SelectCategory
{
    //NSString *strFromInt = [NSString stringWithFormat:@"%d",indexPicker];
    ViewControllerCars *cv = [[ViewControllerCars alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:cv animated:YES completion:NULL];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BOOYAH!"
//                                                    message:strFromInt delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [arrayColors count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrayColors objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    indexPicker = row;
}

@end