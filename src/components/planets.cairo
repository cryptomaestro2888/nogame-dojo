#[derive(Component, Copy, Drop, Serde)]
struct Planet {
    points: u128, 
}

#[derive(Component, Copy, Drop, Serde)]
struct NPlanets {
    n: u32
}

