//
//  MeshTransformApi.h
//  TelegramHighlights
//
//  This source file is derived from Telegram iOS:
//  https://github.com/TelegramMessenger/Telegram-iOS
//
//  Distributed under the terms of the GNU General Public License,
//  version 2 or any later version. See the LICENSE file for details.
//

#ifndef MeshTransformApi_h
#define MeshTransformApi_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct MeshTransformMeshFace {
    unsigned int indices[4];
    float w[4];
} MeshTransformMeshFace;
 
typedef struct MeshTransformPoint3D {
    CGFloat x;
    CGFloat y;
    CGFloat z;
} MeshTransformPoint3D;
 
typedef struct MeshTransformMeshVertex {
    CGPoint from;
    MeshTransformPoint3D to;
} MeshTransformMeshVertex;

@protocol MeshTransformClass <NSObject>

- (id)meshTransformWithVertexCount:(NSUInteger)vertexCount
                                    vertices:(MeshTransformMeshVertex *)vertices
                                   faceCount:(NSUInteger)faceCount
                                       faces:(MeshTransformMeshFace *)faces
                          depthNormalization:(NSString *)depthNormalization;

@end

#endif
