//
//  NHBTEdgeManager.m
//  NHFoundation
//
//  Created by Leejay Schmidt on 2016-10-15.
//  Copyright © 2016 Leejay Schmidt. All rights reserved.
//

#import "NHBTEdgeManager.h"
#define REBUFFER_COUNT 16

@interface NHBTEdgeManager() {
    dispatch_queue_t btQueue;
}

@property (nonatomic) BOOL isWaitingToScan;
@property (nonatomic) BOOL isScanning;
@property (nonatomic) NSString *serviceId;
@property (nonatomic) NSMutableArray<CBPeripheral *> *edgeDevices;

@end

@implementation NHBTEdgeManager

NSString *const auraServiceId = @"FFEEDDCC-BBAA-9988-7766-554433221100";
NSString *const auraServiceId2 = @"00112233-4455-6677-8899-AABBCCDDEEFF";

- (id)init {
    if (self = [super init]) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                   queue:dispatch_get_main_queue()
                                                                 options:@{CBCentralManagerOptionShowPowerAlertKey:@(NO)}];
    }
    self.isWaitingToScan = NO;
    //self.serviceId = [CBUUID UUIDWithString:@];
    self.edgeDevices = [[NSMutableArray alloc] init];
    self.isScanning = NO;
    return self;
}

- (void)startScanForPeripherals {
    // Determine the state of the peripheral
    if ([self.centralManager state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
        self.isWaitingToScan = YES;
    } else if ([self.centralManager state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        // NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)};
        // [self.centralManager scanForPeripheralsWithServices:nil options:options];
    } else if ([self.centralManager state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
        self.isWaitingToScan = NO;
    } else if ([self.centralManager state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
        self.isWaitingToScan = YES;
    } else if ([self.centralManager state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
        self.isWaitingToScan = NO;
    }
}

#pragma mark - handle scanning and connecting to the objects
- (void)populateEdgeDevicesWithScanForSeconds:(NSTimeInterval)seconds {
    @synchronized (self.edgeDevices) {
        self.edgeDevices = nil;
        self.edgeDevices = [[NSMutableArray alloc] init];
        self.isScanning = YES;
    }
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)};
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
    [NSTimer scheduledTimerWithTimeInterval:seconds repeats:NO block:^(NSTimer *timer) {
        
    }];
}

#pragma mark - CBCentralManagerDelegate
// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the
// information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    dispatch_sync(btQueue, ^{
        @synchronized (self.edgeDevices) {
            [self.edgeDevices addObject:peripheral];
        }
    });
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (self.isWaitingToScan) {
        self.isWaitingToScan = NO;
        [self startScanForPeripherals];
    }
}

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
}

#pragma <#arguments#>

@end

