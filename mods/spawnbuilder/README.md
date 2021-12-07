# Spawn Builder
Version 1.1.0

## Description
This mod generates a simple stone platform at the world origin
or the static spawn point.
Ideal for the `singlenode` map generator.

## Usage
Activate this *before* the spawn area got generated (ideally
in a new world), then just join the world.
Recommended to be used in the `singlenode` mapgen, but it works
in other map generators, too.

### Settings
With the setting `spawnbuilder_width` you can change the width of
the spawn platform. Note that values below 3 are not recommended.

If the static spawn point (`static_spawnpoint`) is set on the
first start of the mod, the platform is centered at this
position instead.

## Behaviour
This mod generates a stone platform of size 33×2×33 with
a single cobblestone in the center. Also, 3 layers
above the platform are turned into air because the
center position might be buried in the ground.

As a safety measure, nodes with the property
`is_ground_content=false` will never be overwritten.

Also, no platform is generated if the center position is
already in a safe spawn (in air, a few blocks below solid
ground).

## Dependencies
This mod works with almost all subgames out of the box.

The only requirement is that the subgame defines the mapgen
aliases `mapgen_stone` and `mapgen_cobble` which is almost
certainly the case.

## License of everything in this mod
MIT License.
