// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1ns /  1ns

// synthesis translate_off
// enum for VHDL procedure
typedef enum int {
   MM_SLV_SET_RESPONSE_TIMEOUT                        = 32'd0,
   MM_SLV_GET_COMMAND_QUEUE_SIZE                      = 32'd1,
   MM_SLV_GET_RESPONSE_QUEUE_SIZE                     = 32'd2,
   MM_SLV_SET_RESPONSE_LATENCY                        = 32'd3,
   MM_SLV_SET_RESPONSE_BURST_SIZE                     = 32'd4,
   MM_SLV_SET_RESPONSE_DATA                           = 32'd5,
   MM_SLV_PUSH_RESPONSE                               = 32'd6,
   MM_SLV_POP_COMMAND                                 = 32'd7,
   MM_SLV_GET_COMMAND_REQUEST                         = 32'd8,
   MM_SLV_GET_COMMAND_ADDRESS                         = 32'd9,
   MM_SLV_GET_COMMAND_BURST_COUNT                     = 32'd10,
   MM_SLV_GET_COMMAND_DATA                            = 32'd11,
   MM_SLV_GET_COMMAND_BYTE_ENABLE                     = 32'd12,
   MM_SLV_GET_COMMAND_BURST_CYCLE                     = 32'd13,
   MM_SLV_SET_INTERFACE_WAIT_TIME                     = 32'd14,
   MM_SLV_SET_COMMAND_TRANSACTION_MODE                = 32'd15,
   MM_SLV_GET_COMMAND_ARBITERLOCK                     = 32'd16,
   MM_SLV_GET_COMMAND_LOCK                            = 32'd17,
   MM_SLV_GET_COMMAND_DEBUGACCESS                     = 32'd18,
   MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE                 = 32'd19,
   MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE                 = 32'd20,
   MM_SLV_GET_COMMAND_TRANSACTION_ID                  = 32'd21,
   MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST          = 32'd22,
   MM_SLV_SET_RESPONSE_REQUEST                        = 32'd23,
   MM_SLV_SET_READ_RESPONSE_STATUS                    = 32'd24,
   MM_SLV_SET_WRITE_RESPONSE_STATUS                   = 32'd25,
   MM_SLV_SET_READ_RESPONSE_ID                        = 32'd26,
   MM_SLV_SET_WRITE_RESPONSE_ID                       = 32'd27,
   MM_SLV_GET_SLAVE_BFM_STATUS                        = 32'd28,
   MM_SLV_GET_PENDING_READ_LATENCY_CYCLE              = 32'd29,
   MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE             = 32'd30,
   MM_SLV_GET_CLKEN                                   = 32'd31,
   MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION         = 32'd32,
   MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION         = 32'd33,
   MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION    = 32'd34,
   MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION    = 32'd35,
   MM_SLV_INIT                                        = 32'd36
} mm_slv_vhdl_api_e;

// enum for VHDL event
typedef enum int {
   MM_SLV_EVENT_ERROR_EXCEED_MAX_PENDING_READS  = 32'd0,
   MM_SLV_EVENT_COMMAND_RECEIVED                = 32'd1,
   MM_SLV_EVENT_RESPONSE_ISSUED                 = 32'd2,
   MM_SLV_EVENT_MAX_RESPONSE_QUEUE_SIZE         = 32'd3,
   MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE         = 32'd4
} mm_slv_vhdl_event_e;

// synthesis translate_on
module altera_avalon_mm_slave_bfm_vhdl_wrapper #(
   parameter AV_ADDRESS_W                 = 16,
             AV_SYMBOL_W                  = 8,
             AV_NUMSYMBOLS                = 4,
             AV_BURSTCOUNT_W              = 3,
             USE_READ                     = 1,
             USE_WRITE                    = 1,
             USE_ADDRESS                  = 1,
             USE_BYTE_ENABLE              = 1,
             USE_BURSTCOUNT               = 1,
             USE_READ_DATA                = 1,
             USE_READ_DATA_VALID          = 1,
             USE_WRITE_DATA               = 1,
             USE_BEGIN_TRANSFER           = 1,
             USE_BEGIN_BURST_TRANSFER     = 1,
             USE_WAIT_REQUEST             = 1,
             USE_ARBITERLOCK              = 0,
             USE_LOCK                     = 0,
             USE_DEBUGACCESS              = 0,
             USE_TRANSACTIONID            = 0,
             USE_WRITERESPONSE            = 0,
             USE_READRESPONSE             = 0,
             USE_CLKEN                    = 0,
             AV_FIX_READ_LATENCY          = 0,
             AV_MAX_PENDING_READS         = 1,
             AV_MAX_PENDING_WRITES        = 0,
             AV_BURST_LINEWRAP            = 0,
             AV_BURST_BNDR_ONLY           = 0,
             AV_READ_WAIT_TIME            = 0,
             AV_WRITE_WAIT_TIME           = 0,
             REGISTER_WAITREQUEST         = 0,
             AV_REGISTERINCOMINGSIGNALS   = 0,
             MM_MAX_BIT_W                 = 1024
)(
   input                                              clk,
   input                                              reset,
   output                                             avs_waitrequest,
   output                                             avs_readdatavalid,
   output [lindex(AV_SYMBOL_W * AV_NUMSYMBOLS):0]     avs_readdata,
   input                                              avs_write,
   input                                              avs_read,
   input  [lindex(AV_ADDRESS_W):0]                    avs_address,
   input  [lindex(AV_NUMSYMBOLS):0]                   avs_byteenable,
   input  [lindex(AV_BURSTCOUNT_W):0]                 avs_burstcount,
   input                                              avs_beginbursttransfer,
   input                                              avs_begintransfer,
   input  [lindex(AV_SYMBOL_W * AV_NUMSYMBOLS):0]     avs_writedata,
   input                                              avs_arbiterlock,
   input                                              avs_lock,
   input                                              avs_debugaccess,
   input  [7:0]                                       avs_transactionid,
   output [7:0]                                       avs_readid,
   output [7:0]                                       avs_writeid,
   output [1:0]                                       avs_response,
   input                                              avs_writeresponserequest,
   output                                             avs_writeresponsevalid,
   input                                              avs_clken,
   
   // VHDL API request interface
   input  bit [MM_SLV_INIT:0]                         req,
   output bit [MM_SLV_INIT:0]                         ack,
   input  int                                         data_in0,
   input  int                                         data_in1,
   input  bit [lindex(MM_MAX_BIT_W): 0]               data_in2,
   output int                                         data_out0,
   output int                                         data_out1,
   output bit [lindex(MM_MAX_BIT_W): 0]               data_out2,
   output bit [MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE:0]events
);
   
   // synthesis translate_off
   import avalon_mm_pkg::*;
   import avalon_utilities_pkg::*;
   
   function int lindex;
      // returns the left index for a vector having a declared width 
      // when width is 0, then the left index is set to 0 rather than -1
      input [31:0] width;
      lindex = (width > 0) ? (width-1) : 0;
   endfunction
   
   altera_avalon_mm_slave_bfm #(
      .AV_ADDRESS_W(AV_ADDRESS_W),
      .AV_SYMBOL_W(AV_SYMBOL_W),
      .AV_NUMSYMBOLS(AV_NUMSYMBOLS),
      .AV_BURSTCOUNT_W(AV_BURSTCOUNT_W),
      .USE_READ(USE_READ),
      .USE_WRITE(USE_WRITE),
      .USE_ADDRESS(USE_ADDRESS),
      .USE_BYTE_ENABLE(USE_BYTE_ENABLE),
      .USE_BURSTCOUNT(USE_BURSTCOUNT),
      .USE_READ_DATA(USE_READ_DATA),
      .USE_READ_DATA_VALID(USE_READ_DATA_VALID),
      .USE_WRITE_DATA(USE_WRITE_DATA),
      .USE_BEGIN_TRANSFER(USE_BEGIN_TRANSFER),
      .USE_BEGIN_BURST_TRANSFER(USE_BEGIN_BURST_TRANSFER),
      .USE_WAIT_REQUEST(USE_WAIT_REQUEST),
      .USE_ARBITERLOCK(USE_ARBITERLOCK),
      .USE_LOCK(USE_LOCK),
      .USE_DEBUGACCESS(USE_DEBUGACCESS),
      .USE_TRANSACTIONID(USE_TRANSACTIONID),
      .USE_WRITERESPONSE(USE_WRITERESPONSE),
      .USE_READRESPONSE(USE_READRESPONSE),
      .USE_CLKEN(USE_CLKEN),
      .AV_FIX_READ_LATENCY(AV_FIX_READ_LATENCY),
      .AV_MAX_PENDING_READS(AV_MAX_PENDING_READS),
      .AV_MAX_PENDING_WRITES(AV_MAX_PENDING_WRITES),
      .AV_BURST_LINEWRAP(AV_BURST_LINEWRAP),
      .AV_BURST_BNDR_ONLY(AV_BURST_BNDR_ONLY),
      .AV_READ_WAIT_TIME(AV_READ_WAIT_TIME),
      .AV_WRITE_WAIT_TIME(AV_WRITE_WAIT_TIME),
      .REGISTER_WAITREQUEST(REGISTER_WAITREQUEST),
      .AV_REGISTERINCOMINGSIGNALS(AV_REGISTERINCOMINGSIGNALS)
   ) mm_slave (
      .clk(clk),
      .reset(reset),
      .avs_waitrequest(avs_waitrequest),
      .avs_readdatavalid(avs_readdatavalid),
      .avs_readdata(avs_readdata),
      .avs_write(avs_write),
      .avs_read(avs_read),
      .avs_address(avs_address),
      .avs_byteenable(avs_byteenable),
      .avs_burstcount(avs_burstcount),
      .avs_beginbursttransfer(avs_beginbursttransfer),
      .avs_begintransfer(avs_begintransfer),
      .avs_writedata(avs_writedata),
      .avs_arbiterlock(avs_arbiterlock),
      .avs_lock(avs_lock),
      .avs_debugaccess(avs_debugaccess),
      .avs_transactionid(avs_transactionid),
      .avs_readid(avs_readid),
      .avs_response(avs_response),
      .avs_writeresponserequest(avs_writeresponserequest),
      .avs_writeresponsevalid(avs_writeresponsevalid),
      .avs_writeresponse(),
      .avs_readresponse(),
      .avs_writeid(avs_writeid),
      .avs_clken(avs_clken)
   );

   // logic block to handle API calls from VHDL request interface
      initial forever begin
      @(posedge req[MM_SLV_SET_RESPONSE_TIMEOUT]);
      ack[MM_SLV_SET_RESPONSE_TIMEOUT] = 1;
      mm_slave.set_response_timeout(data_in0);
      ack[MM_SLV_SET_RESPONSE_TIMEOUT] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_QUEUE_SIZE]);
      ack[MM_SLV_GET_COMMAND_QUEUE_SIZE] = 1;
      data_out0 = mm_slave.get_command_queue_size();
      ack[MM_SLV_GET_COMMAND_QUEUE_SIZE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_RESPONSE_QUEUE_SIZE]);
      ack[MM_SLV_GET_RESPONSE_QUEUE_SIZE] = 1;
      data_out0 = mm_slave.get_response_queue_size();
      ack[MM_SLV_GET_RESPONSE_QUEUE_SIZE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_RESPONSE_LATENCY]);
      ack[MM_SLV_SET_RESPONSE_LATENCY] = 1;
      mm_slave.set_response_latency(data_in0, data_in1);
      ack[MM_SLV_SET_RESPONSE_LATENCY] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_RESPONSE_BURST_SIZE]);
      ack[MM_SLV_SET_RESPONSE_BURST_SIZE] = 1;
      mm_slave.set_response_burst_size(data_in0);
      ack[MM_SLV_SET_RESPONSE_BURST_SIZE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_RESPONSE_DATA]);
      ack[MM_SLV_SET_RESPONSE_DATA] = 1;
      mm_slave.set_response_data(data_in2, data_in1);
      ack[MM_SLV_SET_RESPONSE_DATA] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_PUSH_RESPONSE]);
      ack[MM_SLV_PUSH_RESPONSE] = 1;
      mm_slave.push_response();
      ack[MM_SLV_PUSH_RESPONSE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_POP_COMMAND]);
      ack[MM_SLV_POP_COMMAND] = 1;
      mm_slave.pop_command();
      ack[MM_SLV_POP_COMMAND] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_REQUEST]);
      ack[MM_SLV_GET_COMMAND_REQUEST] = 1;
      data_out0 = mm_slave.get_command_request();
      ack[MM_SLV_GET_COMMAND_REQUEST] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_ADDRESS]);
      ack[MM_SLV_GET_COMMAND_ADDRESS] = 1;
      data_out2 = mm_slave.get_command_address();
      ack[MM_SLV_GET_COMMAND_ADDRESS] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_BURST_COUNT]);
      ack[MM_SLV_GET_COMMAND_BURST_COUNT] = 1;
      data_out0 = mm_slave.get_command_burst_count();
      ack[MM_SLV_GET_COMMAND_BURST_COUNT] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_DATA]);
      ack[MM_SLV_GET_COMMAND_DATA] = 1;
      data_out2 = mm_slave.get_command_data(data_in1);
      ack[MM_SLV_GET_COMMAND_DATA] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_BYTE_ENABLE]);
      ack[MM_SLV_GET_COMMAND_BYTE_ENABLE] = 1;
      data_out2 = mm_slave.get_command_byte_enable(data_in1);
      ack[MM_SLV_GET_COMMAND_BYTE_ENABLE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_BURST_CYCLE]);
      ack[MM_SLV_GET_COMMAND_BURST_CYCLE] = 1;
      data_out0 = mm_slave.get_command_burst_cycle();
      ack[MM_SLV_GET_COMMAND_BURST_CYCLE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_INTERFACE_WAIT_TIME]);
      ack[MM_SLV_SET_INTERFACE_WAIT_TIME] = 1;
      mm_slave.set_interface_wait_time(data_in0, data_in1);
      ack[MM_SLV_SET_INTERFACE_WAIT_TIME] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_COMMAND_TRANSACTION_MODE]);
      ack[MM_SLV_SET_COMMAND_TRANSACTION_MODE] = 1;
      mm_slave.set_command_transaction_mode(data_in0);
      ack[MM_SLV_SET_COMMAND_TRANSACTION_MODE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_ARBITERLOCK]);
      ack[MM_SLV_GET_COMMAND_ARBITERLOCK] = 1;
      data_out0 = mm_slave.get_command_arbiterlock();
      ack[MM_SLV_GET_COMMAND_ARBITERLOCK] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_LOCK]);
      ack[MM_SLV_GET_COMMAND_LOCK] = 1;
      data_out0 = mm_slave.get_command_lock();
      ack[MM_SLV_GET_COMMAND_LOCK] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_DEBUGACCESS]);
      ack[MM_SLV_GET_COMMAND_DEBUGACCESS] = 1;
      data_out0 = mm_slave.get_command_debugaccess();
      ack[MM_SLV_GET_COMMAND_DEBUGACCESS] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE]);
      ack[MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE] = 1;
      mm_slave.set_max_response_queue_size(data_in0);
      ack[MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE]);
      ack[MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE] = 1;
      mm_slave.set_min_response_queue_size(data_in0);
      ack[MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_TRANSACTION_ID]);
      ack[MM_SLV_GET_COMMAND_TRANSACTION_ID] = 1;
      data_out0 = mm_slave.get_command_transaction_id();
      ack[MM_SLV_GET_COMMAND_TRANSACTION_ID] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST]);
      ack[MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST] = 1;
      data_out0 = mm_slave.get_command_write_response_request();
      ack[MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_RESPONSE_REQUEST]);
      ack[MM_SLV_SET_RESPONSE_REQUEST] = 1;
      mm_slave.set_response_request(Request_t'(data_in0));
      ack[MM_SLV_SET_RESPONSE_REQUEST] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_READ_RESPONSE_STATUS]);
      ack[MM_SLV_SET_READ_RESPONSE_STATUS] = 1;
      mm_slave.set_read_response_status(AvalonResponseStatus_t'(data_in0), data_in1);
      ack[MM_SLV_SET_READ_RESPONSE_STATUS] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_WRITE_RESPONSE_STATUS]);
      ack[MM_SLV_SET_WRITE_RESPONSE_STATUS] = 1;
      mm_slave.set_write_response_status(AvalonResponseStatus_t'(data_in0));
      ack[MM_SLV_SET_WRITE_RESPONSE_STATUS] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_READ_RESPONSE_ID]);
      ack[MM_SLV_SET_READ_RESPONSE_ID] = 1;
      mm_slave.set_read_response_id(data_in0);
      ack[MM_SLV_SET_READ_RESPONSE_ID] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_WRITE_RESPONSE_ID]);
      ack[MM_SLV_SET_WRITE_RESPONSE_ID] = 1;
      mm_slave.set_write_response_id(data_in0);
      ack[MM_SLV_SET_WRITE_RESPONSE_ID] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_SLAVE_BFM_STATUS]);
      ack[MM_SLV_GET_SLAVE_BFM_STATUS] = 1;
      data_out0 = mm_slave.get_slave_bfm_status();
      ack[MM_SLV_GET_SLAVE_BFM_STATUS] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_PENDING_READ_LATENCY_CYCLE]);
      ack[MM_SLV_GET_PENDING_READ_LATENCY_CYCLE] = 1;
      data_out0 = mm_slave.get_pending_read_latency_cycle();
      ack[MM_SLV_GET_PENDING_READ_LATENCY_CYCLE] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_CLKEN]);
      ack[MM_SLV_GET_CLKEN] = 1;
      data_out0 = mm_slave.get_clken();
      ack[MM_SLV_GET_CLKEN] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION]);
      ack[MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION] = 1;
      mm_slave.set_idle_state_output_configuration(IdleOutputValue_t'(data_in0));
      ack[MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION]);
      ack[MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION] = 1;
      data_out0 = mm_slave.get_idle_state_output_configuration();
      ack[MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION]);
      ack[MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION] = 1;
      mm_slave.set_idle_state_waitrequest_configuration(IdleOutputValue_t'(data_in0));
      ack[MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION]);
      ack[MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION] = 1;
      data_out0 = mm_slave.get_idle_state_waitrequest_configuration();
      ack[MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION] <= 0;
   end
   
   initial forever begin
      @(posedge req[MM_SLV_INIT]);
      ack[MM_SLV_INIT] = 1;
      mm_slave.init();
      ack[MM_SLV_INIT] <= 0;
   end
   
   // logic blocks to handle event trigger
   always @(mm_slave.signal_error_exceed_max_pending_reads) begin
      events[MM_SLV_EVENT_ERROR_EXCEED_MAX_PENDING_READS] = 1;
      events[MM_SLV_EVENT_ERROR_EXCEED_MAX_PENDING_READS] <= 0;
   end
   
   always @(mm_slave.signal_command_received) begin
      events[MM_SLV_EVENT_COMMAND_RECEIVED] = 1;
      events[MM_SLV_EVENT_COMMAND_RECEIVED] <= 0;
   end
   
   always @(mm_slave.signal_response_issued) begin
      events[MM_SLV_EVENT_RESPONSE_ISSUED] = 1;
      events[MM_SLV_EVENT_RESPONSE_ISSUED] <= 0;
   end
   
   always @(mm_slave.signal_max_response_queue_size) begin
      events[MM_SLV_EVENT_MAX_RESPONSE_QUEUE_SIZE] = 1;
      events[MM_SLV_EVENT_MAX_RESPONSE_QUEUE_SIZE] <= 0;
   end
   
   always @(mm_slave.signal_min_response_queue_size) begin
      events[MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE] = 1;
      events[MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE] <= 0;
   end
   
// synthesis translate_on
endmodule 
