//
//  CoreDataAPI.h
//  WeatherApp
//
//  Created by tang bin on 13-4-13.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataAPI : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(CoreDataAPI *)defaultCoreDataAPI;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
