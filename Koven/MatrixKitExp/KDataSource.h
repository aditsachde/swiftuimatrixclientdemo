//
//  KDataSource.h
//  Koven
//
//  Created by Adit Sachde on 1/14/21.
//

#ifndef KDataSource_h
#define KDataSource_h


#endif /* KDataSource_h */

@import MatrixKit;

@interface KDataSource: MXKRoomDataSource
- (NSString*) currentSenderId;
- (NSString*) currentSenderDisplayName;
- (NSInteger) numberOfSections;
- (id<MXKRoomBubbleCellDataStoring>) messageForItem: (int) indexPath;
- (NSArray<id<MXKRoomBubbleCellDataStoring>>*) getBubbles;

@end

@interface MXKRoomDataSource (ReturnBubbles)
- (NSArray<id<MXKRoomBubbleCellDataStoring>>*) getBubbles;
@end
