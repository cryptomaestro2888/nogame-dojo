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
