//
//  TransitRepository.h
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/04.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitRepositoryAdopter.h"

#import "MessengerSystem.h"

#define TRANSIT_REPOSITORY_MASTER   (@"TRANSIT_REPOSITORY_MASTER")
#define TRANSIT_REPOSITORY          (@"TRANSIT_REPOSITORY")

#define TRANSIT_IDENTITY_RULESDICT  (@"TRANSIT_IDENTITY_RULESDICT")

@interface TransitRepository : NSObject {
    MessengerSystem * messenger;
    
    
    NSDictionary * m_rulesDict;
    NSString * m_callback;
}


- (NSString * ) transitRuleInitialize:(NSDictionary * )newRulesDict;
- (void) transitRuleAdopt:(NSString * )callback withTypeIdentifier:(NSString * )identifier;


@end

