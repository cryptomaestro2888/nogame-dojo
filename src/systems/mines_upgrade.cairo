#[system]
mod MinesUpgrade {
    use integer::U128Div;
    use traits::Into;
    use nogame::components::buildings::{SteelMine, QuartzMine, TritiumMine, EnergyPlant};
    use nogame::constants::{BuildingType, MinesConst};
    use nogame::components::resources::{Steel, Quartz, Tritium};
    use nogame::utils::Utils::{Cost, pow};

    fn execute(ctx: Context, planet_id: u32, building_id: u8) { // match building_id {
        let (s, q, t) = get !(ctx, planet_id.into(), (Steel, Quartz, Tritium));
        let available = Cost { steel: s.available, quartz: q.available, tritium: t.available };
        if building_id == BuildingType::STEEL_MINE {
            let mine = get !(ctx, planet_id.into(), SteelMine);
            let cost: Cost = steel_mine_cost(mine.level.into());
            assert_enough_resources(planet_id, available, cost);
            set !(
                ctx,
                planet_id.into(),
                (
                    Steel {
                        available: available.steel - cost.steel
                        }, Quartz {
                        available: available.quartz - cost.quartz
                    }
                )
            );
            set !(ctx, planet_id.into(), (SteelMine { level: mine.level + 1 }));
        } else if building_id == BuildingType::QUARTZ_MINE {
            let mine = get !(ctx, planet_id.into(), QuartzMine);
            let cost: Cost = quartz_mine_cost(mine.level.into());
            assert_enough_resources(planet_id, available, cost);
            set !(
                ctx,
                planet_id.into(),
                (
                    Steel {
                        available: available.steel - cost.steel
                        }, Quartz {
                        available: available.quartz - cost.quartz
                    }
                )
            );
            set !(ctx, planet_id.into(), (QuartzMine { level: mine.level + 1 }));
        } else if building_id == BuildingType::TRITIUM_MINE {
            let mine = get !(ctx, planet_id.into(), TritiumMine);
            let cost: Cost = tritium_mine_cost(mine.level.into());
            assert_enough_resources(planet_id, available, cost);
            set !(
                ctx,
                planet_id.into(),
                (
                    Steel {
                        available: available.steel - cost.steel
                        }, Quartz {
                        available: available.quartz - cost.quartz
                    }
                )
            );
            set !(ctx, planet_id.into(), (TritiumMine { level: mine.level + 1 }));
        } else if building_id == BuildingType::ENERGY_PLANT {
            let mine = get !(ctx, planet_id.into(), EnergyPlant);
            let cost: Cost = energy_plant_cost(mine.level.into());
            assert_enough_resources(planet_id, available, cost);
            set !(
                ctx,
                planet_id.into(),
                (
                    Steel {
                        available: available.steel - cost.steel
                        }, Quartz {
                        available: available.quartz - cost.quartz
                    }
                )
            );
            set !(ctx, planet_id.into(), (EnergyPlant { level: mine.level + 1 }));
        }
        return ();
    }

    fn steel_mine_cost(current_level: u128) -> Cost {
        let base_steel = 60;
        let base_quarz = 15;
        if current_level == 0 {
            Cost { steel: base_steel, quartz: base_quarz, tritium: 0 }
        } else {
            let steel = base_steel * (pow(2, current_level));
            let quartz = base_quarz * (pow(2, current_level));
            Cost { steel: steel, quartz: quartz, tritium: 0 }
        }
    }

    fn quartz_mine_cost(current_level: u128) -> Cost {
        let base_steel = 48;
        let base_quarz = 24;
        if current_level == 0 {
            Cost { steel: base_steel, quartz: base_quarz, tritium: 0,  }
        } else {
            let steel = base_steel * (pow(2, current_level));
            let quartz = base_quarz * (pow(2, current_level));
            Cost { steel: steel, quartz: quartz, tritium: 0,  }
        }
    }

    fn tritium_mine_cost(current_level: u128) -> Cost {
        let base_steel = 225;
        let base_quarz = 75;
        if current_level == 0 {
            Cost { steel: base_steel, quartz: base_quarz, tritium: 0,  }
        } else {
            let steel = base_steel * (pow(2, current_level));
            let quartz = base_quarz * (pow(2, current_level));
            Cost { steel: steel, quartz: quartz, tritium: 0,  }
        }
    }

    fn energy_plant_cost(current_level: u128) -> Cost {
        let base_steel = 75;
        let base_quarz = 30;
        if current_level == 0 {
            Cost { steel: base_steel, quartz: base_quarz, tritium: 0,  }
        } else {
            let steel = base_steel * (pow(2, current_level));
            let quartz = base_quarz * (pow(2, current_level));
            Cost { steel: steel, quartz: quartz, tritium: 0,  }
        }
    }

    fn steel_production(current_level: u128) -> u256 {
        if current_level == 0 {
            u256 { low: 30, high: 0 }
        } else if current_level <= 31 {
            let production = U128Div::div(
                30 * current_level * pow(11, current_level), pow(10, current_level)
            );
            u256 { low: production, high: 0 }
        } else {
            let production = MinesConst::MAX_STEEL_OVERFLOW * (current_level - 31);
            u256 { low: production, high: 0 }
        }
    }

    fn quartz_production(current_level: u128) -> u256 {
        if current_level == 0 {
            u256 { low: 22, high: 0 }
        } else if current_level <= 31 {
            let production = U128Div::div(
                20 * current_level * pow(11, current_level), pow(10, current_level)
            );
            u256 { low: production, high: 0 }
        } else {
            let production = MinesConst::MAX_QUARZ_OVERFLOW * (current_level - 31);
            u256 { low: production, high: 0 }
        }
    }

    fn tritium_production(current_level: u128) -> u256 {
        if current_level == 0 {
            u256 { low: 0, high: 0 }
        } else if current_level <= 31 {
            let production = U128Div::div(
                10 * current_level * pow(11, current_level), pow(10, current_level)
            );
            u256 { low: production, high: 0 }
        } else {
            let production = MinesConst::MAX_TRITIUM_OVERFLOW * (current_level - 31);
            u256 { low: production, high: 0 }
        }
    }

    fn energy_plant_production(current_level: u128) -> u128 {
        if current_level == 0 {
            30
        } else if current_level <= 31 {
            U128Div::div(20 * current_level * pow(11, current_level), pow(10, current_level)) + 30
        } else {
            MinesConst::MAX_QUARZ_OVERFLOW * (current_level - 31)
        }
    }

    fn base_mine_consumption(current_level: u128) -> u128 {
        if current_level == 0 {
            0
        } else if current_level <= 31 {
            U128Div::div(10 * current_level * pow(11, current_level), pow(10, current_level))
        } else {
            MinesConst::MAX_TRITIUM_OVERFLOW * (current_level - 31)
        }
    }

    fn tritium_mine_consumption(current_level: u128) -> u128 {
        if current_level == 0 {
            0
        } else if current_level <= 31 {
            U128Div::div(20 * current_level * pow(11, current_level), pow(10, current_level))
        } else {
            MinesConst::MAX_QUARZ_OVERFLOW * (current_level - 31)
        }
    }

    fn assert_enough_resources(planet_id: u32, available: Cost, cost: Cost) {
        assert(available.steel >= cost.steel, 'Not enough steel');
        assert(available.quartz >= cost.quartz, 'Not enough quartz');
        assert(available.tritium >= cost.tritium, 'Not enough tritium');
    }
}

