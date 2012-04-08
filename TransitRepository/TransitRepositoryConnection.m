//
//  TransitRepositoryConnection.m
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/05.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

/**
 TransitRepositoryの通信コネクションを請け負うクラス
 
 直接のmasterはTransitRepositoryAdopterになっている。データIDなどの過般/保持/寿命設定を行うクラス。
 NSConnectionのこのシステム用の代替
 */

#import "TransitRepositoryConnection.h"


@implementation TransitRepositoryConnection
- (id) connection:(NSString * )connectionIdentity withMasterName:(NSString * )masterName {
    if (self = [super init]) {
        
        messenger = [[MessengerSystem alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:connectionIdentity];
        [messenger inputParent:masterName];
        
        adopt = [[TransitRepositoryAdopter alloc]initWithMasterName:connectionIdentity];
    }
    return self;
}


- (void) receiver:(NSNotification * )notif {
    NSString * exec = [messenger getExecFromNotification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_CONNECTED]) {
        NSAssert([dict valueForKey:@"result"], @"result required");
        
        [messenger callParent:TRANSIT_CONNECTION_EXEC_CONNECTED, 
         [messenger tag:@"result" val:[dict valueForKey:@"result"]],
         nil];
        
         NSAssert1([self retainCount] == 1, @"not match   %d", [self retainCount]);
        
        [self autorelease];
    }
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_SAVED]) {
        NSAssert([dict valueForKey:@"result"], @"result required");
        
        [messenger callParent:TRANSIT_CONNECTION_EXEC_SAVED, 
         [messenger tag:@"result" val:[dict valueForKey:@"result"]],
         nil];
        
        NSAssert1([self retainCount] == 1, @"not match   %d", [self retainCount]);
        
        [self autorelease];
    }
        
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_LOADED]) {
        NSAssert([dict valueForKey:@"result"], @"result required");
        
        [messenger callParent:TRANSIT_CONNECTION_EXEC_LOADED, 
         [messenger tag:@"result" val:[dict valueForKey:@"result"]],
         nil];
        
        NSAssert1([self retainCount] == 1, @"not match   %d", [self retainCount]);
        
        [self autorelease];
    }
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_DELETED]) {
        NSAssert([dict valueForKey:@"result"], @"result required");
        
        [messenger callParent:TRANSIT_CONNECTION_EXEC_DELETED, 
         [messenger tag:@"result" val:[dict valueForKey:@"result"]],
         nil];
        
        NSAssert1([self retainCount] == 1, @"not match   %d", [self retainCount]);
        
        [self autorelease];
    }
}

/**
 通信開始(開通確認)
 */
- (void) connect {
    [self validateCanUse];
    m_connectionType = [NSNumber numberWithInt:TRANSIT_CONNECTION_TYPE_CONNECT];
    [messenger call:TRANSITREPO_ADOPTER withExec:TRANSITREPO_ADOPTER_EXEC_CONNECT, nil];
}

- (void) save:(NSDictionary * )param withTypeIdentifier:(NSString * )typeIdentifier {
    [self validateCanUse];
    m_connectionType = [NSNumber numberWithInt:TRANSIT_CONNECTION_TYPE_SAVE];
    [messenger call:TRANSITREPO_ADOPTER withExec:TRANSITREPO_ADOPTER_EXEC_SAVE,
     [messenger tag:TRANSITREPO_ADOPTER_KEY_PARAM val:param],
     [messenger tag:TRANSITREPO_ADOPTER_KEY_TYPE val:typeIdentifier],
     nil];
}

- (void) load:(NSDictionary * )param withTypeIdentifier:(NSString * )typeIdentifier {
    [self validateCanUse];
    m_connectionType = [NSNumber numberWithInt:TRANSIT_CONNECTION_TYPE_SAVE];
    [messenger call:TRANSITREPO_ADOPTER withExec:TRANSITREPO_ADOPTER_EXEC_LOAD,
     [messenger tag:TRANSITREPO_ADOPTER_KEY_PARAM val:param],
     [messenger tag:TRANSITREPO_ADOPTER_KEY_TYPE val:typeIdentifier],
     nil];
}

- (void) delete:(NSDictionary * )param withTypeIdentifier:(NSString * )typeIdentifier {
    [self validateCanUse];
    m_connectionType = [NSNumber numberWithInt:TRANSIT_CONNECTION_TYPE_DELETE];
    [messenger call:TRANSITREPO_ADOPTER withExec:TRANSITREPO_ADOPTER_EXEC_DELETE,
     [messenger tag:TRANSITREPO_ADOPTER_KEY_PARAM val:param],
     [messenger tag:TRANSITREPO_ADOPTER_KEY_TYPE val:typeIdentifier],
     nil];
}




/**
 使用可能か不可能かを返す
 */
- (void) validateCanUse {
    NSAssert(messenger, @"sohuld use [- (id) connection:(NSString * )connectionIdentity withMasterName:(NSString * )masterName] to USE this unit");
    NSAssert(!m_connectionType, @"this connection is aleady connected as   %@", m_connectionType);
}

- (void)dealloc {
    NSLog(@"connection release");
    [m_connectionType release];
    [adopt release];
    [messenger release];
    
    [super dealloc];
}




@end
