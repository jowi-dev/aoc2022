const std = @import("std");


const choice = enum {
    ROCK,
    PAPER, 
    SCISSORS
};


const ChoiceNotFoundError = error {
    ChoiceNotFound
};

pub fn main(filename :*const [10:0]u8) !u64 {
    var total :u64= 0;
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const opponentInput = try parseOpponent(line[0]);
        const playerInput = try parsePlayer(line[2]);
        total += getGameScore(opponentInput, playerInput) + getPlayerChoiceScore(playerInput);
    }
    std.debug.print("Total Is: {}\n", .{total});
    return total;
}

/// Opponents Choice
/// A - Rock
/// B - Paper
/// C - Scissors
fn parseOpponent(opponentInput : u8) !choice {
    return switch(opponentInput) {
        'A' => .ROCK, 
        'B' => .PAPER, 
        'C' => .SCISSORS,
        else => error.ChoiceNotFound 
    };
}

/// Player Choice 
/// X - Rock 
/// Y - Paper 
/// Z - Scissors 
fn parsePlayer(playerInput : u8) !choice {
    return switch(playerInput) {
        'X' => .ROCK, 
        'Y' => .PAPER, 
        'Z' => .SCISSORS,
        else => error.ChoiceNotFound 
    };
}



/// Outcome Points
/// 0 - Loss 
/// 3 - Draw
/// 6 - Win
pub fn getGameScore(opponentInput : choice, playerInput : choice)  u8 {
    var score :u8= 0;
    score = switch (opponentInput) {
        .ROCK => rock : {
            score = switch (playerInput) {
                .ROCK => 3,
                .PAPER => 6,
                .SCISSORS => 0,
            };
            break :rock score;
        },
        .PAPER => paper: {
            score =  switch (playerInput) {
                .ROCK => 0,
                .PAPER => 3,
                .SCISSORS => 6,
            };
            break :paper score;
        },
        .SCISSORS => scissors: {
            score =  switch (playerInput) {
                .ROCK => 6,
                .PAPER => 0,
                .SCISSORS => 3,
            };
            break :scissors score;
        }
    };
    return score;
}


/// Player Choice Points
/// Rock - 1
/// Paper - 2
/// Scissors -3 
pub fn getPlayerChoiceScore(playerInput: choice) u8{
    return switch (playerInput) {
        .ROCK => 1,
        .PAPER => 2,
        .SCISSORS => 3
    } ;
}


test "real strategy guide works" {
    const result = try main("./real.txt");
    std.debug.print("{}", .{result});

    try std.testing.expect(result > 0);
}
test "simple strategy guide works" {
    try std.testing.expectEqual(main("./test.txt"), 15);
}


test "When the opponent chooses rock, game handles player cases correctly" {
    try std.testing.expectEqual(getGameScore(choice.ROCK, choice.ROCK), 3);
    try std.testing.expectEqual(getGameScore(choice.ROCK, choice.PAPER), 6);
    try std.testing.expectEqual(getGameScore(choice.ROCK, choice.SCISSORS), 0);
}

test "When the opponent chooses paper, game handles player cases correctly" {
    try std.testing.expectEqual(getGameScore(choice.PAPER, choice.ROCK), 0);
    try std.testing.expectEqual(getGameScore(choice.PAPER, choice.PAPER), 3);
    try std.testing.expectEqual(getGameScore(choice.PAPER, choice.SCISSORS), 6);
}

test "When the opponent chooses scissors, game handles player cases correctly" {
    try std.testing.expectEqual(getGameScore(choice.SCISSORS, choice.ROCK), 6);
    try std.testing.expectEqual(getGameScore(choice.SCISSORS, choice.PAPER), 0);
    try std.testing.expectEqual(getGameScore(choice.SCISSORS, choice.SCISSORS), 3);
}

test "When a player chooses Rock, 1 point" {
    try std.testing.expectEqual(getPlayerChoiceScore(choice.ROCK), 1);

}
test "When a player chooses Paper, 2 point" {
    try std.testing.expectEqual(getPlayerChoiceScore(choice.PAPER), 2);

}
test "When a player chooses Scissors, 3 point" {
    try std.testing.expectEqual(getPlayerChoiceScore(choice.SCISSORS), 3);

}

