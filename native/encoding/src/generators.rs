use rand::{thread_rng, Rng};

const OWO: [&str; 11] = [
    "owo", "OWO", "0w0", ">w<", "uwu", "uvu", "ovo", "Uvu", "uVu", "uvU", "UVU",
];

const NTSU: [&str; 4] = ["ntsu", "tsu", "ne", "tsu"];

macro_rules! generate_for {
    ($name:ident, $list:ident) => {
        pub fn $name(bytes: i8) -> String {
          let mut rng = thread_rng();
          let max = $list.len();
        
          let mut id = Vec::<&str>::new();
        
          for _ in 0..=bytes {
            let index = rng.gen_range(0..max);
        
            id.push($list[index])
          }
        
          id.join("-")
        }
    };
}

generate_for!(owo, OWO);
generate_for!(ntsu, NTSU);