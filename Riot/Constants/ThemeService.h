/*
 Copyright 2015 OpenMarket Ltd
 Copyright 2017 Vector Creations Ltd
 Copyright 2019 New Vector Ltd

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <MatrixKit/MatrixKit.h>

@protocol Theme;

NS_ASSUME_NONNULL_BEGIN

/**
 Posted when the user interface theme has been changed.
 */
extern NSString *const kThemeServiceDidChangeThemeNotification;

/**
 Convert a RGB hexadecimal value into a UIColor.
 */
#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                     blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                    alpha:1.0]

#pragma mark - Riot Standard Room Member Power Level
extern NSInteger const kRiotRoomModeratorLevel;
extern NSInteger const kRiotRoomAdminLevel;

/**
 `ThemeService` class manages the application design values.
 */
@interface ThemeService : NSObject

/**
 Returns the shared instance.

 @return the shared instance.
 */
+ (instancetype)shared;

/**
 The id of the theme corresponding to the current app settings.
 */
@property (nonatomic, readonly) NSString *themeId;

/**
 The current theme.
 */
@property (nonatomic, readonly) id<Theme> theme;

/**
 Get the theme with the given id.

 @param themeId the theme id.
 @return the theme.
 */
- (id<Theme>)themeWithThemeId:(NSString*)themeId;

#pragma mark - Riot Colors not yet themeable

@property (nonatomic, readonly) UIColor *riotColorPinkRed;
@property (nonatomic, readonly) UIColor *riotColorRed;
@property (nonatomic, readonly) UIColor *riotColorBlue;
@property (nonatomic, readonly) UIColor *riotColorCuriousBlue;
@property (nonatomic, readonly) UIColor *riotColorIndigo;
@property (nonatomic, readonly) UIColor *riotColorOrange;

@end

NS_ASSUME_NONNULL_END
