//  MathsWar

/*!
 @class ScoreViewController
 @superclass UIViewController
 @abstract Shows score and gamecenter highscores
 
 @author Pradnya Mankar
 @discussion Created: 21-02-2013
 @updated 08-03-2013
 */

#import "ScoreViewController.h"
#import "QuestionViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import <Social/Social.h>
#import "DDGameKitHelper.h"

#define kOAuthConsumerKey			@"3siK29apb1Kx7GZH6KabQ"
#define kOAuthConsumerSecret		@"Oou6vxVfPYeu7U2Tl3Dhxs8DpzMES2IhcJYZ0Rkqa0"

#define SCORE_LEADERBOARD           @"com.clarion.mathstrainer.leaderboard.scores"

@interface ScoreViewController ()
- (void) playerAuth;
@end

@implementation ScoreViewController

@synthesize lblText, lblCoins, lblScore, lblLevel, lblCategory;
@synthesize btnHighScores;

/*!
 @method twitterSetup
 @discussion This method initializes Twitter engine
 */
- (void) twitterSetup
{
    // Twitter engine setup
    if (_engine) return;
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
}

/*!
 @method textForSharing
 @return This method returns text to be shared on social n/w
 */
- (NSString *) textForSharing
{
    NSString *strLevel, *strOperation;
    int level = [[game objectForKey:@"level"] intValue];
    switch ( level ) {
        case EASY:      strLevel = @"Easy";     break;
        case MEDIUM:    strLevel = @"Medium";   break;
        case HARD:      strLevel = @"Hard";     break;
    }
    
    NSString *op = (NSString *)[game objectForKey:@"operation"];
    if( [op isEqualToString:@"+"] )      {  strOperation = @"Addition"; }
    else if( [op isEqualToString:@"-"] ) {  strOperation = @"Subtraction";  }
    else if( [op isEqualToString:@"x"] ) {  strOperation = @"Multiplication";   }
    else if( [op isEqualToString:@"÷"] ) {  strOperation = @"Division"; }
    
    NSString *message = [NSString stringWithFormat:@"Scored %@ in %@ level of %@",
                         [self.lblScore text], strLevel, strOperation];
    return message;
}

/*!
 @method publishScoreOnFacebook
 @discussion This method shares score on Facebook ( < iOS 6.0 )
 */
- (void) publishScoreOnFacebook
{
    [[MathsWarManager sharedManager] shareScore:[self textForSharing]];
}

/*!
 @method userLoggedIn
 @discussion This method is called when Facebook login is successful
 */
- (void)userLoggedIn
{
    [self publishScoreOnFacebook];
}

#pragma mark - Button actions

-(IBAction)home:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*!
 @method shareOnFacebook:
 @discussion This method will present UI to share on Facebook
 */
- (IBAction) shareOnFacebook:(id)sender
{
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0") )     {
        
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [facebookSheet dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    //NSLog(@"Cancelled.....");
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PROJECT_NAME message:@"Posted on Facebook" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }
                    break;
            }};
        
        [facebookSheet setInitialText: [self textForSharing]];
        [facebookSheet addImage:[UIImage imageNamed:@"icon.png"]];
        [facebookSheet setCompletionHandler:completionHandler];
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
    else    {
        
        MathsWarManager *sharedManager = [MathsWarManager sharedManager];
        [sharedManager setFbDelegate:self];
        if( ![sharedManager facebook] )     {
            
            [sharedManager facebookSetup];
        }
        
        if( [[sharedManager facebook] isSessionValid] )     {
            
            [self publishScoreOnFacebook];
        }
        else    {
            [sharedManager facebookLogin];
        }
    }
}

/*!
 @method shareOnTwitter:
 @discussion This method will present UI to share on Twitter
 */
- (IBAction) shareOnTwitter:(id)sender
{
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0") )     {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [tweetSheet dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    //NSLog(@"Cancelled.....");
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PROJECT_NAME message:@"Posted on Twitter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }
                    break;
            }};
        
        
        [tweetSheet setInitialText: [self textForSharing]];
        [tweetSheet addImage:[UIImage imageNamed:@"icon.png"]];
        [tweetSheet setCompletionHandler:completionHandler];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else    {
        
        if( ![_engine isAuthorized] )
        {
            UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
            
            if (controller)
                [self presentModalViewController: controller animated: YES];
            else {
                [_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
            }
        }
        else    {
            //NSLog(@"Twitter isAuthorized");
            [_engine sendUpdate: [self textForSharing]];
        }
    }
}

/*!
 @method play:
 @discussion This method will show next level / same level screen depending upon current screen type
 */
-(IBAction)play:(id)sender
{
    int level = [[game objectForKey:@"level"] intValue];
    
    switch ( level ) {
            
        case EASY:
        case MEDIUM:
        {
            if( [type isEqualToString:@"LevelFinished"] )   {
            
                level += 1;
            }
            
            NSMutableDictionary *newGame = [NSMutableDictionary dictionary];
            [newGame setObject:[NSNumber numberWithInt:3] forKey:@"life"];
            [newGame setObject:[NSNumber numberWithInt:10] forKey:@"coins"];
            [newGame setObject:[NSNumber numberWithInt:0] forKey:@"score"];
            [newGame setObject:[game objectForKey:@"operation"] forKey:@"operation"];
            [newGame setObject:[NSNumber numberWithInt: level] forKey:@"level"];
            
            QuestionViewController *questionVC = [[QuestionViewController alloc] initWithGame: newGame];
            [self.navigationController pushViewController:questionVC animated:YES];
        }
            break;
            
        case HARD:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        default:        break;
    }
}

/*!
 @method showLeaderboard:
 @discussion This method shows Leaderboard
 @param Leaderboard category (string)
 */
- (void)showLeaderboard:(NSString *)leaderboard
{
    GKLeaderboardViewController * leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    [leaderboardViewController setCategory:leaderboard];
    [leaderboardViewController setLeaderboardDelegate:self];
    [self presentModalViewController:leaderboardViewController  animated:YES];
}

/*!
 @method insertCurrentScoreIntoLeaderboard:
 @discussion This method submits a score to a Leaderboard
 @param Leaderboard category (string)
 */
- (void)insertCurrentScoreIntoLeaderboard:(NSString*)leaderboard
{
    int score = [[game objectForKey:@"score"] intValue];
    //NSLog(@"score: %d", score);
    GKScore * submitScore = [[GKScore alloc] initWithCategory:leaderboard];
    [submitScore setValue: score];
    
    [submitScore setShouldSetDefaultLeaderboard:YES];
    
    [submitScore setContext:context++];
    
    [self.player submitScore:submitScore];
}

/*!
 @method highscores:
 @discussion This method is called when highscores button is tapped
 */
-(IBAction) highscores:(id)sender
{
    [[MathsWarManager sharedManager].HUD show:YES];
    self.gcLoginAction = @"scores";
    // Show leaderboard
    /*if( self.player == nil )    {
    
        [self playerAuth];
    }
    else    {
        [self showLeaderboard: SCORE_LEADERBOARD];
    }*/
    
    //[DDGameKitHelper sharedGameKitHelper].shouldShowLeaderboardOnAuth = YES;
    if([[DDGameKitHelper sharedGameKitHelper] isLocalPlayerAuthenticated])  {
        [[DDGameKitHelper sharedGameKitHelper] showLeaderboard];
        self.gcLoginAction = @"";
    }
    else    {
        //[[DDGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
        [self playerAuth];
    }
}

/*!
 @method gameCenter:
 @discussion This method is called when gameCenter button is tapped
 */
-(IBAction) gameCenter:(id)sender
{
    [[MathsWarManager sharedManager].HUD show:YES];
    self.gcLoginAction = @"submitscore";
    /*if( self.player == nil )    {
        
        [self playerAuth];
    }
    else    {
        [self insertCurrentScoreIntoLeaderboard: SCORE_LEADERBOARD];
    }*/
    
    //[DDGameKitHelper sharedGameKitHelper].shouldShowLeaderboardOnAuth = NO;
    int score = [[game objectForKey:@"score"] intValue];
    if([[DDGameKitHelper sharedGameKitHelper] isLocalPlayerAuthenticated])  {
        [[DDGameKitHelper sharedGameKitHelper] submitScore:score category:SCORE_LEADERBOARD];
        self.gcLoginAction = @"";
    }
    else    {
        //[[DDGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
        [self playerAuth];
    }
}

// Check for the availability of Game Center API.
static BOOL isGameCenterAPIAvailable()
{
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

/*!
 @method playerAuth
 @discussion This method is authenticates game center player
 */
- (void) playerAuth
{
    if (!isGameCenterAPIAvailable()) {
        // Game Center is not available.
    } else {
        
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            // If there is an error, do not assume local player is not authenticated.
            [[MathsWarManager sharedManager].HUD hide:YES];
            if (localPlayer.isAuthenticated) {
                
                self.player = [[Player alloc] init];
                //[self.player loadStoredScores];
                //[self.player resubmitStoredScores];
                //[self.btnHighScores setHidden:NO];
                
                if( [self.gcLoginAction isEqualToString:@"scores"] )  {
                    [self highscores:nil];
                }
                else if( [self.gcLoginAction isEqualToString:@"submitscore"] )   {
                    [self gameCenter:nil];
                }
            }
            else {
                
                if ( self.gcLoginAction.length > 0 ) {
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PROJECT_NAME message:@"Player is not authenticated. Please sign in to Game Center." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
                
                self.gcLoginAction = @"";
                //[self.btnHighScores setHidden:YES];
            }
        }];
    }
}

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithGame:(NSDictionary *)_game type:(NSString *)_type
{
    self = [super init];
    if (self) {
        game = _game;
        type = _type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *font = [UIFont fontWithName:@"Futura XBlk BT" size:17];
    [self.lblScore setFont:font];
    [self.lblCoins setFont:font];
    
    font = [UIFont fontWithName:@"Futura XBlk BT" size:14];
    [self.lblLevel setFont:font];
    [self.lblCategory setFont:font];
    UILabel *lblName = (UILabel *)[self.view viewWithTag:1];    [lblName setFont:font];
    UILabel *lblLvl = (UILabel *)[self.view viewWithTag:2];    [lblLvl setFont:font];
    UILabel *lblCat = (UILabel *)[self.view viewWithTag:3];    [lblCat setFont:font];
    
    [self.lblText setFont: [UIFont fontWithName:@"DK Crayon Crumble" size:28]];
    
    [self.lblScore setText:[NSString stringWithFormat:@"%@", [game objectForKey:@"score"]]];
    [self.lblCoins setText:[NSString stringWithFormat:@"%@", [game objectForKey:@"coins"]]];
    
    int level = [[game objectForKey:@"level"] intValue];
    if( ![type isEqualToString:@"LevelFinished"] )
    {
        [self.imgText setImage:[UIImage imageNamed:@"game_over.png"]];
        [self.lblText setText:@"Try again..."];
        [self.btnPlay setImage:[UIImage imageNamed:@"play_again.png"] forState:UIControlStateNormal];
    }
    else if( level == HARD )  {
        [self.btnPlay setImage:[UIImage imageNamed:@"play_again.png"] forState:UIControlStateNormal];
    }
    
    switch ( level ) {
            
        case EASY:
            [self.lblLevel setText:@"Easy"];
            [self.lblLevel setTextColor:[UIColor colorWithRed:(29/255.0) green:(178/255.0) blue:(237/255.0) alpha:1]];
            break;
            
        case MEDIUM:
            [self.lblLevel setText:@"Medium"];
            [self.lblLevel setTextColor:[UIColor colorWithRed:(225/255.0) green:(85/255.0) blue:(50/255.0) alpha:1]];
            break;
            
        case HARD:
            [self.lblLevel setText:@"Hard"];
            [self.lblLevel setTextColor:[UIColor colorWithRed:(94/255.0) green:(174/255.0) blue:(7/255.0) alpha:1]];
            break;
            
        default:        break;
    }
    
    NSString *operation = [game objectForKey:@"operation"];
    if ( [operation isEqualToString:@"+"] ) {
        [self.lblCategory setText:@"Addition"];
    }
    else if ( [operation isEqualToString:@"-"] ) {
        [self.lblCategory setText:@"Subtraction"];
    }
    else if ( [operation isEqualToString:@"x"] ) {
        [self.lblCategory setText:@"Multiplication"];
    }
    else if ( [operation isEqualToString:@"÷"] ) {
        [self.lblCategory setText:@"Division"];
    }
    
    if( is_iPhone_5 ) {
        
        [self.imgText setFrame:CGRectMake(154, 75, 155, 115)];
        [self.logoView setFrame:CGRectMake(2, 65, 138, 138)];
        [self.logoView setImage:[UIImage imageNamed:@"score_logo_5.png"]];
    }
    
    [self twitterSetup];
    
    //[self playerAuth];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.gcLoginAction = @"";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.gcLoginAction = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[[MathsWarManager sharedManager].HUD hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissModalViewControllerAnimated: YES];
}

#pragma mark- SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	//NSLog(@"Authenicated for %@", username);
    [_engine sendUpdate: [self textForSharing]];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	//NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	//NSLog(@"Authentication Canceled.");
}

#pragma mark  TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	//NSLog(@"Request %@ succeeded", requestIdentifier);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PROJECT_NAME message:@"Posted on Twitter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	//NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}

@end
