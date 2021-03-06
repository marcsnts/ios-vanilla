// Generated by Apple Swift version 4.0 effective-3.2 (swiftlang-900.0.65 clang-900.0.37)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_attribute(external_source_symbol)
# define SWIFT_STRINGIFY(str) #str
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name) _Pragma(SWIFT_STRINGIFY(clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in=module_name, generated_declaration))), apply_to=any(function, enum, objc_interface, objc_category, objc_protocol))))
# define SWIFT_MODULE_NAMESPACE_POP _Pragma("clang attribute pop")
#else
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name)
# define SWIFT_MODULE_NAMESPACE_POP
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import ObjectiveC;
@import Foundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

SWIFT_MODULE_NAMESPACE_PUSH("FlybitsKernelSDK")
@class NSDictionary;

SWIFT_CLASS("_TtC16FlybitsKernelSDK19AbstractContentData")
@interface AbstractContentData : NSObject
@property (nonatomic, copy) NSDate * _Nonnull dateAdded;
@property (nonatomic, copy) NSDate * _Nonnull dateModified;
@property (nonatomic, copy) NSString * _Nullable summary;
@property (nonatomic) NSInteger id;
@property (nonatomic, copy) NSLocale * _Nonnull locale;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull availableLocales;
@property (nonatomic, copy) NSString * _Nullable title;
- (nullable instancetype)initWithDictionary:(NSDictionary * _Nonnull)dictionary OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UIImage;
@class FlybitsRequest;

/// The <code>Content</code> class is responsible for defining necessary requests
/// that allows fetching or updating <code>ContentData</code>.
SWIFT_CLASS("_TtC16FlybitsKernelSDK7Content")
@interface Content : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull identifier;
@property (nonatomic, readonly, copy) NSString * _Nullable tenantId;
@property (nonatomic, readonly, copy) NSString * _Nullable templateId;
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nullable labels;
@property (nonatomic, readonly, copy) NSString * _Nullable iconUrl;
@property (nonatomic, readonly, strong) UIImage * _Nullable iconImage;
- (nullable instancetype)initWithResponseData:(id _Nonnull)responseData OBJC_DESIGNATED_INITIALIZER;
/// The <code>getInstance</code> method is responsible for fetching a single content instance.
/// This method does not request or fill in <code>ContentData</code> associated to <code>Content</code>.
/// \param id A string identifier for a <code>Content</code> instance
///
/// \param completion A completion handler that returns a <code>Content</code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)getInstanceWithInstanceId:(NSString * _Nonnull)instanceId completion:(void (^ _Nonnull)(Content * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>add</code> method is responsible for adding a single <code>Content</code> object. Before
/// adding content, it’s useful to associate all Content Data IDs you wish to exist
/// as part of this content using the <code>content</code> property on <code>Content</code>.
/// \param experience An <code>Content</code> object
///
/// \param completion A completion handler that returns a <code>Content</code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)addInstance:(Content * _Nonnull)content completion:(void (^ _Nonnull)(Content * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>update</code> method is responsible for updating a single <code>Content</code> object. Before
/// issuing an update, remember to set the <code>content</code> property with all associated <code>Content</code>.
/// \param content An <code>Content</code> object
///
/// \param completion A completion handler that returns a <code>Content</code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)updateInstance:(Content * _Nonnull)content completion:(void (^ _Nonnull)(Content * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>delete</code> method is responsible for deleting a single <code>Experience</code> object. Deleting an
/// experience will not delete any content that may already be associated with it using the <code>contentIds</code>
/// property.
/// \param id A string identifier for an <code>Content</code> object
///
/// \param completion A completion handler that returns an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)deleteInstanceWithId:(NSString * _Nonnull)id completion:(void (^ _Nonnull)(NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// Deletes content data from a given Content identifier.
/// \param dataId A string identifier for a <code>ContentData</code> instance
///
/// \param instanceId A string identifier for a <code>Content</code> instance
///
/// \param completion A completion handler that returns a <code>Content</code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)deleteDataWithDataId:(NSString * _Nonnull)dataId instanceId:(NSString * _Nonnull)instanceId completion:(void (^ _Nonnull)(NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// Use this to create a dictionary representation of this Content object. Used for
/// converting to JSON when adding or updating data on the server.
- (NSDictionary<NSString *, id> * _Nullable)toDictionaryAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// The <code>ContentData</code> class is responsible for defining base model
/// for parsing content data.
SWIFT_CLASS("_TtC16FlybitsKernelSDK11ContentData")
@interface ContentData : NSObject
@property (nonatomic, readonly, copy) NSString * _Nullable identifier;
@property (nonatomic, copy) NSString * _Nullable contentInstanceId;
- (NSDictionary<NSString *, id> * _Nullable)toDictionaryAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// The <code>Experience</code> class is a container for <code>Content Instance</code>s.
SWIFT_CLASS("_TtC16FlybitsKernelSDK10Experience")
@interface Experience : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull identifier;
@property (nonatomic, readonly, copy) NSString * _Nullable tenantId;
@property (nonatomic, readonly, copy) NSString * _Nullable ruleId;
@property (nonatomic, readonly, copy) NSString * _Nullable creatorId;
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nullable contentIds;
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nullable groupIds;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> * _Nullable rule;
@property (nonatomic, readonly, copy) NSArray<Content *> * _Nullable contents;
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nullable labels;
@property (nonatomic, readonly) BOOL isActive;
@property (nonatomic, readonly) double createdAt;
@property (nonatomic, readonly) double modifiedAt;
- (nullable instancetype)initWithResponseData:(id _Nonnull)responseData OBJC_DESIGNATED_INITIALIZER;
/// The <code>get</code> method is responsible for fetching a single <code>Experience</code> object. This
/// method does not request or fill in <code>Content</code> associated to <code>Experience</code>.
/// You must do this with a second request using <code>Content</code> static functions.
/// \param id A string identifier for an <code>Experience</code> object
///
/// \param completion A completion handler that returns a <code>Paged<Experience></code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)getWithId:(NSString * _Nonnull)id completion:(void (^ _Nonnull)(Experience * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>add</code> method is responsible for adding a single <code>Experience</code> object. Before
/// adding an experience, it’s useful to associate all Content IDs you wish to exist
/// as part of this experience using the <code>contentIds</code> property on <code>Experience</code>.
/// \param experience An <code>Experience</code> object
///
/// \param completion A completion handler that returns a <code>Experience</code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)add:(Experience * _Nonnull)experience completion:(void (^ _Nonnull)(Experience * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>update</code> method is responsible for updating a single <code>Experience</code> object. Before
/// issuing an update, remember to set the <code>contentIds</code> property with all associated <code>Content</code>.
/// \param experience An <code>Experience</code> object
///
/// \param completion A completion handler that returns a <code>Experience</code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)update:(Experience * _Nonnull)experience completion:(void (^ _Nonnull)(Experience * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>delete</code> method is responsible for deleting a single <code>Experience</code> object. Deleting an
/// experience will not delete any content that may already be associated with it using the <code>contentIds</code>
/// property.
/// \param id A string identifier for an <code>Experience</code> object
///
/// \param completion A completion handler that returns an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)deleteWithId:(NSString * _Nonnull)id completion:(void (^ _Nonnull)(NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// Use this to create a dictionary representation of this Experience object. Used for
/// converting to JSON when adding or updating data on the server.
- (NSDictionary<NSString *, id> * _Nullable)toDictionaryAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// The <code>Group</code> class is a container for <code>Content Instance</code>s.
SWIFT_CLASS("_TtC16FlybitsKernelSDK5Group")
@interface Group : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull identifier;
@property (nonatomic, readonly, copy) NSString * _Nullable tenantId;
@property (nonatomic, readonly, copy) NSString * _Nullable creatorId;
@property (nonatomic, readonly, copy) NSArray<Experience *> * _Nullable experiences;
@property (nonatomic, readonly) double createdAt;
@property (nonatomic, readonly) double modifiedAt;
- (nullable instancetype)initWithResponseData:(id _Nonnull)responseData OBJC_DESIGNATED_INITIALIZER;
/// The <code>get</code> method is responsible for fetching a single <code>Group</code> object. This
/// method does not request or fill in <code>Experience</code>s associated to a <code>Group</code>.
/// You must do this with a second request using <code>Experience</code> static functions.
/// \param id A string identifier for a <code>Group</code> object
///
/// \param completion A completion handler that returns a <code>Paged<Group></code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)getWithId:(NSString * _Nonnull)id completion:(void (^ _Nonnull)(Group * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>add</code> method is responsible for adding a single <code>Group</code> object. Before
/// adding a group, it’s useful to associate all Experience IDs you wish to exist
/// as part of this group using the <code>experiences</code> property on <code>Group</code>.
/// \param experience An <code>Group</code> object
///
/// \param completion A completion handler that returns a <code>Group</code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)add:(Group * _Nonnull)group completion:(void (^ _Nonnull)(Group * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>update</code> method is responsible for updating a single <code>Group</code> object. Before
/// issuing an update, remember to set the <code>experiences</code> property with all associated <code>Experience</code>s.
/// \param experience A <code>Group</code> object
///
/// \param completion A completion handler that returns a <code>Group</code> response on success or an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)update:(Group * _Nonnull)group completion:(void (^ _Nonnull)(Group * _Nullable, NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// The <code>delete</code> method is responsible for deleting a single <code>Group</code> object. Deleting a
/// group will not delete any experiences that may already be associated with it using the <code>experiences</code>
/// property.
/// \param id A string identifier for a <code>Group</code> object
///
/// \param completion A completion handler that returns an <code>NSError</code> on failure
///
///
/// returns:
/// A cancellable FlybitsRequest or nil if unauthenticated user
+ (FlybitsRequest * _Nullable)deleteWithId:(NSString * _Nonnull)id completion:(void (^ _Nonnull)(NSError * _Nullable))completion SWIFT_WARN_UNUSED_RESULT;
/// Use this to create a dictionary representation of this Group object. Used for
/// converting to JSON when adding or updating data on the server.
- (NSDictionary<NSString *, id> * _Nullable)toDictionaryAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class User;
@class NSCoder;

/// The <code>KernelScope</code> class is responsible for managing Content options when initializing
/// the Kernel SDK. This is a primary step to configure and define attributes that are required for
/// content processing.
SWIFT_CLASS("_TtC16FlybitsKernelSDK11KernelScope")
@interface KernelScope : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) BOOL authenticated;)
+ (BOOL)authenticated SWIFT_WARN_UNUSED_RESULT;
/// Scope name for the Context SDK
@property (nonatomic, readonly, copy) NSString * _Nonnull scopeName;
/// Gets called on successfully connecting to the IDP
- (void)onConnectedWithUser:(User * _Nonnull)user;
/// Gets called on disconnecting from the IDP
- (void)onDisconnectedWithJwtToken:(NSString * _Nonnull)jwtToken;
/// Gets called when a user account gets destroyed
- (void)onAccountDestroyedWithJwtToken:(NSString * _Nonnull)jwtToken;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_MODULE_NAMESPACE_POP
#pragma clang diagnostic pop
