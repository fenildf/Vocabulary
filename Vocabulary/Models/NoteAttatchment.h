//
//  NoteAttatchment.h
//  Vocabulary
//
//  Created by 缪和光 on 2/11/2014.
//  Copyright (c) 2014 缪和光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VBaseModel.h"

@class Note;

@interface NoteAttatchment : VBaseModel

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) Note *note;

@end
