//
//  TransitRepositoryAdopterTests.h
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/02.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "TransitRepositoryAdopter.h"
#import "MessengerSystem.h"

#define TEST_MASTER (@"TEST_MASTER")

#define TEST_OBJECT_IDENTITY    (@"TEST_OBJECT_IDENTITY")

@interface TransitRepositoryAdopterTests : SenTestCase {
    MessengerSystem * messenger;
    TransitRepositoryAdopter * tAdopt;
    
    NSDictionary * m_result;

}

@end

@implementation TransitRepositoryAdopterTests

- (void) setUp {
    messenger = [[MessengerSystem alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:TEST_MASTER];
    
    tAdopt = [[TransitRepositoryAdopter alloc] initWithMasterName:TEST_MASTER];
}

- (void) tearDown {
    [messenger release];
    [tAdopt release];
}


- (void) receiver:(NSNotification * ) notif {
    NSString * exec = [messenger getExecFromNotification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_SAVED]) {
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"result"]];
    }
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_LOADED]) {
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"result"]];
    }
    
    if ([exec isEqualToString:TRANSITREPO_ADOPTER_EXEC_DELETED]) {
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"result"]];
    }
    
    
}

/**
 adoptしているPersistentシステム/サービスに接続する為の要素としてのCRUD
 */
- (void) testSaveParam {
    NSString * str = [[NSString alloc]initWithFormat:@"date_%@", [NSDate date]];
    
    [tAdopt save:str withTypeIdentity:TEST_OBJECT_IDENTITY];
    
    int currentCount = [[messenger getLogStore]count];
    
    while (currentCount == [[messenger getLogStore]count]) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
    
    STAssertNotNil(m_result, @"m_result is nil  %@", m_result);
    STAssertNotNil([m_result valueForKey:@"data"], @"result required    %@", [m_result valueForKey:@"result"]);
    
    NSLog(@"m_result    %@", m_result);
}

- (void) testLoadParam {
    NSString * str = [[NSString alloc]initWithFormat:@"date_%@", [NSDate date]];
    
    [tAdopt load:str withTypeIdentity:TEST_OBJECT_IDENTITY];
    
    int currentCount = [[messenger getLogStore]count];
    
    while (currentCount == [[messenger getLogStore]count]) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
    
    STAssertNotNil(m_result, @"m_result is nil  %@", m_result);
    STAssertNotNil([m_result valueForKey:@"data"], @"result required    %@", [m_result valueForKey:@"result"]);
    
    NSLog(@"m_result    %@", m_result);
}

- (void) testDeleteParam {
    NSString * str = [[NSString alloc]initWithFormat:@"date_%@", [NSDate date]];
    [tAdopt delete:str withTypeIdentity:TEST_OBJECT_IDENTITY];
    
    int currentCount = [[messenger getLogStore]count];
    
    while (currentCount == [[messenger getLogStore]count]) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
    STAssertNotNil(m_result, @"m_result is nil  %@", m_result);
    STAssertNotNil([m_result valueForKey:@"data"], @"result required    %@", [m_result valueForKey:@"result"]);
    
    NSLog(@"m_result    %@", m_result);
}




@end
