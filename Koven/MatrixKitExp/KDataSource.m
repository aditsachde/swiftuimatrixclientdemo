//
//  KDataSource.m
//  Koven
//
//  Created by Adit Sachde on 1/14/21.
//

#import <Foundation/Foundation.h>
@import MatrixKit;
@import MatrixSDK;

@implementation KDataSource: MXKRoomDataSource

- (NSString*) currentSenderId {
    return self.mxSession.myUser.displayname;
}

- (NSString*) currentSenderDisplayName {
    return self.mxSession.myUserId;
}

- (NSInteger) numberOfSections {
    return bubbles.count;
}

- (id<MXKRoomBubbleCellDataStoring>) messageForItem: (int) indexPath {
    return bubbles[indexPath];
}

- (NSArray<id<MXKRoomBubbleCellDataStoring>>*) getBubbles {
    return bubbles;
}


@end

@implementation MXKRoomDataSource (ReturnBubbles)

- (NSArray<id<MXKRoomBubbleCellDataStoring>>*) getBubbles {
    return bubbles;
}

@end
