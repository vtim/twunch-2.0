//
//  TwunchAPI.m
//  twunch
//
//  Created by Jelle Vandebeeck on 17/06/13.
//  Copyright (c) 2013 fousa. All rights reserved.
//

#import "AFXMLRequestOperation.h"

#import "TwunchAPI.h"

#import "Participant.h"
#import "Twunch.h"

#import "NSString+Parsing.h"
#import "NSDate+Formatting.h"

@interface TwunchAPI () <NSXMLParserDelegate>
@end

@implementation TwunchAPI {
    NSMutableString *_currentString;
    
    NSMutableDictionary *_twunches;
    Twunch *_twunch;
    
    NSMutableArray *_participants;
    Participant *_participant;
    
    void (^_callback)(BOOL success);
}

#pragma mark - Init

+ (void)fetchWithCompletion:(void(^)(BOOL success))completionHandler {
    [[self new] fetchWithCompletion:completionHandler];
}

- (void)fetchWithCompletion:(void(^)(BOOL success))completionHandler {
    _callback = completionHandler;
    
    __weak __typeof(&*self)weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kRSSURL]];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *parser) {
        parser.delegate = self;
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        [weakSelf didError];
    }];
    [operation start];
}

#pragma mark - Parse

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(_currentString) [_currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [self didError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
    [self didError];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    _twunches = [NSMutableDictionary new];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _currentString = [NSMutableString new];
    
	if ([elementName isEqualToString:@"twunch"]) {
		_twunch = [Twunch new];
	}
    
	if([elementName isEqualToString:@"participants"]) {
		_participants = [NSMutableArray array];
	}
    
	if([elementName isEqualToString:@"participant"]) {
		_participant = [Participant new];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (_twunch) {
        if ([elementName isEqualToString:@"title"]) {
            _twunch.name = _currentString;
        }
        
        if([elementName isEqualToString:@"link"]) {
            _twunch.URL = _currentString;
        }
        
        if([elementName isEqualToString:@"address"]) {
            _twunch.address = _currentString;
        }
        
        if([elementName isEqualToString:@"note"]) {
            _twunch.note = _currentString;
        }
        
        if([elementName isEqualToString:@"closed"]) {
            _twunch.closed = [_currentString isEqualToString:@"true"];
        }
        
        if ([elementName isEqualToString:@"date"]) {
            _twunch.date = [_currentString date];
        }
        
        if([elementName isEqualToString:@"latitude"]) {
            _twunch.latitude = [_currentString floatValue];
        }
        
        if([elementName isEqualToString:@"longitude"]) {
            _twunch.longitude = [_currentString floatValue];
        }
        
        if ([elementName isEqualToString:@"twunch"]) {
            NSString *dateKey = [_twunch.date monthFormat];
            if (_twunches[dateKey] == nil) {
                _twunches[dateKey] = [NSMutableArray new];
            }
            [_twunches[dateKey] addObject:_twunch];
            _twunch = nil;
        }
    }
    
	if (_participant) {
        if([elementName isEqualToString:@"participant"]) {
            _participant.twitterHandle = _currentString;
            [_participants addObject:_participant];
            _participant = nil;
        }
    }
    
    if (_participants) {
        if ([elementName isEqualToString:@"participants"]) {
            _twunch.participants = _participants;
            _participants = nil;
        }
    }
    
    _currentString = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self didSuccess];
}

#pragma mark - Complete

- (void)didSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_twunches != nil) {
            twunchapp.twunches = _twunches;
        }
        
        _callback(YES);
    });
}

- (void)didError {
    dispatch_async(dispatch_get_main_queue(), ^{
        _callback(NO);
    });
}

@end