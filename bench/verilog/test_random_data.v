///////////////////////////////////////////////////////////////////
         //////                                    //////
///////////////////////////////////////////////////////////////////
///                                                             ///
/// This file is generated by Viterbi HDL Code Generator(VHCG)  ///
/// which is written by Mike Johnson at OpenCores.org  and      ///
/// distributed under GPL license.                              ///
///                                                             ///
/// If you have any advice,                                     ///
/// please email to jhonson.zhu@gmail.com                       ///
///                                                             ///
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////



`include "glb_def.v"

// uncomment to VCD dump
//`define VCD_DUMP_ENABLE     1

// the length of the code source
`define CODE_LEN            10302

// data generation seed - change this value to change encoder input data sequence
`define RAND_SEED			123456

// test bench files names
`define ENC_IN_FILE			"enc_in.txt"
`define ENC_OUT_FILE		"enc_out.txt"
`define DEC_OUT_FILE		"dec_out.txt"

// number of clock cycles used to process input symbols before next symbols can be
// sent to the decoder (= 2^u).
`define SLICE_NUM           2

// traceback depth used to bound the decoder delay
`define OUT_NUM             64

// the simulation cycle time of clock 1->500M 10->50M 
`define CLK_TIME            10

// simulation end command
// use $stop command for modelsim and $finish for icarus verilog
`define END_COMMAND         $finish
//`define END_COMMAND         $stop

module test_random_data;

reg clock;
reg reset;
wire srst = 0;
reg enc_bit_in, enc_valid_in;
wire enc_symbol0, enc_symbol1;
wire enc_valid_out;

//reg [`Bit_Width-1:0] dec_symbol0, dec_symbol1;

wire [`Bit_Width-1:0] dec_symbol0, dec_symbol1;
reg [7:0] dec_symbol;
assign  dec_symbol0 [3:0] = dec_symbol[7:4];
assign  dec_symbol1 [3:0] = dec_symbol[3:0]; 

reg dec_valid_in;
wire [`SYMBOLS_NUM-1:0] pattern;
wire dec_bit_out, dec_valid_out;
integer ccnt, count;
reg [2*`OUT_NUM-1:0] enc_in_buf;
integer buf_in_cnt, buf_out_cnt, total_count, dec_out_error;

integer inputLLR_file,matlabraw_file;
integer f_dec_out;
//reg dec_out_error;
reg[31:0] glb_seed;

// VCD dump - if enabled
`ifdef VCD_DUMP_ENABLE
initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, test_random_data);
end
`endif

initial
begin
    clock = 1;
    reset = 1;
    # 100.5 reset = 0;
end

initial forever # `CLK_TIME clock = ~clock;

initial
begin
    enc_valid_in = 0;
    glb_seed = 32'b00000000000011100100000000000000;
    enc_bit_in = ^glb_seed;
    buf_in_cnt = 0;
    buf_out_cnt = 0;
    total_count = 0;
    dec_out_error = 0;
	
	
	
    // Open the files
    inputLLR_file = $fopen("E:\\Dropbox\\ViterbiDecoder\\benchmark\\Matlab_RAW_LLR.bin", "rb");
    if (inputLLR_file == 0) begin
        $display("Error: Failed to open input file, Matlab_RAW_LLR.bin\nExiting Simulation.");
        $finish;
    end
	
	matlabraw_file = $fopen("E:\\Dropbox\\ViterbiDecoder\\benchmark\\Matlab_RAW.bin", "rb");
    if (matlabraw_file == 0) begin
        $display("Error: Failed to open input file, Matlab_RAW.bin\nExiting Simulation.");
        $finish;
    end	
	#100000000
    // Close the files
    $fclose(inputLLR_file);	
	$fclose(f_dec_out);
	
	
	
end

// encoder input interface
always @(posedge clock or posedge reset)
begin
    if (reset)
		begin
			enc_bit_in <= 0;
			enc_valid_in <= 0;
			ccnt = 0;
			count = 0;
		end
    else
		begin
			ccnt = ccnt + 1;
			//if (ccnt == `SLICE_NUM && count < `CODE_LEN)
			if (ccnt == `SLICE_NUM)
				begin
					// input bit is valid
					enc_valid_in <= 1;

					// update encoder input bit
					enc_bit_in <= ^glb_seed;
					glb_seed <= glb_seed + 1;
					// update counters
					count = count + 1;
					ccnt = 0;
				end
			else
				begin
					enc_valid_in <= 0;	
				end
		end
end

// encoder module
encoder enc
(
	.clock(clock),
	.reset(reset),
	.srst(srst),
	.bit_in(enc_bit_in),
	.valid_in(enc_valid_in),
	.symbol0(enc_symbol0),
	.symbol1(enc_symbol1),
	.valid_out(enc_valid_out)
);

// connect the symbols from the encoder output to the decoder input
always @ (posedge reset or posedge clock)
begin
	if (reset)
		begin
			dec_valid_in <= 1'b0;
			//dec_symbol0 <= 0;
			//dec_symbol1 <= 0;
		end
	else if (enc_valid_out)
		begin
			dec_valid_in <= 1'b1;

			// if (enc_symbol0)//1 to 0111(+7), 0 to 1001(-7)
				// dec_symbol0 <= `Bit_Width'b0111;
			// else
				// dec_symbol0 <= `Bit_Width'b1001;

			// if (enc_symbol1)
				// dec_symbol1 <= `Bit_Width'b0111;
			// else
				// dec_symbol1 <= `Bit_Width'b1001;
				
			dec_symbol[7:0]<=$fgetc(inputLLR_file);
			// $display("%d\n",dec_symbol[7:0]);

			//dec_symbol0[`Bit_Width-1:0] <= $fgetc(inputLLR_file);
			//dec_symbol1[`Bit_Width-1:0] <= $fgetc(inputLLR_file);			
				
		end
	else
		dec_valid_in <= 1'b0;
		
end

// decoder module
vit_dec dec
(
    .mclk(clock),
    .rst(reset),
    .srst(srst),
    .valid_in(dec_valid_in),
	.symbol0(dec_symbol0),
	.symbol1(dec_symbol1),
    .pattern(pattern),
    .bit_out(dec_bit_out),
    .valid_out(dec_valid_out)
);
// test bench does not check puncturing
assign pattern = `SYMBOLS_NUM'b11;

// store the encoder input bits to check the decoder
always @ (posedge reset or posedge clock)
begin
	if (reset)
		buf_in_cnt <= 0;
	else if (enc_valid_in)
		begin
			// write next bit
			enc_in_buf[buf_in_cnt] <= enc_bit_in;

			// check overflow condition & update the buffer address counter
			if ((buf_in_cnt + 1) == buf_out_cnt)
			//if ((buf_in_cnt) == buf_out_cnt)
			begin
				$display("Error: data buffer overflow probably due to decoder latency.");
				repeat (5) @(posedge clock);
				`END_COMMAND;
			end
			else if (buf_in_cnt == 2*`OUT_NUM-1)
				buf_in_cnt <= 0;
			else
				buf_in_cnt <= buf_in_cnt + 1;
		end
end

// compare decoder output bits to encoder input bits
always @ (posedge reset or posedge clock)
begin
	if (reset)
	begin
		buf_out_cnt <= 0;
		total_count <= 0;
		dec_out_error <= 0;
	end
	else if (dec_valid_out)
	begin
		// compare decoder output to encoder input
		if (dec_bit_out != enc_in_buf[buf_out_cnt])
		begin
			//$display("Error: decoder output failure.");
			dec_out_error <= dec_out_error+1;
			//repeat (5) @(posedge clock);
            //`END_COMMAND;
		end

		// update buffer output counter
        if (buf_out_cnt == 2*`OUT_NUM-1)
			begin
				buf_out_cnt <= 0;
				//$display("Info: decoder output correct at bit index %d", total_count);
			end
		else
			begin
				buf_out_cnt <= buf_out_cnt + 1;
				total_count <= total_count + 1; 
			end	

		// update the total decoded bits counter
		
		
		if (total_count == `CODE_LEN)
			begin
				$display("Info: T0tal: %d, Error: %d, BER: %f", total_count,dec_out_error,dec_out_error/total_count);
				`END_COMMAND;
			end
		
	end
end

// record encoder inputs
integer f_enc_in;
initial
	f_enc_in = $fopen(`ENC_IN_FILE);

always @ (posedge clock)
begin
    if (enc_valid_in)
        $fwrite(f_enc_in,"%b\n", {enc_bit_in});
end

// record encoder outputs
integer f_enc_out;
initial
	f_enc_out = $fopen(`ENC_OUT_FILE);

always @ (posedge clock)
begin
    if (enc_valid_out)
        $fwrite(f_enc_out,"%b\n", {enc_symbol0, enc_symbol1});
end

// record decoder outputs

initial
	f_dec_out = $fopen(`DEC_OUT_FILE);

always @ (posedge clock)
begin
    if (dec_valid_out)
        $fwrite(f_dec_out,"%b\n", {dec_bit_out});
end

endmodule