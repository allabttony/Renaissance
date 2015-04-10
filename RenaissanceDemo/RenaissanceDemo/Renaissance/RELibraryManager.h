//
//  RELibraryManager.h
//  RenaissanceDemo
//
//  Created by Tony on 4/11/15.
//  Copyright (c) 2015 tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

typedef void (^GroupsCompletionBlock)( BOOL success, NSArray *items );

typedef void (^LastItemCompletionBlock)( BOOL success, UIImage *image );

@interface RELibraryManager : NSObject {
    GroupsCompletionBlock _groupsCompletionBlock;
    LastItemCompletionBlock _lastItemCompletionBlock;
}

@property (nonatomic, assign, readonly) BOOL getAllAssets;

@property (nonatomic, copy) ALAssetsLibraryGroupsEnumerationResultsBlock assetGroupEnumerator;

+ (RELibraryManager *) sharedInstance;

- (ALAssetsLibrary *) defaultAssetsLibrary;

- (void) loadLastItemWithBlock:(LastItemCompletionBlock)blockhandler;

- (void) loadGroupsAssetWithBlock:(GroupsCompletionBlock)blockhandler;

@end
