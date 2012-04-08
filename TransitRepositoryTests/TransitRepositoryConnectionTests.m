//
//  TransitRepositoryConnectionTests.h
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/05.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "MessengerSystem.h"

#import "TransitRepositoryConnection.h"
#import "TransitRepositoryAdopter.h"

#define TEST_MASTER (@"TEST_MASTER")
#define TEST_IDENTIFIER (@"TEST_IDENTIFIER")

@interface TransitRepositoryConnectionTests : SenTestCase {
    TransitRepositoryAdopter * adopt;
    MessengerSystem * messenger;// TransitRepositoryがわりのMaster
    NSDictionary * m_result;
}

@end


@implementation TransitRepositoryConnectionTests
- (void) setUp {
    messenger = [[MessengerSystem alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:TEST_MASTER];
}

- (void) tearDown {
    [messenger release];
    [m_result release];
}


- (void) receiver:(NSNotification * )notif {
    NSString * exec = [messenger getExecFromNotification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    if ([exec isEqualToString:TRANSIT_CONNECTION_EXEC_CONNECTED]) {
        NSAssert([dict valueForKey:@"result"], @"result required");
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"result"]];
    }
    
    if ([exec isEqualToString:TRANSIT_CONNECTION_EXEC_SAVED]) {
        NSAssert([dict valueForKey:@"result"], @"result required");
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"result"]];
    }
    
    if ([exec isEqualToString:TRANSIT_CONNECTION_EXEC_LOADED]) {
        NSAssert([dict valueForKey:@"result"], @"result required");
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"result"]];
    }
    
    if ([exec isEqualToString:TRANSIT_CONNECTION_EXEC_DELETED]) {
        NSAssert([dict valueForKey:@"result"], @"result required");
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"result"]];
    }
    
    
}

/**
 接続を行い、適当に答えが帰ってくる
 */
- (void) testConnect {
    
    TransitRepositoryConnection * transitRepoCon = [[TransitRepositoryConnection alloc]
                                                    connection:TEST_IDENTIFIER withMasterName:TEST_MASTER];
    
    [transitRepoCon connect];
    
    int count = [[messenger getLogStore]count];
    while (count == [[messenger getLogStore]count]) {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    
    
    //結果が帰ってくるはず
    STAssertNotNil(m_result, @"is nil   %@", m_result);
}

/**
 消滅確認
 */
- (void) testConnectThenRemove {
    TransitRepositoryConnection * transitRepoCon = [[TransitRepositoryConnection alloc]
                                                    connection:TEST_IDENTIFIER withMasterName:TEST_MASTER];
    
    [transitRepoCon connect];
    
    
    int count = [[messenger getLogStore]count];
    while (count == [[messenger getLogStore]count]) {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    
//    NSLog(@"transitRepoCon  %@", transitRepoCon);//EXC_BAD_ACCESS
}

- (void) testSave {
    TransitRepositoryConnection * transitRepoCon = [[TransitRepositoryConnection alloc]
                                                    connection:TEST_IDENTIFIER withMasterName:TEST_MASTER];

    NSDictionary * saveDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"value", @"key", nil];
    [transitRepoCon save:saveDict withTypeIdentifier:TEST_IDENTIFIER];
    
    int count = [[messenger getLogStore]count];
    while (count == [[messenger getLogStore]count]) {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    
    //結果が帰ってくるはず
    STAssertNotNil(m_result, @"is nil   %@", m_result);
}

- (void) testLoad {
    TransitRepositoryConnection * transitRepoCon = [[TransitRepositoryConnection alloc]
                                                    connection:TEST_IDENTIFIER withMasterName:TEST_MASTER];
    
    NSDictionary * loadDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"value", @"key", nil];
    [transitRepoCon load:loadDict withTypeIdentifier:TEST_IDENTIFIER];
    
    int count = [[messenger getLogStore]count];
    while (count == [[messenger getLogStore]count]) {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    
    //結果が帰ってくるはず
    STAssertNotNil(m_result, @"is nil   %@", m_result);
}

- (void) testDelete {
    TransitRepositoryConnection * transitRepoCon = [[TransitRepositoryConnection alloc]
                                                    connection:TEST_IDENTIFIER withMasterName:TEST_MASTER];
    
    NSDictionary * deleteDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"value", @"key", nil];
    [transitRepoCon load:deleteDict withTypeIdentifier:TEST_IDENTIFIER];
    
    int count = [[messenger getLogStore]count];
    while (count == [[messenger getLogStore]count]) {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    
    //結果が帰ってくるはず
    STAssertNotNil(m_result, @"is nil   %@", m_result);
}


@end
