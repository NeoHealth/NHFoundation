//
//  NHBTEdgeManager.h
//  NHFoundation
//
//  Created by Leejay Schmidt on 2016-10-15.
//  Copyright © 2016 Leejay Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NHBTEdgeManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic) CBCentralManager *centralManager;

@end
