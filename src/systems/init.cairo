#[system]
mod init_uni {
    use debug::PrintTrait;
    use traits::Into;

    use dojo::world::Context;

    use nogame::components::planets::NPlanets;

    fn execute(ctx: Context, uni_id: u32) {
        set !(ctx.world, uni_id.into(), (NPlanets { n: 0 }));
        return ();
    }
}

#[system]
mod init_planet {
    use debug::PrintTrait;
    use traits::Into;

    use dojo::world::Context;

    use nogame::components::buildings::{
        SteelMine, QuartzMine, TritiumMine, EnergyPlant, Dockyard, Laboratory
    };
    use nogame::components::planets::{NPlanets, Planet};
    use nogame::components::resources::{Steel, Quartz, Tritium, Energy};

    fn execute(ctx: Context, uni_id: u32) {
        let n_planets = get !(ctx.world, uni_id.into(), NPlanets);
        let planet_id = n_planets.n + 1;
        set !(
            ctx.world,
            planet_id.into(),
            (
                Planet {
                    points: 0
                    }, SteelMine {
                    level: 0
                    }, QuartzMine {
                    level: 0
                    }, TritiumMine {
                    level: 0
                    }, EnergyPlant {
                    level: 0
                    }, Dockyard {
                    level: 0
                    }, Laboratory {
                    level: 0
                }
            )
        );
        set !(ctx.world, uni_id.into(), (NPlanets { n: n_planets.n + 1 }));
        set !(
            ctx.world,
            planet_id.into(),
            (
                Steel {
                    available: 500
                    }, Quartz {
                    available: 300
                    }, Tritium {
                    available: 100
                    }, Energy {
                    available: 0
                }
            )
        );
        return ();
    }
}

#[cfg(test)]
mod tests {
    use core::traits::{Into, Default};
    use array::ArrayTrait;

    use dojo::world::IWorldDispatcherTrait;

    use dojo::test_utils::spawn_test_world;

    use nogame::components::buildings::{
        steel_mine, quartz_mine, tritium_mine, energy_plant, dockyard, laboratory
    };
    use nogame::components::planets::{n_planets, planet};
    use nogame::components::resources::{steel, quartz, tritium, energy};
    use nogame::systems::init::{init_planet, init_uni};

    #[test]
    #[available_gas(30000000)]
    fn test_init() {
        let caller = starknet::contract_address_const::<0x0>();

        // components
        let mut components: Array = Default::default();
        components.append(n_planets::TEST_CLASS_HASH);
        components.append(planet::TEST_CLASS_HASH);
        components.append(steel::TEST_CLASS_HASH);
        components.append(quartz::TEST_CLASS_HASH);
        components.append(tritium::TEST_CLASS_HASH);
        components.append(energy::TEST_CLASS_HASH);
        components.append(steel_mine::TEST_CLASS_HASH);
        components.append(quartz_mine::TEST_CLASS_HASH);
        components.append(tritium_mine::TEST_CLASS_HASH);
        components.append(energy_plant::TEST_CLASS_HASH);
        components.append(dockyard::TEST_CLASS_HASH);
        components.append(laboratory::TEST_CLASS_HASH);
        // systems
        let mut systems: Array = Default::default();
        systems.append(init_uni::TEST_CLASS_HASH);
        systems.append(init_planet::TEST_CLASS_HASH);

        // deploy executor, world and register components/systems
        let world = spawn_test_world(components, systems);
        // Number of planets
        let mut call_data: Array = Default::default();
        call_data.append(1);
        world.execute('init_uni'.into(), call_data.span());
        let n_planets = world.entity('NPlanets'.into(), 1.into(), 0, 0);
        assert(*n_planets[0] == 0, 'n_planets is wrong');
        // Resources available
        world.execute('init_planet'.into(), call_data.span());
        let steel_available = world.entity('Steel'.into(), 1.into(), 0, 0);
        assert(*steel_available[0] == 500, 'steel amount is wrong');
        let quartz_available = world.entity('Quartz'.into(), 1.into(), 0, 0);
        assert(*quartz_available[0] == 300, 'quartz amount is wrong');
        let tritium_available = world.entity('Tritium'.into(), 1.into(), 0, 0);
        assert(*tritium_available[0] == 100, 'tritium amount is wrong');
        // Buildings levels
        let steel_mine_level = world.entity('SteelMine'.into(), 1.into(), 0, 0);
        assert(*steel_mine_level[0] == 0, 'wrong steel mine level');
        let quartz_mine_level = world.entity('QuartzMine'.into(), 1.into(), 0, 0);
        assert(*quartz_mine_level[0] == 0, 'wrong quartz mine level');
        let tritium_mine_level = world.entity('TritiumMine'.into(), 1.into(), 0, 0);
        assert(*tritium_mine_level[0] == 0, 'wrong tritium mine level');
        let energy_plant_level = world.entity('EnergyPlant'.into(), 1.into(), 0, 0);
        assert(*energy_plant_level[0] == 0, 'wrong energy plant level');
        let dockyard_level = world.entity('Dockyard'.into(), 1.into(), 0, 0);
        assert(*dockyard_level[0] == 0, 'wrong dockyard level');
        let laboratory_level = world.entity('Laboratory'.into(), 1.into(), 0, 0);
        assert(*laboratory_level[0] == 0, 'wrong laboratory level');
    }
}
