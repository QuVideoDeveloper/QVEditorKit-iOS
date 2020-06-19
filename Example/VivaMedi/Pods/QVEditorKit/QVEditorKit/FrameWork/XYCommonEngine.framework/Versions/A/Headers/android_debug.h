/*
 * Copyright (C) 2010 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef ARC_DEBUG_H_

#define ARC_DEBUG_H_

#include <cutils/log.h>

#define LITERAL_TO_STRING_INTERNAL(x)    #x
#define LITERAL_TO_STRING(x) LITERAL_TO_STRING_INTERNAL(x)

#define CHECK_EQ(x,y)                                                   \
	LOGE_IF(                                                \
	(x) != (y),                                                 \
	__FILE__ ":" LITERAL_TO_STRING(__LINE__) " " #x " != " #y)

#define CHECK(x)                                                        \
	LOGE_IF(                                                \
	!(x),                                                       \
	__FILE__ ":" LITERAL_TO_STRING(__LINE__) " " #x)



#endif  // ARC_DEBUG_H_

