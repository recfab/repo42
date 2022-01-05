use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    #[structopt(parse(from_os_str))]
    path: std::path::PathBuf,
}

fn main() {
    let args = Cli::from_args();
    println!("Working with path: {:?}", args.path);
    let content = std::fs::read_to_string(&args.path).unwrap();
    println!("file: {:?} has content: {:?}", args.path, content);
}
