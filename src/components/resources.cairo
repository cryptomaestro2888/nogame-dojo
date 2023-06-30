#[derive(Component, Copy, Drop, Serde)]
struct Steel {
    available: u128, 
}

#[derive(Component, Copy, Drop, Serde)]
struct Quartz {
    available: u128, 
}

#[derive(Component, Copy, Drop, Serde)]
struct Tritium {
    available: u128, 
}

#[derive(Component, Copy, Drop, Serde)]
struct Energy {
    available: u128, 
}
