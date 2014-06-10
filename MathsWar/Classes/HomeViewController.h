//  MathsWar

/*!
 @class HomeViewController
 @superclass UIViewController
 @abstract Shows operations - Addition, subtraction, multiplication, deletion.
 
 @author Pradnya Mankar
 @discussion Created: 16-01-2013
 @updated 12-01-2013
 */

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *bgImgView;
@property (nonatomic, retain) IBOutlet UIImageView *logoImgView;

- (void) presentGame:(NSMutableDictionary *)_game;

@end
