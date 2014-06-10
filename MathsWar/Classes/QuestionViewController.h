//  MathsWar

/*!
 @class QuestionViewController
 @superclass UIViewController
 @abstract Shows question, score, coins, time and life.
 
 @author Pradnya Mankar
 @discussion Created: 16-01-2013
 @updated 25-03-2013
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SA_OAuthTwitterController.h"
#import "RRSGlowLabel.h"

@interface QuestionViewController : UIViewController <AVAudioPlayerDelegate>
//, FBDelegate, SA_OAuthTwitterControllerDelegate>
{
    NSTimer *timer;
    NSTimer *updateTimer;
    //SA_OAuthTwitterEngine *_engine;
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *soundPlayer;
    
    UIView *transparentView;
    RRSGlowLabel *lblMessage;
}

@property (nonatomic, retain) IBOutlet UIImageView *bgImgView;
@property (nonatomic, retain) IBOutlet UILabel *lblQuestion;
@property (nonatomic, retain) IBOutlet UILabel *lblScore;
@property (nonatomic, retain) IBOutlet UILabel *lblCoins;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UILabel *lblLife;

@property (nonatomic, retain) IBOutlet UILabel *lblResult;
@property (nonatomic, retain) IBOutlet UIImageView *resultSmiley;
@property (nonatomic, retain) IBOutlet UIImageView *timeBG;

@property (nonatomic, retain) IBOutlet UIImageView *life1;
@property (nonatomic, retain) IBOutlet UIImageView *life2;
@property (nonatomic, retain) IBOutlet UIImageView *life3;
@property (nonatomic, retain) IBOutlet UIView *optionsView;

@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSMutableArray *prevQuestions;
@property (nonatomic, retain) NSMutableArray *options;
@property (nonatomic, retain) NSMutableDictionary *game;
@property (nonatomic, retain) NSMutableArray *bonusQuestions;
@property (nonatomic, readwrite) int pitfallQuestion;

@property (nonatomic, readwrite) NSInteger prevSelection;
@property (nonatomic, readwrite) int failedAttempts;
@property (nonatomic, readwrite) int timeInSec;
@property (nonatomic, readwrite) int questionNumber;
@property (nonatomic, readwrite) int correctQuestions;
@property (nonatomic, readwrite) int operand1;
@property (nonatomic, readwrite) int operand2;
@property (nonatomic, readwrite) int operand3;

- (id)initWithGame:(NSMutableDictionary*)_game;
- (id)initWithGameIndex:(NSInteger)_gameIndex;

@end
