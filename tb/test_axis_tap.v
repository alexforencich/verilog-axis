/*

Copyright (c) 2015 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1 ns / 1 ps

module test_axis_tap;

// Inputs
reg clk = 0;
reg rst = 0;
reg [7:0] current_test = 0;

reg [7:0] tap_axis_tdata = 0;
reg tap_axis_tvalid = 0;
reg tap_axis_tready = 0;
reg tap_axis_tlast = 0;
reg tap_axis_tuser = 0;
reg output_axis_tready = 0;

// Outputs
wire [7:0] output_axis_tdata;
wire output_axis_tvalid;
wire output_axis_tlast;
wire output_axis_tuser;

initial begin
    // myhdl integration
    $from_myhdl(clk,
                rst,
                current_test,
                tap_axis_tdata,
                tap_axis_tvalid,
                tap_axis_tready,
                tap_axis_tlast,
                tap_axis_tuser,
                output_axis_tready);
    $to_myhdl(output_axis_tdata,
              output_axis_tvalid,
              output_axis_tlast,
              output_axis_tuser);

    // dump file
    $dumpfile("test_axis_tap.lxt");
    $dumpvars(0, test_axis_tap);
end

axis_tap #(
    .DATA_WIDTH(8)
)
UUT (
    .clk(clk),
    .rst(rst),
    // AXI tap
    .tap_axis_tdata(tap_axis_tdata),
    .tap_axis_tvalid(tap_axis_tvalid),
    .tap_axis_tready(tap_axis_tready),
    .tap_axis_tlast(tap_axis_tlast),
    .tap_axis_tuser(tap_axis_tuser),
    // AXI output
    .output_axis_tdata(output_axis_tdata),
    .output_axis_tvalid(output_axis_tvalid),
    .output_axis_tready(output_axis_tready),
    .output_axis_tlast(output_axis_tlast),
    .output_axis_tuser(output_axis_tuser)
);

endmodule
