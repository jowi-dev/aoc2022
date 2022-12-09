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
        let elf1 = std::vec![1000, 2000, 3000];
        let elf2 = std::vec![4000];
        let elf3 = std::vec![5000, 6000];
        let elf4 = std::vec![7000, 8000, 9000];
        let elf5 = std::vec![10000];

        let elves = std::vec![elf1, elf2, elf3, elf4, elf5];

        let result = find_max(elves);
        assert_eq!(result, 24000);
    }

    #[test]
    fn the_answer_is() {
        
        let contents = std::fs::read_to_string("./input.txt").expect("read the file");
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
        let result : usize = find_max(elves);
        println!("CONTENTS");
        println!("{}", result);

    }
}
