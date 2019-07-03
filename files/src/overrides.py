# https://docs.openstack.org/horizon/rocky/configuration/customizing.html#horizon-customization-module-overrides
#
# HORIZON_CONFIG["customization_module"] = "betacloud_customization_module.overrides"

import horizon

project_dashboard = horizon.get_dashboard("project")
project_dashboard.default_panel = "instances"

volume_groups_panel = project_dashboard.get_panel("volume_groups")
project_dashboard.unregister(volume_groups_panel.__class__)

vg_snapshots_panel = project_dashboard.get_panel("vg_snapshots")
project_dashboard.unregister(vg_snapshots_panel.__class__)
