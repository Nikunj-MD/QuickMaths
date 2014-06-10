//  MathsWar

/*!
 @class LevelsViewController
 @superclass UIViewController
 @abstract Shows levels - Easy, Medium, Hard.
 
 @author Pradnya Mankar
 @discussion Created: 16-01-2013
 @updated 12-01-2013
 */

#import "LevelsViewController.h"
#import "QuestionViewController.h"

@interface LevelsViewController ()

@end

@implementation LevelsViewController

@synthesize bgImgView, logoImgView, lblChamp;
@synthesize operation;

- (id)initWithOperation:(NSString *)_operation
{
    self = [super init];
    if (self) {
        self.operation = _operation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( [self.operation isEqualToString:@"+"] ) {
        [self.lblChamp setText:@"Addition Champ :)"];
    }
    else if ( [self.operation isEqualToString:@"-"] ) {
        [self.lblChamp setText:@"Subtraction Champ :)"];
    }
    else if ( [self.operation isEqualToString:@"x"] ) {
        [self.lblChamp setText:@"Multiplication Champ :)"];
    }
    else if ( [self.operation isEqualToString:@"÷"] ) {
        [self.lblChamp setText:@"Division Champ :)"];
    }
    
    [self.lblChamp setFont:[UIFont fontWithName:@"Adler" size:19]];
    CGAffineTransform transform = CGAffineTransformMakeRotation(6.195918845); // 355 degree
    [self.lblChamp setTransform:transform];
    
    if( is_iPhone_5 ) {
        [self.bgImgView setImage:[UIImage imageNamed:@"home_background_5.png"]];
        [self.logoImgView setFrame:CGRectMake(23, 51, 273, 134)];
    }
}

#pragma mark- Button Action

-(IBAction)home:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*!
 @method levelSelected:
 @discussion This method shows game screen
 */
-(IBAction)levelSelected:(id)sender
{
    int level = [sender tag];
    /*int gameIndex;
    
    NSMutableArray *games = [[MathsWarManager sharedManager] games];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"operation = %@ AND level = %d", operation, level];
    NSArray *arrGames = [games filteredArrayUsingPredicate:predicate];
    if([arrGames count] == 0)   {*/
        
        NSMutableDictionary *game = [NSMutableDictionary dictionary];
        [game setObject:[NSNumber numberWithInt:3] forKey:@"life"];
        [game setObject:[NSNumber numberWithInt:10] forKey:@"coins"];
        [game setObject:[NSNumber numberWithInt:0] forKey:@"score"];
        [game setObject:operation forKey:@"operation"];
        [game setObject:[NSNumber numberWithInt:level] forKey:@"level"];
        /*[games addObject:game];
        gameIndex = [games indexOfObject:game];
    }
    else    {
        NSMutableDictionary *game = [arrGames objectAtIndex:0];
        gameIndex = [games indexOfObject:game];
    }
    
    QuestionViewController *questionVC = [[QuestionViewController alloc] initWithGameIndex:gameIndex];*/
    QuestionViewController *questionVC = [[QuestionViewController alloc] initWithGame:game];
    [self.navigationController pushViewController:questionVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
