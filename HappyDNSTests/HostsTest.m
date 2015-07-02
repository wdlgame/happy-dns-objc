//
//  HostsTest.m
//  HappyDNS
//
//  Created by bailong on 15/6/30.
//  Copyright (c) 2015年 Qiniu Cloud Storage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QNHosts.h"
#import "QNDomain.h"
#import "QNNetworkInfo.h"

@interface HostsTest : XCTestCase

@end

@implementation HostsTest

- (void)setUp {
	[super setUp];
	// Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

- (void)testQuery {
	QNHosts *hosts = [[QNHosts alloc]init];
	[hosts put:@"hello.qiniu.com" ip:@"1.1.1.1"];
	[hosts put:@"hello.qiniu.com" ip:@"2.2.2.2"];
	[hosts put:@"qiniu.com" ip:@"3.3.3.3"];
	QNNetworkInfo *info = [QNNetworkInfo normal];
	NSArray *array = [hosts query:[[QNDomain alloc] init:@"hello.qiniu.com"] networkInfo:info];
	XCTAssert(array.count == 2, @"Pass");
	XCTAssert([@"1.1.1.1" isEqual:array[0]] || [@"2.2.2.2" isEqual:array[0]], @"PASS");
	XCTAssert([@"1.1.1.1" isEqual:array[1]] || [@"2.2.2.2" isEqual:array[1]], @"PASS");
	XCTAssertNotEqualObjects(array[0], array[1], @"PASS");

	NSArray *r1 = [hosts query:[[QNDomain alloc] init:@"hello.qiniu.com"] networkInfo:info];
	NSArray *r2 = [hosts query:[[QNDomain alloc] init:@"hello.qiniu.com"] networkInfo:info];
	NSArray *r3 = [hosts query:[[QNDomain alloc] init:@"hello.qiniu.com"] networkInfo:info];
    NSArray *r4 = [hosts query:[[QNDomain alloc] init:@"hello.qiniu.com"] networkInfo:info];
	XCTAssertTrue(!([r1 isEqualToArray:r2] && [r1 isEqualToArray:r3] && [r1 isEqualToArray:r4]), @"PASS");
}

- (void)testCnc {
	QNHosts *hosts = [[QNHosts alloc] init];
	[hosts put:@"hello.qiniu.com" ip:@"1.1.1.1"];
	[hosts put:@"hello.qiniu.com" ip:@"2.2.2.2"];
	[hosts put:@"qiniu.com" ip:@"3.3.3.3"];
	[hosts put:@"qiniu.com" ip:@"4.4.4.4" provider:kQNISP_CNC];
	QNNetworkInfo *info = [[QNNetworkInfo alloc] init:kQNMOBILE provider:kQNISP_CNC];
	NSArray *r = [hosts query:[[QNDomain alloc] init:@"qiniu.com"] networkInfo:info];
	XCTAssertTrue(r.count == 1, @"PASS");
	XCTAssertEqual(@"4.4.4.4", r[0]);
	r = [hosts query:[[QNDomain alloc] init:@"qiniu.com"] networkInfo:[QNNetworkInfo normal]];
	XCTAssertTrue(r.count == 1, @"PASS");
	XCTAssertEqual(@"3.3.3.3", r[0]);
}

@end
