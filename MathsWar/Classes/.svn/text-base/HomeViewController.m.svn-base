//  MathsWar

/*!
 @class HomeViewController
 @superclass UIViewController
 @abstract Shows operations - Addition, subtraction, multiplication, deletion.
 
 @author Pradnya Mankar
 @discussion Created: 16-01-2013
 @updated 12-01-2013
 */

#import "HomeViewController.h"
#import "LevelsViewController.h"
#import "QuestionViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MathsWarManager sharedManager] initialize];
    
    if( is_iPhone_5 ) {
        [self.bgImgView setImage:[UIImage imageNamed:@"home_background_5.png"]];
        [self.logoImgView setFrame:CGRectMake(23, 51, 273, 134)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Button Action

/*!
 @method operationSelected:
 @discussion This method shows level selection screen for selected category
 */
-(IBAction)operationSelected:(id)sender
{
    NSString *operation;
    switch ( [sender tag] ) {
        case 1: operation = @"+";    break;
        case 2: operation = @"-";    break;
        case 3: operation = @"x";    break;
        case 4: operation = @"÷";    break;
            
        default:            break;
    }
    
    LevelsViewController *levelVC = [[LevelsViewController alloc] initWithOperation:operation];
    [self.navigationController pushViewController:levelVC animated:YES];
}

/*!
 @method presentGame:
 @discussion This method shows game screen
 */
- (void) presentGame:(NSMutableDictionary *)_game
{
    QuestionViewController *questionVC = [[QuestionViewController alloc] initWithGame: _game];
    [self.navigationController pushViewController:questionVC animated:YES];
}

@end
