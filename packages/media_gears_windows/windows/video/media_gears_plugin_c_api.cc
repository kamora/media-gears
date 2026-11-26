// Derived from media_kit (https://github.com/media-kit/media-kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the LICENSE file.

#include "media_gears_windows/media_gears_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "media_gears_plugin.h"

void MediaGearsPluginCApiRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {

	media_gears::MediaGearsPlugin::RegisterWithRegistrar(
		flutter::PluginRegistrarManager::GetInstance()->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
