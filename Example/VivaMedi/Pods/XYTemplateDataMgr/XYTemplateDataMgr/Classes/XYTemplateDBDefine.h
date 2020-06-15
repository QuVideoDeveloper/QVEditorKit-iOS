//
//  XYTemplateDBDefine.h
//  XYTemplateDataMgr
//
//  Created by hzy on 2019/8/21.
//

#ifndef XYTemplateDBDefine_h
#define XYTemplateDBDefine_h

//official template database
#define APP_TEMPLATE_DATABASE_NAME                @"template.db"


//key
#define PREF_KEY_PREINSTLLED_TEMPLATE_VERSION           @"pref_preinstalled_template_version"
#define PREF_KEY_PREINSTLLED_TEMPLATE_FINISH            @"pref_preinstalled_template_finish"
#define PREF_KEY_COPY_PRE_DOWNLOAD_TEMPLATE_FINISH      @"pref_copy_pre_download_template_finish"

#define PREF_VALUE_NO                                   @"no"
#define PREF_VALUE_YES                                  @"yes"


#define APP_TEMPLATE_EXT                        @".xyt"




#define TBL_NAME_TEMPLATE              @"Template"


#pragma mark - Field for template table
#define TEMPLATE_ID                     @"template_id"
#define TEMPLATE_TITLE                  @"title"
#define TEMPLATE_DESCRIPTION            @"description"
#define TEMPLATE_POINTS                 @"points"
#define TEMPLATE_PRICE                  @"price"
#define TEMPLATE_LOGO                   @"logo"
#define TEMPLATE_URL                    @"url"
//template type0:origin1:download...
#define TEMPLATE_FROM_TYPE              @"from_type"
#define TEMPLATE_ORDERNO                @"orderno"
#define TEMPLATE_VERSION                @"ver"
#define TEMPLATE_UPDATETIME             @"updatetime"
#define TEMPLATE_FAVORITE               @"favorite"
#define TEMPLATE_EXT_INFO               @"extInfo"
#define TEMPLATE_LAYOUT_FLAG            @"layout"
#define TEMPLATE_SUB_ORDERNO            @"suborder"
#define TEMPLATE_CONFIGURE_COUNT        @"configureCount"
#define TEMPLATE_DOWNLOAD_FLAG          @"downFlag"//dummy 1, real 0
#define TEMPLATE_MISSION                @"mission"
#define TEMPLATE_MISSION_RESULT         @"mresult"
#define TEMPLATE_DEL_FLAG               @"delFlag"
#define TEMPLATE_SCENECODE              @"scene_code"
#define TEMPLATE_APP_FLAG               @"appFlag"



#warning -- todo 素材缩略图的宽高的设置
//#ifdef FOR_AUTOEDIT
//#define TEMPLATE_THUMBNAIL_WIDTH                320
//#define TEMPLATE_THUMBNAIL_HEIGHT               416
//#else
//#define TEMPLATE_THUMBNAIL_WIDTH                160
//#define TEMPLATE_THUMBNAIL_HEIGHT               160
#define TEMPLATE_THUMBNAIL_WIDTH                160
#define TEMPLATE_THUMBNAIL_HEIGHT               160



#pragma mark - BUNDLE PATH DEF
#define APP_BUNDLE_DIRECTORY         \
[[NSBundle mainBundle] resourcePath]

#define APP_BUNDLE_PRIVATE_PATH         \
[NSString stringWithFormat:@"%@/private",APP_BUNDLE_DIRECTORY]

#define APP_BUNDLE_FONTS_PATH         \
[NSString stringWithFormat:@"%@/private/fonts",APP_BUNDLE_DIRECTORY]

//define new default bundle template path
#define APP_BUNDLE_EFFECTS_PATH          \
[NSString stringWithFormat:@"%@/imageeffect/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_POSTERS_PATH          \
[NSString stringWithFormat:@"%@/poster/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_BUBBLES_PATH          \
[NSString stringWithFormat:@"%@/bubbleframe/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_THEMES_PATH          \
[NSString stringWithFormat:@"%@/theme/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_TEXTFRAMES_PATH          \
[NSString stringWithFormat:@"%@/textframe/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_COVERS_PATH          \
[NSString stringWithFormat:@"%@/cover/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_TRANSITIONS_PATH          \
[NSString stringWithFormat:@"%@/transition/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_ANIMATED_FRAME_PATH          \
[NSString stringWithFormat:@"%@/animateframe/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_MUSIC_PATH          \
[NSString stringWithFormat:@"%@/defaultmusic/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_SOUND_EFFECT_PATH          \
[NSString stringWithFormat:@"%@/sounds/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_PIP_PATH          \
[NSString stringWithFormat:@"%@/pip/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_STICKER_PATH          \
[NSString stringWithFormat:@"%@/sticker/",APP_BUNDLE_PRIVATE_PATH]

//路径相关
#define APP_HOME_PATH  NSHomeDirectory()

#define APP_DOCUMENT_DIRECTORY         \
[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]

#define APP_DATA_PATH               \
[NSString stringWithFormat:@"%@/data/templateworkfolder",APP_DOCUMENT_DIRECTORY]

#define APP_PRIVATE_PATH               \
[NSString stringWithFormat:@"%@/private",APP_DOCUMENT_DIRECTORY]

#define APP_TEMP_PATH          \
[NSString stringWithFormat:@"%@/temp/",APP_DATA_PATH]

#define APP_APPLICATION_SUPPORT_PATH      \
[NSString stringWithFormat:@"%@/Library/Application Support",APP_HOME_PATH]

#define APP_TEMPLATES_PATH          \
[NSString stringWithFormat:@"%@/data/newtemplates",APP_APPLICATION_SUPPORT_PATH]

#define APP_FONTS_PATH          \
[NSString stringWithFormat:@"%@/data/fonts",APP_APPLICATION_SUPPORT_PATH]

#define APP_TEMPLATES_LOGO_PATH          \
[NSString stringWithFormat:@"%@/data/logo",APP_DOCUMENT_DIRECTORY]

#define APP_DOWNLOAD_BASE_FULL_PATH         \
[NSString stringWithFormat:@"%@/Library/Caches",APP_HOME_PATH]

#define APP_TEMPLATES_DOWNLOAD_PATH          \
[NSString stringWithFormat:@"%@/Template/templates",APP_DOWNLOAD_BASE_FULL_PATH]

#define APP_BUNDLE_DIVA_PATH          \
[NSString stringWithFormat:@"%@/diva/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_PASTERCOMBO_PATH          \
[NSString stringWithFormat:@"%@/pastercombo/",APP_BUNDLE_PRIVATE_PATH]



#define APP_TEMPLATE_DATABASE_PATH               \
[NSString stringWithFormat:@"%@/database",APP_PRIVATE_PATH]

#define APP_TEMPLATE_DATABASE_FULL_PATH          \
[NSString stringWithFormat:@"%@/%@",APP_TEMPLATE_DATABASE_PATH,APP_TEMPLATE_DATABASE_NAME]

#endif /* XYTemplateDBDefine_h */
