//
//  MathsWarManager.h
//  MathsWar
//
//  Created by Pradnya Mankar on 21/01/13.
//  Copyright (c) 2013 Clarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "MBProgressHUD.h"

@protocol FBDelegate <NSObject>

- (void) userLoggedIn;

@end

@interface MathsWarManager : NSObject <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, MBProgressHUDDelegate>
{
    
}

@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, strong) NSMutableArray *games;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) id<FBDelegate> fbDelegate;

+ (MathsWarManager *)sharedManager;
- (void) initialize;
- (void) saveGames;
- (void) shareScore:(NSString *)message;
- (void) facebookSetup;
- (BOOL) facebookLogin;

@end


