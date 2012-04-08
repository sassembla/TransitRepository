//
//  TransitRepositoryAdopter.h
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/02.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessengerSystem.h"

#define TRANSITREPO_ADOPTER (@"TRANSITREPO_ADOPTER")

#define TRANSITREPO_ADOPTER_EXEC_CONNECTED  (@"TRANSITREPO_ADOPTER_EXEC_CONNECTED")
#define TRANSITREPO_ADOPTER_EXEC_SAVED      (@"TRANSITREPO_ADOPTER_EXEC_SAVED")
#define TRANSITREPO_ADOPTER_EXEC_LOADED     (@"TRANSITREPO_ADOPTER_EXEC_LOADED")
#define TRANSITREPO_ADOPTER_EXEC_DELETED    (@"TRANSITREPO_ADOPTER_EXEC_DELETED")

#define TRANSITREPO_ADOPTER_EXEC_CONNECT    (@"TRANSITREPO_ADOPTER_EXEC_CONNECT")
#define TRANSITREPO_ADOPTER_EXEC_SAVE       (@"TRANSITREPO_ADOPTER_EXEC_SAVE")
#define TRANSITREPO_ADOPTER_EXEC_LOAD       (@"TRANSITREPO_ADOPTER_EXEC_LOAD")
#define TRANSITREPO_ADOPTER_EXEC_DELETE     (@"TRANSITREPO_ADOPTER_EXEC_DELETE")

//error
#define TRANSITREPO_ADOPTER_ERRORDOMAIN (@"TRANSITREPO_ADOPTER_ERRORDOMAIN")
#define TRANSITREPO_ADOPTER_ERRORCODE_NONE  (0)


//key
#define TRANSITREPO_ADOPTER_KEY_PARAM   (@"TRANSITREPO_ADOPTER_KEY_PARAM")
#define TRANSITREPO_ADOPTER_KEY_TYPE    (@"TRANSITREPO_ADOPTER_KEY_TYPE")

@interface TransitRepositoryAdopter : NSObject {
    MessengerSystem * messenger;
    
    NSMutableArray * m_deleteArray;
}

- (id) initWithMasterName:(NSString * )masterName;

- (void) connect;
- (void) save:(id)param withTypeIdentity:(NSString * )identity;
- (void) load:(id)param withTypeIdentity:(NSString * )identity;
- (void) delete:(id)param withTypeIdentity:(NSString * )identity;

@end
