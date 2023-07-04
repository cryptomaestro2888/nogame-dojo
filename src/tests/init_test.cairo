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
    use nogame::systems::mines::mines_upgrade;
    use nogame::tests::utils::test_utils::setup_world;

    #[test]
    #[available_gas(30000000000000)]
    fn test() {
        let world = setup_world();
        // Number of planets
        let mut call_data: Array = Default::default();
        call_data.append(1);
        world.execute('init_uni'.into(), call_data.span());

        // Number of planets
        let n_planets = world.entity('NPlanets'.into(), 1.into(), 0, 0);
        assert(*n_planets[0] == 0, 'n_planets is wrong');
        let mut n = 10;
        loop {
            if n == 0 {
                break;
            }
            world.execute('init_planet'.into(), call_data.span());
            n -= 1;
        };
        let n_planets = world.entity('NPlanets'.into(), 1.into(), 0, 0);
        assert(*n_planets[0] == 10, 'n_planets is wrong');

        // Resources available
        let steel_available = world.entity('Steel'.into(), 7.into(), 0, 0);
        assert(*steel_available[0] == 500, 'steel amount is wrong');
        let quartz_available = world.entity('Quartz'.into(), 8.into(), 0, 0);
        assert(*quartz_available[0] == 300, 'quartz amount is wrong');
        let tritium_available = world.entity('Tritium'.into(), 9.into(), 0, 0);
        assert(*tritium_available[0] == 100, 'tritium amount is wrong');

        // Buildings levels
        let steel_mine_level = world.entity('SteelMine'.into(), 1.into(), 0, 0);
        assert(*steel_mine_level[0] == 0, 'wrong steel mine level');
        let quartz_mine_level = world.entity('QuartzMine'.into(), 2.into(), 0, 0);
        assert(*quartz_mine_level[0] == 0, 'wrong quartz mine level');
        let tritium_mine_level = world.entity('TritiumMine'.into(), 3.into(), 0, 0);
        assert(*tritium_mine_level[0] == 0, 'wrong tritium mine level');
        let energy_plant_level = world.entity('EnergyPlant'.into(), 4.into(), 0, 0);
        assert(*energy_plant_level[0] == 0, 'wrong energy plant level');
        let dockyard_level = world.entity('Dockyard'.into(), 5.into(), 0, 0);
        assert(*dockyard_level[0] == 0, 'wrong dockyard level');
        let laboratory_level = world.entity('Laboratory'.into(), 6.into(), 0, 0);
        assert(*laboratory_level[0] == 0, 'wrong laboratory level');
    }
}
