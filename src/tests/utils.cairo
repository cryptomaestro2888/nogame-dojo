#[cfg(test)]
mod test_utils {
    use core::traits::{Into, Default};
    use array::ArrayTrait;

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::test_utils::spawn_test_world;
    // use dojo::test_utils::spawn_test_world;

    use nogame::components::buildings::{
        steel_mine, quartz_mine, tritium_mine, energy_plant, dockyard, laboratory
    };
    use nogame::components::planets::{n_planets, planet};
    use nogame::components::resources::{steel, quartz, tritium, energy};
    use nogame::systems::init::{init_planet, init_uni};
    use nogame::systems::mines::mines_upgrade;

    fn setup_world() -> IWorldDispatcher {
        // components
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
        systems.append(mines_upgrade::TEST_CLASS_HASH);

        // deploy executor, world and register components/systems
        let world = spawn_test_world(components, systems);

        world
    }
}

