mod generators;

#[rustler::nif]
fn owo_id(bytes: i8) -> String {
    generators::owo(bytes)
}

#[rustler::nif]
fn ntsu_id(bytes: i8) -> String {
  generators::ntsu(bytes)
}

rustler::init!("Obfuscate.Encoding", [owo_id, ntsu_id]);
