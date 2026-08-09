`timescale 1ns/1ps

module lifo_tb;

    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg [7:0] din;

    wire [7:0] dout;
    wire full;
    wire empty;

    lifo #(
        .DATA_WIDTH(8),
        .DEPTH(8)
    ) dut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        clk  = 0;
        rst  = 1;
        push = 0;
        pop  = 0;
        din  = 0;

        // Reset
        #10;
        rst = 0;

        // PUSH 10
        @(negedge clk);
        push = 1;
        din = 8'h10;

        // PUSH 20
        @(negedge clk);
        din = 8'h20;

        // PUSH 30
        @(negedge clk);
        din = 8'h30;

        // Stop PUSH
        @(negedge clk);
        push = 0;

        // POP -> 30
        @(negedge clk);
        pop = 1;

        // POP -> 20
        @(negedge clk);

        // POP -> 10
        @(negedge clk);

        // Stop POP
        @(negedge clk);
        pop = 0;

        #20;
        $finish;
    end

    always @(posedge clk) begin
        $display(
            "Time=%0t | PUSH=%b | POP=%b | DIN=%h | DOUT=%h | FULL=%b | EMPTY=%b | SP=%0d",
            $time, push, pop, din, dout, full, empty, dut.sp
        );
    end

endmodule