#[derive(Component, Copy, Drop, Serde)]
struct SteelMine {
    level: u8, 
}

#[derive(Component, Copy, Drop, Serde)]
struct QuartzMine {
    level: u8, 
}

#[derive(Component, Copy, Drop, Serde)]
struct TritiumMine {
    level: u8, 
}

#[derive(Component, Copy, Drop, Serde)]
struct EnergyPlant {
    level: u8, 
}

#[derive(Component, Copy, Drop, Serde)]
struct Dockyard {
    level: u8, 
}

#[derive(Component, Copy, Drop, Serde)]
struct Laboratory {
    level: u8, 
}
