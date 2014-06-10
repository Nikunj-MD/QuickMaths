//
//  MathsWarManager.m
//  MathsWar
//
//  Created by Pradnya Mankar on 21/01/13.
//  Copyright (c) 2013 Clarion. All rights reserved.
//

#import "MathsWarManager.h"
#import "Facebook.h"
#import "JSON.h"

static NSString* kFBAppId = @"412787258805352";   //MathsWar
//static NSString* kFBAppId = @"331548033598124";   //SwooperDeal
//static NSString* kFBAppId = @"210849718975311";     //Hackbook

@implementation MathsWarManager

@synthesize games, HUD;
@synthesize facebook, userPermissions, permissions, fbDelegate;

static MathsWarManager *sharedColorRhythmsManager = nil;

+ (MathsWarManager *)sharedManager
{
    @synchronized (self) {
        if (sharedColorRhythmsManager == nil) {
            sharedColorRhythmsManager = [[super allocWithZone:NULL] init];
        }
    }
    return sharedColorRhythmsManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void) initialize
{
    self.games = [[NSUserDefaults standardUserDefaults] objectForKey:@"MathsWar_Games"];
    if( self.games == nil ) {
        self.games = [NSMutableArray array];
    }
    
    // Show HUD
    HUD = [[MBProgressHUD alloc] initWithView:APP_DELEGATE.navController.view];
    [APP_DELEGATE.navController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.dimBackground = YES;
    //HUD.labelText = @"Loading";
}

- (void) saveGames
{
    [[NSUserDefaults standardUserDefaults] setObject:self.games forKey:@"MathsWar_Games"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) facebookSetup
{
    self.facebook = [[Facebook alloc] initWithAppId:kFBAppId andDelegate:self] ;
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    // Initialize user permissions
    self.userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1] ;
    self.permissions = [[NSArray alloc] initWithObjects:@"offline_access", nil] ;
}

- (BOOL)facebookLogin
{
    BOOL loggedIn = NO;
    //NSLog(@"self.facebook : %@\npermissions: %@", self.facebook, permissions);
    if (![self.facebook isSessionValid]) {
        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self.facebook authorize: permissions];
    } else {
        loggedIn = YES;
    }
    return loggedIn;
}

#pragma mark  Share on Facebook

- (void)shareScore:(NSString *)message {
    //currentAPICall = kDialogFeedUser;
    SBJSON *jsonWriter = [SBJSON new];
    
    // The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:                                                     @"Get Started", @"name",
                             @"http://www.zingma.com/", @"link", nil],
                            nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    //NSString *pathForImage = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    //NSData *imageData = [NSData dataWithContentsOfFile:pathForImage];
    //UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathForImage];
    
    //UIImage *image = [UIImage imageNamed:@"icon.png"];
    //NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"MathsWar", @"name",
                                   @"Clarion Technologies", @"caption",
                                   message, @"description",
                                   @"http://www.zingma.com/", @"link",
                                   //imageData, @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
    MathsWarManager *sharedManager = [MathsWarManager sharedManager];
    [[sharedManager facebook] dialog:@"feed"
                           andParams:params
                         andDelegate:sharedManager];
    
    /*UIImage *image = [UIImage imageNamed:@"icon.png"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   image, @"picture",
                                   @"Clarion Technologies", @"caption",
                                   message, @"description",
                                   @"http://www.zingma.com/", @"link",
                                   nil];
    
    MathsWarManager *sharedManager = [MathsWarManager sharedManager];
    [[sharedManager facebook] requestWithGraphPath:@"me/photos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];*/
}

#pragma mark  FBRequest delegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    //NSLog(@"FBRequest didFailWithError");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PROJECT_NAME message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
    [HUD hide:YES];
}

#pragma mark FBDialog Delegates

- (void) dialogCompleteWithUrl:(NSURL*) url
{
    //NSLog(@"dialogCompleteWithUrl");
    if ([url.absoluteString rangeOfString:@"post_id="].location != NSNotFound) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PROJECT_NAME message:@"Posted on your timeline!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else {
        
    }
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    //NSLog(@"dialog didFailWithError");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PROJECT_NAME message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void)dialogDidComplete:(FBDialog *)dialog
{
    //NSLog(@"dialogDidComplete: %@", dialog);
}

- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    //NSLog(@"dialogDidNotComplete");
}

#pragma mark FBSession Delegates

- (void)fbDidLogin {
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //NSLog(@"fbDidLogin");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self.fbDelegate userLoggedIn];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    //NSLog(@"fbDidNotLogin cancelled:%d", cancelled);
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    //NSLog(@"fbDidExtendToken");
}

- (void)fbDidLogout
{
    //NSLog(@"fbDidLogout");
}

- (void)fbSessionInvalidated
{
    //NSLog(@"fbSessionInvalidated");
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
