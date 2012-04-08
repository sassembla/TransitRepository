//
//  TransitRepositoryConnection.h
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/05.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessengerSystem.h"

#import "TransitRepositoryAdopter.h"

#define TRANSIT_CONNECTION  (@"TRANSIT_CONNECTION")


//execs
#define TRANSIT_CONNECTION_EXEC_CONNECTED   (@"TRANSIT_CONNECTION_EXEC_CONNECTED")
#define TRANSIT_CONNECTION_EXEC_SAVED       (@"TRANSIT_CONNECTION_EXEC_SAVED")
#define TRANSIT_CONNECTION_EXEC_LOADED      (@"TRANSIT_CONNECTION_EXEC_LOADED")
#define TRANSIT_CONNECTION_EXEC_DELETED     (@"TRANSIT_CONNECTION_EXEC_DELETED")

//types
enum TransitRepositoryConnection_ConnectionType {
    TRANSIT_CONNECTION_TYPE_CONNECT = -1,
    TRANSIT_CONNECTION_TYPE_SAVE,
    TRANSIT_CONNECTION_TYPE_DELETE,
};


@interface TransitRepositoryConnection : NSObject {
    MessengerSystem * messenger;
    TransitRepositoryAdopter * adopt;
    
    NSNumber * m_connectionType;
}
- (id) connection:(NSString * )connectionIdentity withMasterName:(NSString * )masterName;

- (void) connect;
- (void) save:(NSDictionary * )param withTypeIdentifier:(NSString * )typeIdentifier;
- (void) load:(NSDictionary * )param withTypeIdentifier:(NSString * )typeIdentifier;

- (void) validateCanUse;
@end
