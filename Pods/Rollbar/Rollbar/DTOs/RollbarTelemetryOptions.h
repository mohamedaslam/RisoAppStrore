//
//  RollbarTelemetryOptions.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-25.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

@class RollbarScrubbingOptions;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarTelemetryOptions : DataTransferObject

#pragma mark - properties

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL captureLog;
@property (nonatomic) BOOL captureConnectivity;
@property (nonatomic) NSUInteger maximumTelemetryData;
@property (nonatomic, strong) RollbarScrubbingOptions *viewInputsScrubber;

#pragma mark - initializers

- (id)initWithEnabled:(BOOL)enabled
           captureLog:(BOOL)captureLog
  captureConnectivity:(BOOL)captureConnectivity
     viewInputsScrubber:(RollbarScrubbingOptions *)viewInputsScrubber;
- (id)initWithEnabled:(BOOL)enabled
         captureLog:(BOOL)captureLog
  captureConnectivity:(BOOL)captureConnectivity;
- (id)initWithEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
