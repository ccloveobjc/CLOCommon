//
//  CLOBlockHelper.h
//  CLOCommon
//
//  Created by TT on 2018/4/10.
//

#import <Foundation/Foundation.h>

#if DEBUG
    #define CLO_keywordify autoreleasepool{}
#else
    #define CLO_keywordify try{}@catch(...){}
#endif

#define CLOWeakify(x) CLO_keywordify __weak __typeof__(x) x##_weak_ = x;

#define CLOStrongify(x) CLO_keywordify \
                        _Pragma("clang diagnostic push") \
                        _Pragma("clang diagnostic ignored \"-Wshadow\"") \
                        __strong __typeof__(x) x = x##_weak_; \
                        _Pragma("clang diagnostic pop")

#define CLOWS CLOWeakify(self);
#define CLOSS CLOStrongify(self);

@interface CLOBlockHelper : NSObject

@end

/*
     As a local variable:
         returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
 
     As a property:
         @property (nonatomic, copy, nullability) returnType (^blockName)(parameterTypes);
 
     As a method parameter:
         - (void)someMethodThatTakesABlock:(returnType (^nullability)(parameterTypes))blockName;
 
     As an argument to a method call:
         [someObject someMethodThatTakesABlock:^returnType (parameters) {...}];
 
     As a typedef:
         typedef returnType (^TypeName)(parameterTypes);
         TypeName blockName = ^returnType(parameters) {...};
 */
