const std = @import("std");

/// Opponents Choice
/// A - Rock
/// B - Paper
/// C - Scissors

const opponentChoice = enum {
    A,
    B,
    C
};

/// My Choice & Points
/// X - Rock - 1
/// Y - Paper - 2
/// Z - Scissors -3 
const playerChoice = enum {
    X,
    Y,
    Z
};
/// Outcome Points
/// 0 - Loss 
/// 3 - Draw
/// 6 - Win

const ChoiceNotFoundError = error {
    ChoiceNotFound
};

//pub fn main(filename :*const [10:0]u8) !u64 {
pub fn main() !void{
    const filename = "./real.txt";
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
}

fn parseOpponent(opponentInput : u8) !opponentChoice {
    return switch(opponentInput) {
        'A' => .A, 
        'B' => .B, 
        'C' => .C,
        else => error.ChoiceNotFound 
    };
}

fn parsePlayer(playerInput : u8) !playerChoice {
    return switch(playerInput) {
        'X' => .X, 
        'Y' => .Y, 
        'Z' => .Z,
        else => error.ChoiceNotFound 
    };
}



// Be sure to add a type after the parenthesis and before the {
pub fn getGameScore(opponentInput : opponentChoice, playerInput : playerChoice)  u8 {
    var score :u8= 0;
    score = switch (opponentInput) {
        .A => rock : {
            score = switch (playerInput) {
                .X => 3,
                .Y => 6,
                .Z => 0,
            };
            break :rock score;
        },
        .B => paper: {
            score =  switch (playerInput) {
                playerChoice.X => 0,
                playerChoice.Y => 3,
                playerChoice.Z => 6,
            };
            break :paper score;
        },
        .C => scissors: {
            score =  switch (playerInput) {
                playerChoice.X => 6,
                playerChoice.Y => 0,
                playerChoice.Z => 3,
            };
            break :scissors score;
        }
    };
    return score;
}


// Be sure to add a type after the parenthesis and before the {
pub fn getPlayerChoiceScore(playerInput: playerChoice) u8{
    return switch (playerInput) {
        .X => 1,
        .Y => 2,
        .Z => 3
    } ;
}


test "simple strategy guide works" {
    try std.testing.expectEqual(main("./test.txt"), 15);
}


test "When the opponent chooses rock, game handles player cases correctly" {
    try std.testing.expectEqual(getGameScore(opponentChoice.A, playerChoice.X), 3);
    try std.testing.expectEqual(getGameScore(opponentChoice.A, playerChoice.Y), 6);
    try std.testing.expectEqual(getGameScore(opponentChoice.A, playerChoice.Z), 0);
}

test "When the opponent chooses paper, game handles player cases correctly" {
    try std.testing.expectEqual(getGameScore(opponentChoice.B, playerChoice.X), 0);
    try std.testing.expectEqual(getGameScore(opponentChoice.B, playerChoice.Y), 3);
    try std.testing.expectEqual(getGameScore(opponentChoice.B, playerChoice.Z), 6);
}

test "When the opponent chooses scissors, game handles player cases correctly" {
    try std.testing.expectEqual(getGameScore(opponentChoice.C, playerChoice.X), 6);
    try std.testing.expectEqual(getGameScore(opponentChoice.C, playerChoice.Y), 0);
    try std.testing.expectEqual(getGameScore(opponentChoice.C, playerChoice.Z), 3);
}

test "When a player chooses Rock, 1 point" {
    try std.testing.expectEqual(getPlayerChoiceScore(playerChoice.X), 1);

}
test "When a player chooses Paper, 2 point" {
    try std.testing.expectEqual(getPlayerChoiceScore(playerChoice.Y), 2);

}
test "When a player chooses Scissors, 3 point" {
    try std.testing.expectEqual(getPlayerChoiceScore(playerChoice.Z), 3);

}

