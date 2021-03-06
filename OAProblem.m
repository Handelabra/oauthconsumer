//
//  OAProblem.m
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 03/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import "OAProblem.h"

static NSString* const signature_method_rejected = @"signature_method_rejected";
static NSString* const parameter_absent = @"parameter_absent";
static NSString* const version_rejected = @"version_rejected";
static NSString* const consumer_key_unknown = @"consumer_key_unknown";
static NSString* const token_rejected = @"token_rejected";
static NSString* const signature_invalid = @"signature_invalid";
static NSString* const nonce_used = @"nonce_used";
static NSString* const timestamp_refused = @"timestamp_refused";
static NSString* const token_expired = @"token_expired";
static NSString* const token_not_renewable = @"token_not_renewable";

@implementation OAProblem

@synthesize problem;

- (id)initWithPointer:(NSString *) aPointer
{
	self = [super init];
	if (self != nil) {
		problem = [aPointer retain];
	}
	
	return self;
}

/* looks up the valid shared problems, and sets self.problem to the result if found. otherwise, sets self.problem to nil. */
- (void)setProblemToValidProblem:(NSString *)aProblem
{
	NSUInteger idx = [[OAProblem validProblems] indexOfObject:aProblem];
	if (idx == NSNotFound) {
		[problem release], problem = nil;
		return;
	}

	NSString * next = [[[OAProblem validProblems] objectAtIndex:idx] retain];
	[problem release], problem = nil;
	problem = next;	
}

- (id)initWithProblem:(NSString *)aProblem
{
	self = [super init];
	if (self != nil) {
		[self setProblemToValidProblem:aProblem];
		if (problem == nil) {
			[self release];
			return nil;
		}
	}

	return self;
}
	
- (id)initWithResponseBody:(NSString *) response
{
	self = [super init];
	if (self != nil) {
		NSArray *fields = [response componentsSeparatedByString:@"&"];
		for (NSString *field in fields) {
			if ([field hasPrefix:@"oauth_problem="]) {
				NSString *value = [[field componentsSeparatedByString:@"="] objectAtIndex:1];
				[self setProblemToValidProblem:value];
				if (problem == nil) {
					[self release];
					return nil;
				}
				
				return self;
			}
		}
		[self release];
	}

	return nil;
}

+ (OAProblem *)problemWithResponseBody:(NSString *) response
{
	return [[[OAProblem alloc] initWithResponseBody:response] autorelease];
}

- (void)dealloc
{
	[problem release], problem = nil;
	[super dealloc];
}

+ (NSArray *)validProblems
{
	static NSArray *array;
	if (!array) {
		array = [[NSArray alloc] initWithObjects:signature_method_rejected,
										parameter_absent,
										version_rejected,
										consumer_key_unknown,
										token_rejected,
										signature_invalid,
										nonce_used,
										timestamp_refused,
										token_expired,
										token_not_renewable,
										nil];
	}
	
	return array;
}

- (BOOL)isEqualToProblem:(OAProblem *) aProblem
{
	return [problem isEqualToString:(NSString *)aProblem->problem];
}

- (BOOL)isEqualToString:(NSString *) aProblem
{
	return [problem isEqualToString:(NSString *)aProblem];
}

- (BOOL)isEqualTo:(id) aProblem
{
	if ([aProblem isKindOfClass:[NSString class]]) {
		return [self isEqualToString:aProblem];
	}
		
	if ([aProblem isKindOfClass:[OAProblem class]]) {
		return [self isEqualToProblem:aProblem];
	}
	
	return NO;
}

- (int)code {
	return [[[self class] validProblems] indexOfObject:problem];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"OAuth Problem: %@", (NSString *)problem];
}

#pragma mark class_methods

+ (OAProblem *)SignatureMethodRejected
{
	return [[[OAProblem alloc] initWithPointer:signature_method_rejected] autorelease];
}

+ (OAProblem *)ParameterAbsent
{
	return [[[OAProblem alloc] initWithPointer:parameter_absent] autorelease];
}

+ (OAProblem *)VersionRejected
{
	return [[[OAProblem alloc] initWithPointer:version_rejected] autorelease];
}

+ (OAProblem *)ConsumerKeyUnknown
{
	return [[[OAProblem alloc] initWithPointer:consumer_key_unknown] autorelease];
}

+ (OAProblem *)TokenRejected
{
	return [[[OAProblem alloc] initWithPointer:token_rejected] autorelease];
}

+ (OAProblem *)SignatureInvalid
{
	return [[[OAProblem alloc] initWithPointer:signature_invalid] autorelease];
}

+ (OAProblem *)NonceUsed
{
	return [[[OAProblem alloc] initWithPointer:nonce_used] autorelease];
}

+ (OAProblem *)TimestampRefused
{
	return [[[OAProblem alloc] initWithPointer:timestamp_refused] autorelease];
}

+ (OAProblem *)TokenExpired
{
	return [[[OAProblem alloc] initWithPointer:token_expired] autorelease];
}

+ (OAProblem *)TokenNotRenewable
{
	return [[[OAProblem alloc] initWithPointer:token_not_renewable] autorelease];
}
					  
@end
