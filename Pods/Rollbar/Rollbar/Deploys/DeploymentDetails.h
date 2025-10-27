//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>
#import "Deployment.h"

/// Models Deployment details
@interface DeploymentDetails : Deployment

/// Deployment ID
@property (readonly, copy) NSString *deployId;

/// Rollbar project ID
@property (readonly, copy) NSString *projectId;

/// Start time
@property (readonly, copy) NSDate *startTime;

/// End time
@property (readonly, copy) NSDate *endTime;

/// Status
@property (readonly, copy) NSString *status;

@end
