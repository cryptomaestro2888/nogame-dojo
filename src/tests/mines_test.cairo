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
        let mut call_data: Array = Default::default();
        call_data.append(1);
        world.execute('init_uni'.into(), call_data.span());
        world.execute('init_planet'.into(), call_data.span());

        call_data.append(5);
        world.execute('mines_upgrade'.into(), call_data.span());
        let steel_mine_level = world.entity('SteelMine'.into(), 1.into(), 0, 0);
        assert(*steel_mine_level[0] == 1, 'wrong steel mine level');
        let steel_available = world.entity('Steel'.into(), 1.into(), 0, 0);
        let quartz_available = world.entity('Quartz'.into(), 1.into(), 0, 0);
        assert(*steel_available[0] == 440, 'wrong steel amount');
        assert(*quartz_available[0] == 285, 'wrong quartz amount');
    }
}
