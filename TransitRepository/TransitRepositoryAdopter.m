//
//  TransitRepositoryAdopter.m
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/02.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

#import "TransitRepositoryAdopter.h"
#import "TransitRepository.h"

#import <Parse/Parse.h>
#import "MessengerIDGenerator.h"

#import "TimeMine.h"

@interface NSString (RawClassName)

+ (NSString * )rawClassName:(id)obj;

@end

@implementation NSString (RawClassName)

+ (NSString * )rawClassName:(id)obj {
    NSString * currentClassName = NSStringFromClass([obj class]);
    //_を取り除く
    currentClassName = [currentClassName stringByReplacingOccurrencesOfString:@"_" withString:@""];
    
    //NSCFをNSに変える
    currentClassName = [currentClassName stringByReplacingOccurrencesOfString:@"NSCF" withString:@"NS"];
    return currentClassName;
}

@end


/**
 TransitRepositoryのアダプター
 connectionのidentityと挙動をコントロールする。

 非同期のin-outを行う。このクラス自体が各通信ごとに作られる。
 
 */
@implementation TransitRepositoryAdopter

- (id) initWithMasterName:(NSString * )masterName {
    
    if (self = [super init]) {
        messenger = [[MessengerSystem alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:TRANSITREPO_ADOPTER];
        [messenger inputParent:masterName];
        
        [Parse setApplicationId:APPLICATION ID OF PARSE 
                      clientKey:CLIENT KEY OF PARSE];
        
        [TimeMine setTimeMineLocalizedFormat:@"12/04/03 10:21:39" withLimitSec:864000 withComment:@"今回はParseが直書きしてあるが、複数のサービスのカテゴリクラスで対応できるようにしたい。 adoptProtocolで実装すべき。"];//7DF9CBC1-2BE8-46D0-923B-03D466561E53
    }
    return self;
}

- (void) receiver:(NSNotification * )notif {
    NSString * exec = [messenger getExecFromNotification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_CONNECT]) {
        [self connect];
    }
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_SAVE]) {
        NSAssert([dict valueForKey:TRANSITREPO_ADOPTER_KEY_PARAM], @"TRANSITREPO_ADOPTER_KEY_PARAM required");
        NSAssert([dict valueForKey:TRANSITREPO_ADOPTER_KEY_TYPE], @"TRANSITREPO_ADOPTER_KEY_TYPE required");
        
        [self save:[dict valueForKey:TRANSITREPO_ADOPTER_KEY_PARAM] withTypeIdentity:[dict valueForKey:TRANSITREPO_ADOPTER_KEY_TYPE]];
    }
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_LOAD]) {
        NSAssert([dict valueForKey:TRANSITREPO_ADOPTER_KEY_PARAM], @"TRANSITREPO_ADOPTER_KEY_PARAM required");
        NSAssert([dict valueForKey:TRANSITREPO_ADOPTER_KEY_TYPE], @"TRANSITREPO_ADOPTER_KEY_TYPE required");
        
        [self load:[dict valueForKey:TRANSITREPO_ADOPTER_KEY_PARAM] withTypeIdentity:[dict valueForKey:TRANSITREPO_ADOPTER_KEY_TYPE]];
    }
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_DELETE]) {
        NSAssert([dict valueForKey:TRANSITREPO_ADOPTER_KEY_PARAM], @"TRANSITREPO_ADOPTER_KEY_PARAM required");
        NSAssert([dict valueForKey:TRANSITREPO_ADOPTER_KEY_TYPE], @"TRANSITREPO_ADOPTER_KEY_TYPE required");
        
        [self delete:[dict valueForKey:TRANSITREPO_ADOPTER_KEY_PARAM] withTypeIdentity:[dict valueForKey:TRANSITREPO_ADOPTER_KEY_TYPE]];
    }
}

- (void) connect {
    NSString * str = [NSString stringWithFormat:@"connect"];
    PFQuery * query = [PFQuery queryWithClassName:[NSString rawClassName:str]];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(connected:error:)];
}

- (void) save:(id)param withTypeIdentity:(NSString * )identity {
    PFObject * pObj = [PFObject objectWithClassName:[NSString rawClassName:param]];//型の名前
    [pObj setObject:param forKey:identity];//アプリケーション内で一意な名称キー = ruleの中のidentityパラメータ
    [pObj saveInBackgroundWithTarget:self selector:@selector(saved:error:)];
}


- (void) load:(id)param withTypeIdentity:(NSString * )identity {
    PFQuery * query = [PFQuery queryWithClassName:[NSString rawClassName:param]];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(loaded:error:)];
}

- (void) delete:(id)param withTypeIdentity:(NSString * )identity {
    PFQuery * query = [PFQuery queryWithClassName:[NSString rawClassName:param]];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(deleting:error:)];
}


- (void) connected:(NSArray * )data error:(NSError * )error {
    
    NSDictionary * resultDict;
    if (0 < [data count]) {
        resultDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"connected",@"data", nil];
    }
    
    if (error) {
        resultDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                      @"not connected",@"data",
                      error, @"error",
                      nil];
    }
    
    [messenger callParent:TRANSITREPO_ADOPTER_EXEC_CONNECTED, 
     [messenger tag:@"result" val:resultDict],
     nil];
}


- (void) saved:(NSNumber * )data error:(NSError * )error {
    [TimeMine setTimeMineLocalizedFormat:@"12/04/07 17:47:09" withLimitSec:172800 withComment:@"save、正否に関わるパラメータが無い。オフラインとかも。"];//5003B0EF-95EB-42C5-BA68-72BDA7F225CC
    
    NSMutableDictionary * resultDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        data, @"data",
                                        error, @"error",
                                        nil];
    
    [messenger callParent:TRANSITREPO_ADOPTER_EXEC_SAVED, 
     [messenger tag:@"result" val:resultDict],
     nil];
}

- (void) loaded:(NSArray *)data error:(NSError * )error {
    [TimeMine setTimeMineLocalizedFormat:@"12/04/07 17:46:51" withLimitSec:172800 withComment:@"load、正否に関わるパラメータが無い、オフラインも"];//A756EF5A-26FC-4868-AD03-56EB059C78A2
    
    
    
    NSDictionary * resultDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 data, @"data",
                                 error, @"error",
                                 nil];
    
    [messenger callParent:TRANSITREPO_ADOPTER_EXEC_LOADED, 
     [messenger tag:@"result" val:resultDict],
     nil];
}

- (void) deleting:(NSArray *)data error:(NSError * )error {
    m_deleteArray = [[NSMutableArray alloc]init];
    
    for (PFObject * currentData in data) {
        NSString * additionalIdentity = [MessengerIDGenerator getMID];
        [m_deleteArray addObject:additionalIdentity];
        
        [currentData deleteInBackgroundWithTarget:self selector:@selector(deleted:error:)];
    }
    
    if ([m_deleteArray count] == 0) {
        
        [messenger callParent:TRANSITREPO_ADOPTER_EXEC_DELETED,
         [messenger tag:@"result" val:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"no-data", @"data",
                                        @"", @"error",
                                        nil]],
         nil];
    }

}

- (void) deleted:(NSNumber * )result error:(NSError * )error {
    [TimeMine setTimeMineLocalizedFormat:@"12/04/07 17:46:26" withLimitSec:172800 withComment:@"結果の正否が無い、適当"];//95A9C08A-81E5-44AB-8774-AC09293CF224
   
    [m_deleteArray removeLastObject];
    
    if ([m_deleteArray count] == 0) {
        
        [messenger callParent:TRANSITREPO_ADOPTER_EXEC_DELETED, 
         [messenger tag:@"result" val:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"everything deleted", @"data",
                                        @"", @"error",
                                        nil]],
         nil];
    }
}

- (void)dealloc {
    [messenger release];
    [super dealloc];
}

@end