module lifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  push,
    input  wire                  pop,
    input  wire [DATA_WIDTH-1:0] din,
    output reg  [DATA_WIDTH-1:0] dout,
    output wire                  full,
    output wire                  empty
);

    reg [DATA_WIDTH-1:0] stack [0:DEPTH-1];
    reg [3:0] sp;  // Stack pointer

    assign empty = (sp == 0);
    assign full  = (sp == DEPTH);

    always @(posedge clk) begin
        if (rst) begin
            sp   <= 0;
            dout <= 0;
        end
        else begin
            // PUSH operation
            if (push && !full) begin
                stack[sp] <= din;
                sp <= sp + 1'b1;
            end

            // POP operation
            else if (pop && !empty) begin
                sp <= sp - 1'b1;
                dout <= stack[sp - 1'b1];
            end
        end
    end

endmodule