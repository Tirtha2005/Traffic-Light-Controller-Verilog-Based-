// traffic_light_tb.v
// Testbench for traffic_light.v

`timescale 1ns/1ps

module traffic_light_tb;
    reg clk;
    reg rst_n;
    wire red, yellow, green;

    // instantiate DUT
    traffic_light dut (
        .clk(clk),
        .rst_n(rst_n),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // clock: 10 ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // waveform dump (for ModelSim: use "vsim" GUI or do wave save)
`ifdef VCD
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, traffic_light_tb);
`endif

        // reset sequence
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;

        // run for 20 clock cycles to observe multiple state transitions
        #200;

        // finish
        $display("Testbench finished at time %t", $time);
        $finish;
    end

endmodule