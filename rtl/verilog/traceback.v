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

// radix of output number of DECS of one traceback action. 
// It is equal U+OUT_STAGE_RADIX
`define OUT_NUM_RADIX   6 
// output number of DECS in one traceback action. 
// It is equal 2^(U+OUT_STAGE_RADIX) and larger than TRACE_LEN.
`define OUT_NUM         64 
// trace back length. `LEN MUST smaller than `OUT_NUM 
`define LEN 			64 
// output decs one trace back action, 2^OUT_STAGE_RADIX, equal TRACE_LEN/n, 1<n<=2^u
`define OUT 			32 
// the size of ram is 1024bits, letting it be pow of two makes address 
// generation work well.

// equal to 2^(w+v) 
`define DEC_NUM 		32 
// DEC_NUM*`V 

// n=`LEN/`OUT 
`define DUMMY_BLOCK_NUM 2 
// the width of count of dummy block
`define DUMMY_CNT_WIDTH 2 

// one byte includes 2^(w+v) decs, each dec is a v-bits vector
module traceback
(
    clk, 
    rst, 
    srst,
    valid_in,
    dec0, 
    dec1, 
    dec2, 
    dec3, 
    dec4, 
    dec5, 
    dec6, 
    dec7, 
    dec8, 
    dec9, 
    dec10, 
    dec11, 
    dec12, 
    dec13, 
    dec14, 
    dec15, 
    dec16, 
    dec17, 
    dec18, 
    dec19, 
    dec20, 
    dec21, 
    dec22, 
    dec23, 
    dec24, 
    dec25, 
    dec26, 
    dec27, 
    dec28, 
    dec29, 
    dec30, 
    dec31, 
	sm_list,
	slice,
    // sm0, 
    // sm1, 
    // sm2, 
    // sm3, 
    // sm4, 
    // sm5, 
    // sm6, 
    // sm7, 
    // sm8, 
    // sm9, 
    // sm10, 
    // sm11, 
    // sm12, 
    // sm13, 
    // sm14, 
    // sm15, 
    // sm16, 
    // sm17, 
    // sm18, 
    // sm19, 
    // sm20, 
    // sm21, 
    // sm22, 
    // sm23, 
    // sm24, 
    // sm25, 
    // sm26, 
    // sm27, 
    // sm28, 
    // sm29, 
    // sm30, 
    // sm31, 	
    wr_en, 
    wr_data, 
    wr_adr, 
    rd_en, 
    rd_data, 
    rd_adr, 
    en_filo_in, 
    filo_in
); 


// // Compare 8 bytes at a time
// module greatest8bytes (
    // input wire [63:0] array,   // 8 byte array
    // output wire [7:0] indexG,
    // output wire [7:0] valueG
    // );

    // wire [7:0] value_l1[0:3];
    // wire [7:0] index_l1[0:3];

    // genvar i;
    // generate
    // for (i=0;i<8;i=i+2) begin :gen_comps_l1
        // C2D cl1 (array[i*8+7:i*8],
                 // i,
                 // array[(i+1)*8+7:(i+1)*8],
                 // (i+1),
                 // value_l1[i/2],
                 // index_l1[i/2]
                // );
    // end
    // endgenerate

    // wire [7:0] value_l2[0:1];
    // wire [7:0] index_l2[0:1];

    // generate
    // for (i=0;i<4;i=i+2) begin :gen_comps_l2
        // C2D cl2 (value_l1[i],
                 // index_l1[i],
                 // value_l1[i+1],
                 // index_l1[i+1],
                 // value_l2[i/2],
                 // index_l2[i/2]
                // );
    // end
    // endgenerate

    // wire [7:0] value_l3[0:0];
    // wire [7:0] index_l3[0:0];

    // generate
    // for (i=0;i<2;i=i+2) begin :gen_comps_l3
        // C2D cl3 (value_l2[i],
                 // index_l2[i],
                 // value_l2[i+1],
                 // index_l2[i+1],
                 // value_l3[i/2],
                 // index_l3[i/2]
                // );
    // end
    // endgenerate

    // assign indexG = index_l3[0];
    // assign valueG = value_l3[0];
// endmodule

input clk, rst, srst, valid_in;
input[`V-1:0] dec0, dec1, dec2, dec3, dec4, dec5, dec6, dec7, dec8, dec9, dec10, dec11, dec12, dec13, dec14, dec15, dec16, dec17, dec18, dec19, dec20, dec21, dec22, dec23, dec24, dec25, dec26, dec27, dec28, dec29, dec30, dec31;                   
//input[`SM_Width-1:0] sm0, sm1, sm2, sm3, sm4, sm5, sm6, sm7, sm8, sm9, sm10, sm11, sm12, sm13, sm14, sm15, sm16, sm17, sm18, sm19, sm20, sm21, sm22, sm23, sm24, sm25, sm26, sm27, sm28, sm29, sm30, sm31;
input [`SM_Width*32-1:0] sm_list;
input [`U-1:0] slice;
input[`RAM_BYTE_WIDTH-1:0] rd_data;
output[`RAM_ADR_WIDTH-1:0] rd_adr;
output rd_en, wr_en;
output[`RAM_BYTE_WIDTH-1:0] wr_data;
output[`RAM_ADR_WIDTH-1:0] wr_adr;
output en_filo_in;
output[`V-1:0] filo_in;


reg[`RAM_BYTE_WIDTH-1:0] wr_data;
reg[`RAM_BYTE_WIDTH-1:0] wr_data_buf;
reg[`RAM_ADR_WIDTH-1:0] wr_adr;
reg en_filo_in;
reg[`V-1:0] filo_in;			// v cannot be less than 1
reg wr_en;
reg[`RAM_ADR_WIDTH-`U-1:0] rd_adr_col;
reg[`DUMMY_CNT_WIDTH-1:0] dummy_cnt;
reg Is_not_first_3blocks, During_traback, During_send_data;
reg[`W+`V+`U-1:0] state;

wire[`RAM_ADR_WIDTH-`U-1:0] dec_rd_adr_col;
wire[`V-1:0] rd_dec0, rd_dec1, rd_dec2, rd_dec3, rd_dec4, rd_dec5, rd_dec6, rd_dec7, rd_dec8, rd_dec9, rd_dec10, rd_dec11, rd_dec12, rd_dec13, rd_dec14, rd_dec15, rd_dec16, rd_dec17, rd_dec18, rd_dec19, rd_dec20, rd_dec21, rd_dec22, rd_dec23, rd_dec24, rd_dec25, rd_dec26, rd_dec27, rd_dec28, rd_dec29, rd_dec30, rd_dec31;            
wire[`W+`V+`U-1:0] next_state;
reg[`W+`V+`U-1:0] next_state_dl;
reg[`V-1:0] dec;
wire[`U-1:0] rd_adr_byte;		// u cannot be less than 1
wire[`W+`V-1:0] rd_bit;
//!
reg rd_en_dl;
reg wr_rd_simu;
reg[`RAM_BYTE_WIDTH-1:0] wr_data_dl;

wire[`RAM_ADR_WIDTH-`U-1:0] wire_rd_adr_col;
wire[`U-1:0] next_rd_adr_byte;	
wire[`RAM_ADR_WIDTH-1:0] rd_adr_temp;	
assign rd_adr_temp={wire_rd_adr_col, next_rd_adr_byte};
//assign rd_adr=(rd_adr_temp>191)?(rd_adr_temp-64):rd_adr_temp;
assign rd_adr=rd_adr_temp;
wire traceback_start, selectmini_flag, selectmini_flag_temp;

assign selectmini_flag_temp=(dummy_cnt==`DUMMY_BLOCK_NUM&&wr_adr[`OUT_NUM_RADIX-1:0]==(`OUT_NUM-2));
//assign selectmini_flag=traceback_start||selectmini_flag_temp;
assign selectmini_flag=valid_in;
assign traceback_start=(dummy_cnt==`DUMMY_BLOCK_NUM&&wr_adr[`OUT_NUM_RADIX-1:0]==(`OUT_NUM-1));
assign rd_en=state_tracebuf_merge_on?0:(traceback_start? 0: (wr_adr[`OUT_NUM_RADIX-1:0]==(`LEN-1))? 0: During_traback);
//assign rd_en=(traceback_start? 0: (wr_adr[`OUT_NUM_RADIX-1:0]==(`LEN-1))? 0: During_traback);
assign next_rd_adr_byte=next_state[`W+`U-1:`W];
assign wire_rd_adr_col = (valid_in&&traceback_start)? wr_adr[`RAM_ADR_WIDTH-1:`U]: rd_adr_col;

assign {rd_dec0, rd_dec1, rd_dec2, rd_dec3, rd_dec4, rd_dec5, rd_dec6, rd_dec7, rd_dec8, rd_dec9, rd_dec10, rd_dec11, rd_dec12, rd_dec13, rd_dec14, rd_dec15, rd_dec16, rd_dec17, rd_dec18, rd_dec19, rd_dec20, rd_dec21, rd_dec22, rd_dec23, rd_dec24, rd_dec25, rd_dec26, rd_dec27, rd_dec28, rd_dec29, rd_dec30, rd_dec31} = wr_rd_simu?wr_data_dl:(rd_en_dl?(rd_data):wr_data_buf);       ///////////////////////////////////////////////////
//assign dec_rd_adr_col=(rd_adr_col==0)?95:(rd_adr_col-1);
assign dec_rd_adr_col=traceback_start?(wr_adr[`RAM_ADR_WIDTH-1:`U]-1):((rd_adr_col==0)?95:(rd_adr_col-1));

//assign dec_rd_adr_col=(rd_adr_col-1);
assign {rd_adr_byte, rd_bit}=state;
//assign next_state={state[`W+`U+`V-1:`V], dec};
//wire req_min_sm;
wire [`U-1:0] slice;
integer min_sm_num, i;
wire [`SM_Width-1:0]  min_sm_slice;
wire [5:0]  min_sm_index_slice;

wire [5:0]  min_sm_index;

wire en_com_in;

reg [`SM_Width-1:0]  min_sm_reg_slice0;
reg [5:0]  min_sm_index_reg_slice0;

//assign next_state = (wire_rd_adr_col==rd_adr_col)&&rd_en?  {state[`W+`U+`V-1:`V], dec}:min_sm_index;
//assign next_state=state_tracebuf_merge_on?(state_buffer[state_tracebuf_pos]):((traceback_start)?min_sm_index:{state[`W+`U+`V-1:`V], dec});
assign next_state=(traceback_start)?min_sm_index:(state_tracebuf_merge_on?(state_buffer[state_tracebuf_pos]):({state[`W+`U+`V-1:`V], dec}));

assign min_sm_index= (wr_en&&wr_adr[0]&&(traceback_start||state_pred_on))?((min_sm_reg_slice0[7]^min_sm_slice[7]^((min_sm_reg_slice0[6:0]<=min_sm_slice[6:0])))?min_sm_index_reg_slice0:min_sm_index_slice):'bx;

reg [`W+`V+`U-1:0] state_buffer[`LEN+`LEN-1:0];
reg [6:0] state_buf_pre_length;
reg [6:0] state_buf_pre_start;
reg state_pred_on;
wire [6:0] state_buf_pre_pos;
wire [6:0] state_buf_pre_nextpos;
assign state_buf_pre_pos=(state_buf_pre_start+state_buf_pre_length-1);
assign state_buf_pre_nextpos=state_buf_pre_pos+1;

reg [6:0] state_tracebuf_length;
reg [6:0] state_tracebuf_current_length;
reg [6:0] state_tracebuf_start;

reg state_tracebuf_on;
wire [6:0] state_tracebuf_pos;
assign state_tracebuf_pos=(state_tracebuf_start+state_tracebuf_current_length-2);
reg state_tracebuf_merge_on;

//wire [4:0] sm_list_index [15:0]={0,32,1,33,2,33,3,34,4,35,5,36,6,37,7,38,8,39,9,40,10,41,11,42,12,43,13,44,14,45,15,46};

//assign input_sum_array={sm0, sm1, sm2, sm3, sm4, sm5, sm6, sm7, sm8, sm9, sm10, sm11, sm12, sm13, sm14, sm15, sm16, sm17, sm18, sm19, sm20, sm21, sm22, sm23, sm24, sm25, sm26, sm27, sm28, sm29, sm30, sm31};

//reg start_trace_flag ;

// always @(posedge clk) 
// begin
		// //min_sm<=`MAX_PM;
        // for(i=0;i<`DEC_NUM;i=i+1)
			// begin
			// // if(sm_list[i*`SM_Width+:`SM_Width]<min_sm)
				// // begin
					// // min_sm<=sm_list[i*`SM_Width+:`SM_Width];
				// // end
			// $display("#%d: %d  ",i,sm_list[i*`SM_Width+:`SM_Width]);	
			// end
		// //min_sm<=sm_list[0*`SM_Width+:`SM_Width];	
		
// end	

SelectMiniPM selectminiPM(.array(sm_list),.slice(slice),.en_comp_in(selectmini_flag),.indexG(min_sm_index_slice),.valueG(min_sm_slice));
always @(posedge clk) 
begin
	if(selectmini_flag)
	begin
		min_sm_index_reg_slice0<=min_sm_index_slice;
		min_sm_reg_slice0<=min_sm_slice;
	end
	if(selectmini_flag_temp)
	begin
		wr_data_buf<=wr_data;		
	end
	
end

always @(rd_bit or rd_dec0 or rd_dec1 or rd_dec2 or rd_dec3 or rd_dec4 or rd_dec5 or rd_dec6 or rd_dec7 or rd_dec8 or rd_dec9 or rd_dec10 or rd_dec11 or rd_dec12 or rd_dec13 or rd_dec14 or rd_dec15 or rd_dec16 or rd_dec17 or rd_dec18 or rd_dec19 or rd_dec20 or rd_dec21 or rd_dec22 or rd_dec23 or rd_dec24 or rd_dec25 or rd_dec26 or rd_dec27 or rd_dec28 or rd_dec29 or rd_dec30 or rd_dec31)
begin
    case(rd_bit)
	5'd0: dec=rd_dec0; 
	5'd1: dec=rd_dec1; 
	5'd2: dec=rd_dec2; 
	5'd3: dec=rd_dec3; 
	5'd4: dec=rd_dec4; 
	5'd5: dec=rd_dec5; 
	5'd6: dec=rd_dec6; 
	5'd7: dec=rd_dec7; 
	5'd8: dec=rd_dec8; 
	5'd9: dec=rd_dec9; 
	5'd10: dec=rd_dec10; 
	5'd11: dec=rd_dec11; 
	5'd12: dec=rd_dec12; 
	5'd13: dec=rd_dec13; 
	5'd14: dec=rd_dec14; 
	5'd15: dec=rd_dec15; 
	5'd16: dec=rd_dec16; 
	5'd17: dec=rd_dec17; 
	5'd18: dec=rd_dec18; 
	5'd19: dec=rd_dec19; 
	5'd20: dec=rd_dec20; 
	5'd21: dec=rd_dec21; 
	5'd22: dec=rd_dec22; 
	5'd23: dec=rd_dec23; 
	5'd24: dec=rd_dec24; 
	5'd25: dec=rd_dec25; 
	5'd26: dec=rd_dec26; 
	5'd27: dec=rd_dec27; 
	5'd28: dec=rd_dec28; 
	5'd29: dec=rd_dec29; 
	5'd30: dec=rd_dec30; 
	5'd31: dec=rd_dec31; 
    endcase
end

// if y denote the `OUT_NUM_RADIX-1 to 0 bits of write address, x denote the column 
// address(`RAM_ADR_WIDTH-1 to u) of write address, z denote the column address of read 
// address, then z = x-y-1
// if y>=0 && y<=(len-out-1) trace back
// if y>=(len-out) && y<=(len-1) send out
// if y>=len && y<=(`OUT_NUM-1)  wait for next trace back
// 
// x=wr_adr[`RAM_ADR_WIDTH-1:`U]
// y=wr_adr[`OUT_NUM_RADIX-1:0]
// z=rd_adr_col=rd_adr[`RAM_ADR_WIDTH-1:`U]

// there are four registers, one is wr_adr, the second is th wr_data, the third is 
// reg_rd_adr(and rd_en), the fourth is reg_valid_in. All the other outputs including 
// wr_en are combination out en_filo_in, en_filo_out and filo_in are registers too, 
// but they are not the major part.
// valid_in --->> wr_adr, wr_data, wr_en --->> rd_adr, rd_en
// rd_adr++rd_data --->> filo_in 
always @(posedge clk or posedge rst)
begin
	if(rst)
		begin   
			rd_en_dl<=0;
			wr_data_dl<=0;
			wr_rd_simu<=0;
			min_sm_num<=0;
			//start_trace_flag<=0;
		end 
	else if (srst)
		begin   
			rd_en_dl<=0;
			wr_data_dl<=0;
			wr_rd_simu<=0;
			min_sm_num<=0;
		end
	else
		begin
			rd_en_dl<=rd_en;
			if(wr_en&&wr_adr==rd_adr)
				begin
					wr_rd_simu<=1;
					wr_data_dl<=wr_data;
				end
			else
				begin
					wr_rd_simu<=0;
				end
		end
end 
always @(posedge clk or posedge rst)
begin
    if(rst)
		begin
			dummy_cnt<=0;
			wr_data<=0;
			//wr_adr<=`OUT_NUM-1;
			wr_adr<=-1;
			wr_en<=0;
			rd_adr_col<=0;
			state<=0;
			
		//rd_adr_byte<=0;
			//rd_bit<=0;
			en_filo_in<=0;
			filo_in<=0;
			Is_not_first_3blocks<=0;
			During_traback<=0;
			During_send_data<=0;
			
			state_buffer[0]<=0;
			state_buf_pre_length<=0;
			state_buf_pre_start<=0;
			state_pred_on<=1;
			state_tracebuf_start<=0;
			state_tracebuf_merge_on<=0;
		end
    else if (srst)
		begin
			dummy_cnt <= 0;
			wr_data <= 0;
			//wr_adr <= `OUT_NUM-1;
			wr_adr<=-1;
			wr_en <= 0;
			rd_adr_col <= 0;
			state <= 0;
			en_filo_in <= 0;
			filo_in <= 0;
			Is_not_first_3blocks <= 0;
			During_traback <= 0;
			During_send_data <= 0;
			
			state_buffer[0]<=0;
			state_buf_pre_length<=0;
			state_buf_pre_start<=0;
			state_pred_on<=1;
			state_tracebuf_start<=0;
			state_tracebuf_merge_on<=0;
		end
    else if(valid_in)
		begin
			// if input is valid, we will always write decs into ram.
			wr_en<=1;
			wr_data<={dec0, dec1, dec2, dec3, dec4, dec5, dec6, dec7, dec8, dec9, dec10, dec11, dec12, dec13, dec14, dec15, dec16, dec17, dec18, dec19, dec20, dec21, dec22, dec23, dec24, dec25, dec26, dec27, dec28, dec29, dec30, dec31};
			
			if(wr_adr==191)
				wr_adr<=0;
			else
				wr_adr<=wr_adr+1; 
			
			if(wr_en&&wr_adr[0]&&state_pred_on)
			begin	
				if(!Is_not_first_3blocks&&state_buf_pre_length==0)//first element of a frame
					begin
						state_buffer[state_buf_pre_nextpos]<=0;
						state_buf_pre_length<=state_buf_pre_length+1;
					end
				else if((state_buffer[state_buf_pre_pos][5:1]==min_sm_index[4:0]))
					begin
							state_buffer[state_buf_pre_nextpos]<=min_sm_index;
							state_buf_pre_length<=state_buf_pre_length+1;
					end
				else
					begin
						state_pred_on<=0;
					end
			end	

			// if during trace back
			if(During_traback&&Is_not_first_3blocks)   
				begin
					// Trace back. Do three things: write decs to ram , read read decs from 
					// ram for generate next read address and send data to filo
					filo_in<=rd_bit[`V-1:0];
					rd_adr_col<=dec_rd_adr_col;
					state<={next_state[`W+`U-1:0], next_state[`W+`U+`V-1:`W+`U]};
					
					
					state_tracebuf_current_length<=state_tracebuf_current_length-1;
					//state_tracebuf_start<=state_tracebuf_start-1;
					if((state_tracebuf_on||traceback_start)&&!state_tracebuf_merge_on)
					begin
						if((state_tracebuf_current_length<=state_tracebuf_length)&&(state_buffer[state_tracebuf_pos]==next_state))
						begin
							state_tracebuf_merge_on<=1;						
						end	
						else
						begin
							if(state_tracebuf_current_length==`LEN)//first element
							begin
								state_buffer[state_tracebuf_pos+1]=next_state_dl;
							end
							
							state_buffer[state_tracebuf_pos]=next_state;
						end
					end
	
					
					// scratch
					// {rd_adr_byte, rd_bit}<={rd_adr_byte[`U-`V-1:0], rd_bit[`W+`V-1:`V], dec, rd_adr_byte[`U-1:`U-`V]};       
					// {rd_adr_byte, rd_bit}<={rd_bit[`W+`V-1:`V], dec, rd_adr_byte[`U-1:`U-`V]};    
					// 
				end
			
			// decide whether send data to filo
			// if have trace back enough bits, we can send out dec
			if((wr_adr[`OUT_NUM_RADIX-1:0]==`LEN-`OUT) && Is_not_first_3blocks)
				begin
					// Trace back and send out dec to filo
					en_filo_in<=1;
					During_send_data<=1;
					state_tracebuf_on<=0;
				end
			// else if have send out all data, stop send data
			else if((wr_adr[`OUT_NUM_RADIX-1:0]==`LEN-1) && Is_not_first_3blocks)
				begin
					// For the abnormal condition `LEN==`OUT_NUM
					en_filo_in<=1;
					During_send_data<=0;
				end 
			else
				en_filo_in<=During_send_data;
			
			// decide whether begin a trace or stop a trace
			if(wr_adr[`OUT_NUM_RADIX-1:0]==`OUT_NUM-1)
				begin
					// Initialize a trace action
					if(dummy_cnt==`DUMMY_BLOCK_NUM)   // It is already not the dummy block, so dont add it
						begin
							Is_not_first_3blocks<=1;
							During_traback<=1;
							rd_adr_col<=wr_adr[`RAM_ADR_WIDTH-1:`U]-1;
							state<={next_state[`W+`U-1:0], next_state[`W+`U+`V-1:`W+`U]};    //{(`U-`V)'b0, `W'b0, `V'b0, `V'b0};    ////////////////////
							
							
							state_pred_on<=1;
							state_buf_pre_start<=Is_not_first_3blocks?(state_buf_pre_start+`DEC_NUM):(state_buf_pre_start+`LEN);
							state_buf_pre_length<=0;
							
							
							state_tracebuf_length<=Is_not_first_3blocks?(state_buf_pre_length+`LEN-`DEC_NUM):state_buf_pre_length;
							
							state_tracebuf_current_length<=`LEN;
							state_tracebuf_start<=Is_not_first_3blocks?(state_tracebuf_start+`DEC_NUM):0;
							state_tracebuf_on<=1;
							next_state_dl<=next_state;
							
							
							state_tracebuf_merge_on<=0;
							//min_sm_reg<=min_sm;
							//min_sm_index_reg<=min_sm_index;
							//en_com_in=1;
						end
					else
						dummy_cnt<=dummy_cnt+1;
				end
			// else if we have trace back to the end
			else 
				if(wr_adr[`OUT_NUM_RADIX-1:0]==`LEN-1)
					During_traback<=0;
		end
    else    // input decs are not valid                  
		begin
			// Hold the right values
			wr_en<=0;
			en_filo_in<=0;
		end
end

// some scratch
// {next_rd_adr_byte,next_rd_adr_bit}={rd_adr_byte[`U-`V-1:0],rd_adr_bit[`W+`V-1:`V],dec, rd_adr_byte[`U-1:`U-`V]};  
// {wire_rd_adr_byte, wire_rd_bit}={rd_adr_byte[`U-`V-1:0], rd_bit[`W+`V-1:`V], dec, rd_adr_byte[`U-1:`U-`V]};       
//
endmodule
