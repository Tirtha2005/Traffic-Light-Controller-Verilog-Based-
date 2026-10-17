// traffic_light.v
// 3-state traffic light (Verilog-2001 compatible)
// Sequence: RED -> YELLOW -> GREEN -> RED

module traffic_light (
    input  wire clk,
    input  wire rst_n,   // active-low reset
    output reg  red,
    output reg  yellow,
    output reg  green
);

    // state encoding (plain Verilog)
    reg [1:0] state;
    parameter RED    = 2'b00;
    parameter YELLOW = 2'b01;
    parameter GREEN  = 2'b10;

    // synchronous state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= RED;
        else begin
            case (state)
                RED:    state <= YELLOW;  // RED -> YELLOW
                YELLOW: state <= GREEN;   // YELLOW -> GREEN
                GREEN:  state <= RED;     // GREEN -> RED
                default: state <= RED;
            endcase
        end
    end

    // outputs (one-hot)
    always @(*) begin
        red    = 1'b0;
        yellow = 1'b0;
        green  = 1'b0;
        case (state)
            RED:    red    = 1'b1;
            YELLOW: yellow = 1'b1;
            GREEN:  green  = 1'b1;
        endcase
    end

endmodule