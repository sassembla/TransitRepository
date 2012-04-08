//
//  TransitRepositoryTests.h
//  ShikamusumeAwoniyoshi
//
//  Created by 徹 井上 on 12/04/04.
//  Copyright (c) 2012年 KISSAKI. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

/**
 
 簡易テストの用途として、
 値をアップする/値をロードする
 という役割を使って、リソースの対処を行う。
 httpのアドレスをやりとりするのでもいい。
 使い方を考える。
 
 理想としては、
 <リソース
 ・画像のuploadが簡単
 ・DLキーの設定もupload側から可能
 ・クライアントはDLキーをみてDL勝手に
 といったところ。
 
 <テスト
 ・テストが送り込める
 ・クライアントはテストを実行する
 ・テストを実行した結果が保存される
 
 考え方の基礎は、「中継リポジトリ」という言葉。
 複数のClient間でセッティング値を共有する。
 
 
 
 TransitRepository
 
 transitRuleInitialize
 X transitRewrite
 Transit上にルールを構築する
 
 
 transitRuleAdopt
 Transit上のルールを自分に適応する
 
 
 transitPush
 Transit上に何かをアップする(ルールに基づく)
 
 transitPull
 Transit上のデータと自己のデータを、ルールを元に同期する
 
 transitDelete
 Transit上の何かをルールに基づいて消す
 
 */
#import <SenTestingKit/SenTestingKit.h>
#import "MessengerSystem.h"
#import "TransitRepository.h"


#define TEST_MASTER (@"TEST_MASTER")

#define TEST_CALLBACK_INIT   (@"TEST_CALLBACK_INIT")
#define TEST_CALLBACK_ADOPT (@"TEST_CALLBACK_ADOPT")


@interface TransitRepositoryTests : SenTestCase {
    MessengerSystem * messenger;
    
    TransitRepository * tRepo;
    
    NSDictionary * m_result;
}

@end

@implementation TransitRepositoryTests

- (void) setUp {
    messenger = [[MessengerSystem alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:TRANSIT_REPOSITORY_MASTER];
    tRepo = [[TransitRepository alloc]init];
}

- (void) tearDown {
    [messenger release];
    [tRepo release];
}

- (void) receiver:(NSNotification * ) notif {
    NSString * exec = [messenger getExecFromNotification:notif];
    NSDictionary * dict = [messenger getTagValueDictionaryFromNotification:notif];
    
    if ([exec isEqualToString:TEST_CALLBACK_INIT]) {
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"data"]];
    }
    if ([exec isEqualToString:TEST_CALLBACK_ADOPT]) {
        m_result = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"data"]];
    }
}



//ルール、基礎
- (void) testTransitRuleInitialize {
    STFail(@"not yet implemented");
    //transitへとルールを送り込み、初期化する。
    
    //ルールが構築されていればOK
    //    .transitファイルみたいな扱いで、dotTransit　ていうオブジェクトで制御する。こういうクラス。
    
    
    
    //自己にルールが適応される
    /*
     //既にsavedか、savedならupdateになるのが正しい
     
     
     {
     "rulesVersion": "1.0",
     "rulesIdentity": "testRules",
     "rules": [
     {
     "ruleName": "name",
     "typeIdentity": "NSString",
     "persistPolicy": "readonly"
     }
     ]
     }
     */
    
    
    NSDictionary * ruleDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"name",@"ruleName",
                               @"NSString",@"typeIdentity",
                               @"readonly",@"persistPolicy",
                               nil];
    
    NSArray * ruleArray = [NSArray arrayWithObjects:ruleDict, nil];
    NSDictionary * rulesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"1.2", @"rulesVersion",
                                @"testRules",@"rulesIdentity",
                                ruleArray, @"rules",
                                nil];
//    [tRepo transitRuleInitialize:<#(NSDictionary *)#>];
    
    int currentCount = [[messenger getLogStore]count];
    
    while (currentCount == [[messenger getLogStore]count]) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
    
    //transitが無事に作成されていれば、transitRepoDictオブジェクトが参照できるはず。
    STAssertNotNil([m_result valueForKey:@"rulesVersion"], @"rulesVersion required  %@", [m_result valueForKey:@"rulesVersion"]);
    NSLog(@"m_result    %@", m_result);
    
}

- (void) testTransitRuleAdopt {
    STFail(@"not yet implemented");
    //transitからルールを読み込む。
    //[tRepo transitRuleAdopt:TEST_CALLBACK_ADOPT identity:TEST_MASTER];
    
    int currentCount = [[messenger getLogStore]count];
    
    while (currentCount == [[messenger getLogStore]count]) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
    
    
    //ルールが適応されていればOK
    STAssertNotNil([m_result valueForKey:@"rulesVersion"], @"rulesVersion required  %@", [m_result valueForKey:@"rulesVersion"]);
    NSLog(@"m_result    %@", m_result);
}



//操作系
- (void) testTransitPush {
    //transitへとルールに基づいてデータを送り込み、更新する。
    
    //ルールが構築されていればOK
    STFail(@"not yet implemented");
}

- (void) testTransitPull {
    //transitから、ルールに基づきデータを取得する。
    
    //ルールが構築されていればOK
    STFail(@"not yet implemented");
}

- (void) testTransitDelete {
    //transitへとルールに基づき消去命令を送り込み、データを空(初期値)にする。
    
    STFail(@"not yet implemented");
}






@end
