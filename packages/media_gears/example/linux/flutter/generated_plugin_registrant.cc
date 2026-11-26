//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <media_gears_linux/media_gears_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) media_gears_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MediaGearsPlugin");
  media_gears_plugin_register_with_registrar(media_gears_linux_registrar);
}
