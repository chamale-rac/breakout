const std = @import("std");
const raylib = @import("raylib");

// Game state
const Game = struct {
    counter: i32,
    screen_width: i32,
    screen_height: i32,
    is_running: bool,
    ball: raylib.Rectangle,
    paddle: raylib.Rectangle,
    ball_sx: f32,
    ball_sy: f32,
    paddle_sx: f32,

    pub fn init(title: [*:0]const u8, width: i32, height: i32) Game {
        raylib.initWindow(width, height, std.mem.span(title));
        std.debug.print("GAME STARTED\n", .{});
        return Game{
            .counter = 0,
            .screen_width = width,
            .screen_height = height,
            .is_running = true,
            .ball = raylib.Rectangle{ .x = 10, .y = 10, .width = 15, .height = 15 },
            .paddle = raylib.Rectangle{ .x = 0, .y = 0, .width = 0, .height = 0 }, // Will be set in setup()
            .ball_sx = 150,
            .ball_sy = 150,
            .paddle_sx = 200,
        };
    }

    pub fn deinit(self: *Game) void {
        _ = self;
        raylib.closeWindow();
    }

    pub fn setup(self: *Game) void {
        raylib.setTargetFPS(60);

        self.ball = raylib.Rectangle{ .x = 10, .y = 10, .width = 15, .height = 15 };
        self.paddle = raylib.Rectangle{
            .x = @as(f32, @floatFromInt(@divTrunc(self.screen_width, 2))) - self.ball.width * 5,
            .y = @as(f32, @floatFromInt(self.screen_height)) - 15,
            .width = self.ball.width * 10,
            .height = 15,
        };
    }

    pub fn frameStart(self: *Game) void {
        std.debug.print("==== FRAME {} START ====\n", .{self.counter});
        raylib.beginDrawing();
    }

    pub fn frameEnd(self: *Game) void {
        std.debug.print("==== FRAME END ====\n", .{});
        raylib.endDrawing();
        self.counter += 1;
    }

    pub fn handleEvents(self: *Game) void {
        const dT = raylib.getFrameTime(); // seconds
        if (raylib.windowShouldClose()) {
            self.is_running = false;
        }
        if (raylib.isKeyDown(raylib.KeyboardKey.right)) {
            self.paddle.x += self.paddle_sx * dT;
        }

        if (raylib.isKeyDown(raylib.KeyboardKey.right)) {
            self.paddle.x -= self.paddle_sx * dT;
        }
    }

    pub fn update(self: *Game) void {
        const dT = raylib.getFrameTime(); // seconds
        if (self.ball.x >= @as(f32, @floatFromInt(self.screen_width))) {
            self.ball_sx *= -1;
        }
        if (self.ball.x < 0) {
            self.ball_sx *= -1;
        }
        if (self.ball.y >= @as(f32, @floatFromInt(self.screen_height))) {
            std.debug.print("YOU FAIL\n", .{});
            std.process.exit(1);
        }
        if (raylib.checkCollisionRecs(self.ball, self.paddle)) {
            self.ball_sy *= -1;
            self.ball_sx = self.paddle_sx;
        }
        if (self.ball.y < 0) {
            self.ball_sy *= -1;
        }

        self.ball.x += self.ball_sx * dT;
        self.ball.y += self.ball_sy * dT;
    }

    pub fn render(self: *Game) void {
        raylib.clearBackground(raylib.Color{ .r = 128, .g = 128, .b = 128, .a = 255 }); // GRAY

        var buf: [50:0]u8 = undefined;
        const fps_text = std.fmt.bufPrintZ(&buf, "FPS: {}", .{raylib.getFPS()}) catch "FPS: 0";
        raylib.drawText(fps_text, 10, 10, 20, raylib.Color{ .r = 128, .g = 128, .b = 128, .a = 255 });

        raylib.drawRectangleRec(self.ball, raylib.Color{ .r = 0, .g = 0, .b = 0, .a = 255 }); // BLACK
        raylib.drawRectangleRec(self.paddle, raylib.Color{ .r = 0, .g = 0, .b = 0, .a = 255 }); // BLACK
    }

    pub fn running(self: *Game) bool {
        return self.is_running;
    }
};

pub fn main() !void {
    var game = Game.init("Breakout Game", 800, 600);
    defer game.deinit();

    game.setup();

    // Main game loop
    while (game.running()) {
        game.frameStart();
        game.handleEvents();
        game.update();
        game.render();
        game.frameEnd();
    }
}
