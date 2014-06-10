//  MathsWar

/*!
 @class ScoreViewController
 @superclass UIViewController
 @abstract Shows score and gamecenter highscores
 
 @author Pradnya Mankar
 @discussion Created: 21-02-2013
 @updated 08-03-2013
 */

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "SA_OAuthTwitterController.h"
#import "Player.h"

@interface ScoreViewController : UIViewController <FBDelegate, SA_OAuthTwitterControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    SA_OAuthTwitterEngine *_engine;
    NSDictionary *game;
    NSString *type;
    uint64_t context;
}

@property (nonatomic, retain) IBOutlet UILabel *lblText;
@property (nonatomic, retain) IBOutlet UILabel *lblScore;
@property (nonatomic, retain) IBOutlet UILabel *lblCoins;
@property (nonatomic, retain) IBOutlet UILabel *lblLevel;
@property (nonatomic, retain) IBOutlet UILabel *lblCategory;

@property (nonatomic, retain) IBOutlet UITextField *txtName;
@property (nonatomic, retain) IBOutlet UIImageView *imgText;
@property (nonatomic, retain) IBOutlet UIImageView *logoView;
@property (nonatomic, retain) IBOutlet UIButton *btnPlay;
@property (nonatomic, retain) IBOutlet UIButton *btnHighScores;

// This assists in caching game center data until
@property (readwrite, retain) Player *player;
@property (nonatomic, retain) NSString *gcLoginAction;

- (id)initWithGame:(NSDictionary *)_game type:(NSString *)_type;

@end
