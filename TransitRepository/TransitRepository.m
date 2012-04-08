//
//  TransitRepository.m
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/04.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

#import "TransitRepository.h"
#import "MessengerIDGenerator.h"
#import "TransitRepositoryConnection.h"

#import "TransitRepositoryAdopter.h"


@implementation TransitRepository


- (id) init {
    if (self = [super init]) {
        messenger = [[MessengerSystem alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:TRANSIT_REPOSITORY];
        [messenger inputParent:TRANSIT_REPOSITORY_MASTER];
    }
    return self;
}


- (void) receiver:(NSNotification * )notif {
    
}

/**
 transitRepo上にrulesを送付する。
 rulesが既にあり、versionが低ければ、上書きを行う。
 */
- (NSString * ) transitRuleInitialize:(NSDictionary * )newRulesDict {
    
    NSString * connectionIdentity = [MessengerIDGenerator getMID];
    
    TransitRepositoryConnection * transitRepoCon = [[TransitRepositoryConnection alloc]
                                                    connection:connectionIdentity withMasterName:TRANSIT_REPOSITORY];
    
    [transitRepoCon save:newRulesDict withTypeIdentifier:TRANSIT_IDENTITY_RULESDICT];
    
    return connectionIdentity;
}



- (void) dealloc {
    [messenger release];
}

@end
