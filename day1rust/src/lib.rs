pub fn call(filename: String) -> usize{
    let elves = parse_elves(filename);

    return find_max(elves);
}

pub fn parse_elves(filename: String) -> Vec<Vec<usize>>{
    let contents = std::fs::read_to_string(filename).expect("read the file");
    let mut string_vals : Vec<&str> = contents.split("\n\n").collect();
    string_vals.pop();

    let mut elves : Vec<Vec<usize>>  = Vec::new();
    for val in string_vals {
        let mut elf : Vec<usize> = Vec::new();
        let cal_list : Vec<&str> = val.split("\n").collect();
        for cal in cal_list {
            let num :usize = cal.parse::<usize>().unwrap();
            elf.push(num);

        }
        elves.push(elf);
    }
    return elves;
}

pub fn find_max(elves: Vec<Vec<usize>>) -> usize {
    let mut max :usize = 0;
    for elf in elves {
        let mut total :usize= 0;
        for item in elf {
            total += item;
        }
        if total > max {
            max = total;
        }

    }
     return max;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {

        let result : usize = call("./test.txt".to_string());
        assert_eq!(result, 24000);
    }

    #[test]
    fn the_answer_is() {
        
        let result : usize = call("./input.txt".to_string());
        println!("CONTENTS");
        println!("{}", result);
        assert!(result > 0);

    }
}
