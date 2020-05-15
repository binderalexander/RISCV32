-- (C) 2001-2018 Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files from any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License Subscription 
-- Agreement, Intel FPGA IP License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Intel and sold by 
-- Intel or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.all;

-- VHDL procedure declarations
package altera_avalon_mm_slave_bfm_vhdl_pkg is

   -- maximum number of Avalon-MM slave VHDL bfm
   constant MAX_VHDL_BFM : integer := 1024;
   
   -- maximum number of bits in Avalon-MM interface
   constant MM_MAX_BIT_W : integer := 1024;
   
   -- request type
   constant REQ_READ     : integer := 0;
   constant REQ_WRITE    : integer := 1;
   constant REQ_IDLE     : integer := 2;
   
   -- response status type
   constant AV_OKAY         : integer := 0;
   constant AV_RESERVED     : integer := 1;
   constant AV_SLAVE_ERROR  : integer := 2;
   constant AV_DECODE_ERROR : integer := 3;
   
   -- idle output configuration type
   constant LOW         : integer := 0;
   constant HIGH        : integer := 1;
   constant RANDOM      : integer := 2;
   constant UNKNOWN     : integer := 3;

   -- mm_slv_vhdl_api_e
   constant MM_SLV_SET_RESPONSE_TIMEOUT                        : integer := 0;
   constant MM_SLV_GET_COMMAND_QUEUE_SIZE                      : integer := 1;
   constant MM_SLV_GET_RESPONSE_QUEUE_SIZE                     : integer := 2;
   constant MM_SLV_SET_RESPONSE_LATENCY                        : integer := 3;
   constant MM_SLV_SET_RESPONSE_BURST_SIZE                     : integer := 4;
   constant MM_SLV_SET_RESPONSE_DATA                           : integer := 5;
   constant MM_SLV_PUSH_RESPONSE                               : integer := 6;
   constant MM_SLV_POP_COMMAND                                 : integer := 7;
   constant MM_SLV_GET_COMMAND_REQUEST                         : integer := 8;
   constant MM_SLV_GET_COMMAND_ADDRESS                         : integer := 9;
   constant MM_SLV_GET_COMMAND_BURST_COUNT                     : integer := 10;
   constant MM_SLV_GET_COMMAND_DATA                            : integer := 11;
   constant MM_SLV_GET_COMMAND_BYTE_ENABLE                     : integer := 12;
   constant MM_SLV_GET_COMMAND_BURST_CYCLE                     : integer := 13;
   constant MM_SLV_SET_INTERFACE_WAIT_TIME                     : integer := 14;
   constant MM_SLV_SET_COMMAND_TRANSACTION_MODE                : integer := 15;
   constant MM_SLV_GET_COMMAND_ARBITERLOCK                     : integer := 16;
   constant MM_SLV_GET_COMMAND_LOCK                            : integer := 17;
   constant MM_SLV_GET_COMMAND_DEBUGACCESS                     : integer := 18;
   constant MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE                 : integer := 19;
   constant MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE                 : integer := 20;
   constant MM_SLV_GET_COMMAND_TRANSACTION_ID                  : integer := 21;
   constant MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST          : integer := 22;
   constant MM_SLV_SET_RESPONSE_REQUEST                        : integer := 23;
   constant MM_SLV_SET_READ_RESPONSE_STATUS                    : integer := 24;
   constant MM_SLV_SET_WRITE_RESPONSE_STATUS                   : integer := 25;
   constant MM_SLV_SET_READ_RESPONSE_ID                        : integer := 26;
   constant MM_SLV_SET_WRITE_RESPONSE_ID                       : integer := 27;
   constant MM_SLV_GET_SLAVE_BFM_STATUS                        : integer := 28;
   constant MM_SLV_GET_PENDING_READ_LATENCY_CYCLE              : integer := 29;
   constant MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE             : integer := 30;
   constant MM_SLV_GET_CLKEN                                   : integer := 31;
   constant MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION         : integer := 32;
   constant MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION         : integer := 33;
   constant MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION    : integer := 34;
   constant MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION    : integer := 35;
   constant MM_SLV_INIT                                        : integer := 36;
   
   -- mm_slv_vhdl_event_e
   constant MM_SLV_EVENT_ERROR_EXCEED_MAX_PENDING_READS  : integer := 0;
   constant MM_SLV_EVENT_COMMAND_RECEIVED                : integer := 1;
   constant MM_SLV_EVENT_RESPONSE_ISSUED                 : integer := 2;
   constant MM_SLV_EVENT_MAX_RESPONSE_QUEUE_SIZE         : integer := 3;
   constant MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE         : integer := 4;
   
   -- VHDL API request interface type
   type mm_slv_vhdl_if_base_t is record
      req         : std_logic_vector (MM_SLV_INIT downto 0);
      ack         : std_logic_vector (MM_SLV_INIT downto 0);
      data_in0    : integer;
      data_in1    : integer;
      data_in2    : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
      data_out0   : integer;
      data_out1   : integer;
      data_out2   : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
      events      : std_logic_vector (MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE downto 0);
   end record;

   type mm_slv_vhdl_if_t is array(MAX_VHDL_BFM - 1 downto 0) of mm_slv_vhdl_if_base_t;
   
   signal req_if           : mm_slv_vhdl_if_t;
   signal ack_if           : mm_slv_vhdl_if_t;

   -- convert signal to integer
   function to_integer (OP: STD_LOGIC_VECTOR) return INTEGER;
   
   -- VHDL procedures
   procedure set_response_timeout         (timeout       : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_queue_size       (size          : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_response_queue_size      (size          : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_response_latency         (cycles        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);

   procedure set_response_latency         (cycles        : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_response_burst_size      (burst_size    : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_response_data            (data          : in std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_response_data            (data          : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure push_response                (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure pop_command                  (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   
   procedure get_command_request          (request       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_address          (address       : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_address          (address       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_burst_count      (burst_count   : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_data             (data          : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_data             (data          : out integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_byte_enable      (byte_enable   : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_byte_enable      (byte_enable   : out integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_burst_cycle      (burst_cycle   : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_interface_wait_time      (cycles        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_command_transaction_mode (mode          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_arbiterlock      (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_lock             (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_debugaccess      (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_max_response_queue_size  (size          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_min_response_queue_size  (size          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_transaction_id   (id            : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_command_write_response_request(request  : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_response_request         (request       : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_read_response_status     (status        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_write_response_status    (status        : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_read_response_id         (id            : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_write_response_id        (id            : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_slave_bfm_status         (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_pending_read_latency_cycle(cycles       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_pending_write_latency_cycle(cycles      : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_clken                    (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure init                         (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_idle_state_output_configuration   (config        : in integer;
                                                    bfm_id        : in integer;
                                                    signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_idle_state_output_configuration   (config        : out integer;
                                                    bfm_id        : in integer;
                                                    signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_idle_state_waitrequest_configuration (config        : in integer;
                                                       bfm_id        : in integer;
                                                       signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure get_idle_state_waitrequest_configuration (config        : out integer;
                                                       bfm_id        : in integer;
                                                       signal api_if : inout mm_slv_vhdl_if_t);
   
   procedure set_response_timeout         (timeout       : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_queue_size       (size          : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_response_queue_size      (size          : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_response_latency         (cycles        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);

   procedure set_response_latency         (cycles        : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_response_burst_size      (burst_size    : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_response_data            (data          : in std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_response_data            (data          : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure push_response                (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure pop_command                  (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   
   procedure get_command_request          (request       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_address          (address       : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_address          (address       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_burst_count      (burst_count   : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_data             (data          : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_data             (data          : out integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_byte_enable      (byte_enable   : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_byte_enable      (byte_enable   : out integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_burst_cycle      (burst_cycle   : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_interface_wait_time      (cycles        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_command_transaction_mode (mode          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_arbiterlock      (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_lock             (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_debugaccess      (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_max_response_queue_size  (size          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_min_response_queue_size  (size          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_transaction_id   (id            : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_command_write_response_request(request  : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_response_request         (request       : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_read_response_status     (status        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_write_response_status    (status        : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_read_response_id         (id            : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_write_response_id        (id            : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_slave_bfm_status         (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_pending_read_latency_cycle(cycles       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_pending_write_latency_cycle(cycles      : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_clken                    (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure init                         (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_idle_state_output_configuration   (config        : in integer;
                                                    bfm_id        : in integer;
                                                    signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_idle_state_output_configuration   (config        : out integer;
                                                    bfm_id        : in integer;
                                                    signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure set_idle_state_waitrequest_configuration (config        : in integer;
                                                       bfm_id        : in integer;
                                                       signal api_if : inout mm_slv_vhdl_if_base_t);
   
   procedure get_idle_state_waitrequest_configuration (config        : out integer;
                                                       bfm_id        : in integer;
                                                       signal api_if : inout mm_slv_vhdl_if_base_t);
   
   -- deprecated API
   procedure set_write_response_status    (status        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t);
   
   -- VHDL events
   procedure event_error_exceed_max_pending_reads  (bfm_id  : in integer);
   procedure event_command_received                (bfm_id  : in integer);
   procedure event_response_issued                 (bfm_id  : in integer);
   procedure event_max_response_queue_size         (bfm_id  : in integer);
   procedure event_min_response_queue_size         (bfm_id  : in integer);
   
end altera_avalon_mm_slave_bfm_vhdl_pkg;

-- VHDL procedures implementation
package body altera_avalon_mm_slave_bfm_vhdl_pkg is

   -- convert to integer
   function to_integer (OP: STD_LOGIC_VECTOR) return INTEGER is
      variable result : INTEGER := 0;
      variable tmp_op : STD_LOGIC_VECTOR (OP'range) := OP;
   begin
      if not (Is_X(OP)) then
         for i in OP'range loop
            if OP(i) = '1' then
               result := result + 2**i;
            end if;
         end loop; 
         return result;
      else
         return 0;
      end if;
   end to_integer;
   
   procedure set_response_timeout         (timeout       : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= timeout;
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_TIMEOUT) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_TIMEOUT) = '1');
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_TIMEOUT) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_TIMEOUT) = '0');
   end set_response_timeout;

   procedure get_command_queue_size       (size          : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin      
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_QUEUE_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_QUEUE_SIZE) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_QUEUE_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_QUEUE_SIZE) = '0');
      size := ack_if(bfm_id).data_out0;
   end get_command_queue_size;
   
   procedure get_response_queue_size      (size          : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_RESPONSE_QUEUE_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_RESPONSE_QUEUE_SIZE) = '1');
      api_if(bfm_id).req(MM_SLV_GET_RESPONSE_QUEUE_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_RESPONSE_QUEUE_SIZE) = '0');
      size := ack_if(bfm_id).data_out0;
   end get_response_queue_size;
   
   procedure set_response_latency         (cycles        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= cycles;
      api_if(bfm_id).data_in1 <= index;
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_LATENCY) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_LATENCY) = '1');
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_LATENCY) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_LATENCY) = '0');
   end set_response_latency;
   
   procedure set_response_latency         (cycles        : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= cycles;
      api_if(bfm_id).data_in1 <= 0;
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_LATENCY) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_LATENCY) = '1');
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_LATENCY) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_LATENCY) = '0');
   end set_response_latency;
   
   procedure set_response_burst_size      (burst_size    : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= burst_size;
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_BURST_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_BURST_SIZE) = '1');
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_BURST_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_BURST_SIZE) = '0');
   end set_response_burst_size;
   
   procedure set_response_data            (data          : in std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in1 <= index;
      api_if(bfm_id).data_in2 <= data;
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_DATA) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_DATA) = '1');
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_DATA) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_DATA) = '0');
   end set_response_data;
   
   procedure set_response_data            (data          : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      set_response_data(conv_std_logic_vector(data, MM_MAX_BIT_W), index, bfm_id, api_if);
   end set_response_data;
   
   procedure push_response                (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_PUSH_RESPONSE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_PUSH_RESPONSE) = '1');
      api_if(bfm_id).req(MM_SLV_PUSH_RESPONSE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_PUSH_RESPONSE) = '0');
   end push_response;
   
   procedure pop_command                  (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_POP_COMMAND) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_POP_COMMAND) = '1');
      api_if(bfm_id).req(MM_SLV_POP_COMMAND) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_POP_COMMAND) = '0');
   end pop_command;
   
   procedure get_command_request          (request       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_REQUEST) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_REQUEST) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_REQUEST) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_REQUEST) = '0');
      request := ack_if(bfm_id).data_out0;
   end get_command_request;
   
   procedure get_command_address          (address       : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
      begin
         api_if(bfm_id).req(MM_SLV_GET_COMMAND_ADDRESS) <= '1';
         wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_ADDRESS) = '1');
         api_if(bfm_id).req(MM_SLV_GET_COMMAND_ADDRESS) <= '0';
         wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_ADDRESS) = '0');
         address := ack_if(bfm_id).data_out2;
   end get_command_address;
   
   procedure get_command_address          (address       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   
      variable address_temp   : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
   begin
      get_command_address(address_temp, bfm_id, api_if);
      address := to_integer(address_temp);
   end get_command_address;
   
   procedure get_command_burst_count      (burst_count   : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_BURST_COUNT) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BURST_COUNT) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_BURST_COUNT) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BURST_COUNT) = '0');
      burst_count := ack_if(bfm_id).data_out0;
   end get_command_burst_count;
   
   procedure get_command_data             (data          : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in1 <= index;
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_DATA) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_DATA) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_DATA) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_DATA) = '0');
      data := ack_if(bfm_id).data_out2;
   end get_command_data;
   
   procedure get_command_data             (data          : out integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
      
      variable data_temp   : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
   begin
      get_command_data(data_temp, index, bfm_id, api_if);
      data := to_integer(data_temp);
   end get_command_data;
   
   procedure get_command_byte_enable      (byte_enable   : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in1 <= index;
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_BYTE_ENABLE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BYTE_ENABLE) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_BYTE_ENABLE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BYTE_ENABLE) = '0');
      byte_enable := ack_if(bfm_id).data_out2;
   end get_command_byte_enable;
   
   procedure get_command_byte_enable      (byte_enable   : out integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   
      variable byte_enable_temp   : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
   begin
      get_command_byte_enable(byte_enable_temp, index, bfm_id, api_if);
      byte_enable := to_integer(byte_enable_temp);
   end get_command_byte_enable;
   
   procedure get_command_burst_cycle      (burst_cycle   : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_BURST_CYCLE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BURST_CYCLE) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_BURST_CYCLE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BURST_CYCLE) = '0');
      burst_cycle := ack_if(bfm_id).data_out0;
   end get_command_burst_cycle;
   
   procedure set_interface_wait_time      (cycles        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= cycles;
      api_if(bfm_id).data_in1 <= index;
      api_if(bfm_id).req(MM_SLV_SET_INTERFACE_WAIT_TIME) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_INTERFACE_WAIT_TIME) = '1');
      api_if(bfm_id).req(MM_SLV_SET_INTERFACE_WAIT_TIME) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_INTERFACE_WAIT_TIME) = '0');
   end set_interface_wait_time;
   
   procedure set_command_transaction_mode (mode          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= mode;
      api_if(bfm_id).req(MM_SLV_SET_COMMAND_TRANSACTION_MODE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_COMMAND_TRANSACTION_MODE) = '1');
      api_if(bfm_id).req(MM_SLV_SET_COMMAND_TRANSACTION_MODE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_COMMAND_TRANSACTION_MODE) = '0');
   end set_command_transaction_mode;
   
   procedure get_command_arbiterlock      (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_ARBITERLOCK) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_ARBITERLOCK) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_ARBITERLOCK) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_ARBITERLOCK) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_command_arbiterlock;
   
   procedure get_command_lock             (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_LOCK) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_LOCK) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_LOCK) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_LOCK) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_command_lock;
   
   procedure get_command_debugaccess      (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_DEBUGACCESS) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_DEBUGACCESS) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_DEBUGACCESS) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_DEBUGACCESS) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_command_debugaccess;
   
   procedure set_max_response_queue_size  (size          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= size;
      api_if(bfm_id).req(MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE) = '1');
      api_if(bfm_id).req(MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE) = '0');
   end set_max_response_queue_size;
   
   procedure set_min_response_queue_size  (size          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= size;
      api_if(bfm_id).req(MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE) = '1');
      api_if(bfm_id).req(MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE) = '0');
   end set_min_response_queue_size;
   
   procedure get_command_transaction_id   (id            : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_TRANSACTION_ID) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_TRANSACTION_ID) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_TRANSACTION_ID) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_TRANSACTION_ID) = '0');
      id := ack_if(bfm_id).data_out0;
   end get_command_transaction_id;
   
   procedure get_command_write_response_request(request  : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST) = '1');
      api_if(bfm_id).req(MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST) = '0');
      request := ack_if(bfm_id).data_out0;
   end get_command_write_response_request;
   
   procedure set_response_request         (request       : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= request;
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_REQUEST) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_REQUEST) = '1');
      api_if(bfm_id).req(MM_SLV_SET_RESPONSE_REQUEST) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_REQUEST) = '0');
   end set_response_request;
   
   procedure set_read_response_status     (status        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= status;
      api_if(bfm_id).data_in1 <= index;
      api_if(bfm_id).req(MM_SLV_SET_READ_RESPONSE_STATUS) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_READ_RESPONSE_STATUS) = '1');
      api_if(bfm_id).req(MM_SLV_SET_READ_RESPONSE_STATUS) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_READ_RESPONSE_STATUS) = '0');
   end set_read_response_status;
   
   procedure set_write_response_status    (status        : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= status;
      api_if(bfm_id).req(MM_SLV_SET_WRITE_RESPONSE_STATUS) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_WRITE_RESPONSE_STATUS) = '1');
      api_if(bfm_id).req(MM_SLV_SET_WRITE_RESPONSE_STATUS) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_WRITE_RESPONSE_STATUS) = '0');
   end set_write_response_status;
   
   procedure set_read_response_id         (id            : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= id;
      api_if(bfm_id).req(MM_SLV_SET_READ_RESPONSE_ID) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_READ_RESPONSE_ID) = '1');
      api_if(bfm_id).req(MM_SLV_SET_READ_RESPONSE_ID) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_READ_RESPONSE_ID) = '0');
   end set_read_response_id;
   
   procedure set_write_response_id        (id            : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= id;
      api_if(bfm_id).req(MM_SLV_SET_WRITE_RESPONSE_ID) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_WRITE_RESPONSE_ID) = '1');
      api_if(bfm_id).req(MM_SLV_SET_WRITE_RESPONSE_ID) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_WRITE_RESPONSE_ID) = '0');
   end set_write_response_id;
   
   procedure get_slave_bfm_status         (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_SLAVE_BFM_STATUS) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_SLAVE_BFM_STATUS) = '1');
      api_if(bfm_id).req(MM_SLV_GET_SLAVE_BFM_STATUS) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_SLAVE_BFM_STATUS) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_slave_bfm_status;
   
   procedure get_pending_read_latency_cycle(cycles       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_PENDING_READ_LATENCY_CYCLE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_PENDING_READ_LATENCY_CYCLE) = '1');
      api_if(bfm_id).req(MM_SLV_GET_PENDING_READ_LATENCY_CYCLE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_PENDING_READ_LATENCY_CYCLE) = '0');
      cycles := ack_if(bfm_id).data_out0;
   end get_pending_read_latency_cycle;
   
   procedure get_pending_write_latency_cycle(cycles      : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE) = '1');
      api_if(bfm_id).req(MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE) = '0');
      cycles := ack_if(bfm_id).data_out0;
   end get_pending_write_latency_cycle;
   
   procedure get_clken                    (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_CLKEN) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_CLKEN) = '1');
      api_if(bfm_id).req(MM_SLV_GET_CLKEN) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_CLKEN) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_clken;
   
   procedure init                         (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_INIT) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_INIT) = '1');
      api_if(bfm_id).req(MM_SLV_INIT) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_INIT) = '0');
   end init;
   
   procedure set_idle_state_output_configuration   (config        : in integer;
                                                    bfm_id        : in integer;
                                                    signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= config;
      api_if(bfm_id).req(MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION) = '1');
      api_if(bfm_id).req(MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION) = '0');
   end set_idle_state_output_configuration;
   
   procedure get_idle_state_output_configuration   (config        : out integer;
                                                    bfm_id        : in integer;
                                                    signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION) = '1');
      api_if(bfm_id).req(MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION) = '0');
      config := ack_if(bfm_id).data_out0;
   end get_idle_state_output_configuration;
   
   procedure set_idle_state_waitrequest_configuration (config        : in integer;
                                                       bfm_id        : in integer;
                                                       signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).data_in0 <= config;
      api_if(bfm_id).req(MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION) = '1');
      api_if(bfm_id).req(MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION) = '0');
   end set_idle_state_waitrequest_configuration;
   
   procedure get_idle_state_waitrequest_configuration (config        : out integer;
                                                       bfm_id        : in integer;
                                                       signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      api_if(bfm_id).req(MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION) = '1');
      api_if(bfm_id).req(MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION) = '0');
      config := ack_if(bfm_id).data_out0;
   end get_idle_state_waitrequest_configuration;
   
   procedure set_response_timeout         (timeout       : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= timeout;
      api_if.req(MM_SLV_SET_RESPONSE_TIMEOUT) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_TIMEOUT) = '1');
      api_if.req(MM_SLV_SET_RESPONSE_TIMEOUT) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_TIMEOUT) = '0');
   end set_response_timeout;

   procedure get_command_queue_size       (size          : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin      
      api_if.req(MM_SLV_GET_COMMAND_QUEUE_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_QUEUE_SIZE) = '1');
      api_if.req(MM_SLV_GET_COMMAND_QUEUE_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_QUEUE_SIZE) = '0');
      size := ack_if(bfm_id).data_out0;
   end get_command_queue_size;
   
   procedure get_response_queue_size      (size          : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_RESPONSE_QUEUE_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_RESPONSE_QUEUE_SIZE) = '1');
      api_if.req(MM_SLV_GET_RESPONSE_QUEUE_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_RESPONSE_QUEUE_SIZE) = '0');
      size := ack_if(bfm_id).data_out0;
   end get_response_queue_size;
   
   procedure set_response_latency         (cycles        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= cycles;
      api_if.data_in1 <= index;
      api_if.req(MM_SLV_SET_RESPONSE_LATENCY) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_LATENCY) = '1');
      api_if.req(MM_SLV_SET_RESPONSE_LATENCY) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_LATENCY) = '0');
   end set_response_latency;
   
   procedure set_response_latency         (cycles        : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= cycles;
      api_if.data_in1 <= 0;
      api_if.req(MM_SLV_SET_RESPONSE_LATENCY) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_LATENCY) = '1');
      api_if.req(MM_SLV_SET_RESPONSE_LATENCY) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_LATENCY) = '0');
   end set_response_latency;
   
   procedure set_response_burst_size      (burst_size    : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= burst_size;
      api_if.req(MM_SLV_SET_RESPONSE_BURST_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_BURST_SIZE) = '1');
      api_if.req(MM_SLV_SET_RESPONSE_BURST_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_BURST_SIZE) = '0');
   end set_response_burst_size;
   
   procedure set_response_data            (data          : in std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in1 <= index;
      api_if.data_in2 <= data;
      api_if.req(MM_SLV_SET_RESPONSE_DATA) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_DATA) = '1');
      api_if.req(MM_SLV_SET_RESPONSE_DATA) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_DATA) = '0');
   end set_response_data;
   
   procedure set_response_data            (data          : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      set_response_data(conv_std_logic_vector(data, MM_MAX_BIT_W), index, bfm_id, api_if);
   end set_response_data;
   
   procedure push_response                (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_PUSH_RESPONSE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_PUSH_RESPONSE) = '1');
      api_if.req(MM_SLV_PUSH_RESPONSE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_PUSH_RESPONSE) = '0');
   end push_response;
   
   procedure pop_command                  (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_POP_COMMAND) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_POP_COMMAND) = '1');
      api_if.req(MM_SLV_POP_COMMAND) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_POP_COMMAND) = '0');
   end pop_command;
   
   procedure get_command_request          (request       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_COMMAND_REQUEST) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_REQUEST) = '1');
      api_if.req(MM_SLV_GET_COMMAND_REQUEST) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_REQUEST) = '0');
      request := ack_if(bfm_id).data_out0;
   end get_command_request;
   
   procedure get_command_address          (address       : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
      begin
         api_if.req(MM_SLV_GET_COMMAND_ADDRESS) <= '1';
         wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_ADDRESS) = '1');
         api_if.req(MM_SLV_GET_COMMAND_ADDRESS) <= '0';
         wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_ADDRESS) = '0');
         address := ack_if(bfm_id).data_out2;
   end get_command_address;
   
   procedure get_command_address          (address       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   
      variable address_temp   : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
   begin
      get_command_address(address_temp, bfm_id, api_if);
      address := to_integer(address_temp);
   end get_command_address;
   
   procedure get_command_burst_count      (burst_count   : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_COMMAND_BURST_COUNT) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BURST_COUNT) = '1');
      api_if.req(MM_SLV_GET_COMMAND_BURST_COUNT) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BURST_COUNT) = '0');
      burst_count := ack_if(bfm_id).data_out0;
   end get_command_burst_count;
   
   procedure get_command_data             (data          : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in1 <= index;
      api_if.req(MM_SLV_GET_COMMAND_DATA) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_DATA) = '1');
      api_if.req(MM_SLV_GET_COMMAND_DATA) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_DATA) = '0');
      data := ack_if(bfm_id).data_out2;
   end get_command_data;
   
   procedure get_command_data             (data          : out integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
      
      variable data_temp   : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
   begin
      get_command_data(data_temp, index, bfm_id, api_if);
      data := to_integer(data_temp);
   end get_command_data;
   
   procedure get_command_byte_enable      (byte_enable   : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in1 <= index;
      api_if.req(MM_SLV_GET_COMMAND_BYTE_ENABLE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BYTE_ENABLE) = '1');
      api_if.req(MM_SLV_GET_COMMAND_BYTE_ENABLE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BYTE_ENABLE) = '0');
      byte_enable := ack_if(bfm_id).data_out2;
   end get_command_byte_enable;
   
   procedure get_command_byte_enable      (byte_enable   : out integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   
      variable byte_enable_temp   : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
   begin
      get_command_byte_enable(byte_enable_temp, index, bfm_id, api_if);
      byte_enable := to_integer(byte_enable_temp);
   end get_command_byte_enable;
   
   procedure get_command_burst_cycle      (burst_cycle   : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_COMMAND_BURST_CYCLE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BURST_CYCLE) = '1');
      api_if.req(MM_SLV_GET_COMMAND_BURST_CYCLE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_BURST_CYCLE) = '0');
      burst_cycle := ack_if(bfm_id).data_out0;
   end get_command_burst_cycle;
   
   procedure set_interface_wait_time      (cycles        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= cycles;
      api_if.data_in1 <= index;
      api_if.req(MM_SLV_SET_INTERFACE_WAIT_TIME) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_INTERFACE_WAIT_TIME) = '1');
      api_if.req(MM_SLV_SET_INTERFACE_WAIT_TIME) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_INTERFACE_WAIT_TIME) = '0');
   end set_interface_wait_time;
   
   procedure set_command_transaction_mode (mode          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= mode;
      api_if.req(MM_SLV_SET_COMMAND_TRANSACTION_MODE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_COMMAND_TRANSACTION_MODE) = '1');
      api_if.req(MM_SLV_SET_COMMAND_TRANSACTION_MODE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_COMMAND_TRANSACTION_MODE) = '0');
   end set_command_transaction_mode;
   
   procedure get_command_arbiterlock      (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_COMMAND_ARBITERLOCK) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_ARBITERLOCK) = '1');
      api_if.req(MM_SLV_GET_COMMAND_ARBITERLOCK) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_ARBITERLOCK) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_command_arbiterlock;
   
   procedure get_command_lock             (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_COMMAND_LOCK) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_LOCK) = '1');
      api_if.req(MM_SLV_GET_COMMAND_LOCK) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_LOCK) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_command_lock;
   
   procedure get_command_debugaccess      (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_COMMAND_DEBUGACCESS) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_DEBUGACCESS) = '1');
      api_if.req(MM_SLV_GET_COMMAND_DEBUGACCESS) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_DEBUGACCESS) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_command_debugaccess;
   
   procedure set_max_response_queue_size  (size          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= size;
      api_if.req(MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE) = '1');
      api_if.req(MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_MAX_RESPONSE_QUEUE_SIZE) = '0');
   end set_max_response_queue_size;
   
   procedure set_min_response_queue_size  (size          : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= size;
      api_if.req(MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE) = '1');
      api_if.req(MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_MIN_RESPONSE_QUEUE_SIZE) = '0');
   end set_min_response_queue_size;
   
   procedure get_command_transaction_id   (id            : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_COMMAND_TRANSACTION_ID) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_TRANSACTION_ID) = '1');
      api_if.req(MM_SLV_GET_COMMAND_TRANSACTION_ID) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_TRANSACTION_ID) = '0');
      id := ack_if(bfm_id).data_out0;
   end get_command_transaction_id;
   
   procedure get_command_write_response_request(request  : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST) = '1');
      api_if.req(MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_COMMAND_WRITE_RESPONSE_REQUEST) = '0');
      request := ack_if(bfm_id).data_out0;
   end get_command_write_response_request;
   
   procedure set_response_request         (request       : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= request;
      api_if.req(MM_SLV_SET_RESPONSE_REQUEST) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_REQUEST) = '1');
      api_if.req(MM_SLV_SET_RESPONSE_REQUEST) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_RESPONSE_REQUEST) = '0');
   end set_response_request;
   
   procedure set_read_response_status     (status        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= status;
      api_if.data_in1 <= index;
      api_if.req(MM_SLV_SET_READ_RESPONSE_STATUS) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_READ_RESPONSE_STATUS) = '1');
      api_if.req(MM_SLV_SET_READ_RESPONSE_STATUS) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_READ_RESPONSE_STATUS) = '0');
   end set_read_response_status;
   
   procedure set_write_response_status    (status        : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= status;
      api_if.req(MM_SLV_SET_WRITE_RESPONSE_STATUS) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_WRITE_RESPONSE_STATUS) = '1');
      api_if.req(MM_SLV_SET_WRITE_RESPONSE_STATUS) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_WRITE_RESPONSE_STATUS) = '0');
   end set_write_response_status;
   
   procedure set_read_response_id         (id            : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= id;
      api_if.req(MM_SLV_SET_READ_RESPONSE_ID) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_READ_RESPONSE_ID) = '1');
      api_if.req(MM_SLV_SET_READ_RESPONSE_ID) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_READ_RESPONSE_ID) = '0');
   end set_read_response_id;
   
   procedure set_write_response_id        (id            : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= id;
      api_if.req(MM_SLV_SET_WRITE_RESPONSE_ID) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_WRITE_RESPONSE_ID) = '1');
      api_if.req(MM_SLV_SET_WRITE_RESPONSE_ID) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_WRITE_RESPONSE_ID) = '0');
   end set_write_response_id;
   
   procedure get_slave_bfm_status         (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_SLAVE_BFM_STATUS) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_SLAVE_BFM_STATUS) = '1');
      api_if.req(MM_SLV_GET_SLAVE_BFM_STATUS) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_SLAVE_BFM_STATUS) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_slave_bfm_status;
   
   procedure get_pending_read_latency_cycle(cycles       : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_PENDING_READ_LATENCY_CYCLE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_PENDING_READ_LATENCY_CYCLE) = '1');
      api_if.req(MM_SLV_GET_PENDING_READ_LATENCY_CYCLE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_PENDING_READ_LATENCY_CYCLE) = '0');
      cycles := ack_if(bfm_id).data_out0;
   end get_pending_read_latency_cycle;
   
   procedure get_pending_write_latency_cycle(cycles      : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE) = '1');
      api_if.req(MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_PENDING_WRITE_LATENCY_CYCLE) = '0');
      cycles := ack_if(bfm_id).data_out0;
   end get_pending_write_latency_cycle;
   
   procedure get_clken                    (status        : out integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_CLKEN) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_CLKEN) = '1');
      api_if.req(MM_SLV_GET_CLKEN) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_CLKEN) = '0');
      status := ack_if(bfm_id).data_out0;
   end get_clken;
   
   procedure init                         (bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_INIT) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_INIT) = '1');
      api_if.req(MM_SLV_INIT) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_INIT) = '0');
   end init;
   
   procedure set_idle_state_output_configuration   (config        : in integer;
                                                    bfm_id        : in integer;
                                                    signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= config;
      api_if.req(MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION) = '1');
      api_if.req(MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_IDLE_STATE_OUTPUT_CONFIGURATION) = '0');
   end set_idle_state_output_configuration;
   
   procedure get_idle_state_output_configuration   (config        : out integer;
                                                    bfm_id        : in integer;
                                                    signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION) = '1');
      api_if.req(MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_IDLE_STATE_OUTPUT_CONFIGURATION) = '0');
      config := ack_if(bfm_id).data_out0;
   end get_idle_state_output_configuration;
   
   procedure set_idle_state_waitrequest_configuration (config        : in integer;
                                                       bfm_id        : in integer;
                                                       signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.data_in0 <= config;
      api_if.req(MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION) = '1');
      api_if.req(MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_SET_IDLE_STATE_WAITREQUEST_CONFIGURATION) = '0');
   end set_idle_state_waitrequest_configuration;
   
   procedure get_idle_state_waitrequest_configuration (config        : out integer;
                                                       bfm_id        : in integer;
                                                       signal api_if : inout mm_slv_vhdl_if_base_t) is
   begin
      api_if.req(MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION) <= '1';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION) = '1');
      api_if.req(MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION) <= '0';
      wait until (ack_if(bfm_id).ack(MM_SLV_GET_IDLE_STATE_WAITREQUEST_CONFIGURATION) = '0');
      config := ack_if(bfm_id).data_out0;
   end get_idle_state_waitrequest_configuration;
   
   -- deprecated API
   procedure set_write_response_status    (status        : in integer;
                                           index         : in integer;
                                           bfm_id        : in integer;
                                           signal api_if : inout mm_slv_vhdl_if_t) is
   begin
      report "set_write_response_status API is no longer supported";
   end set_write_response_status;
   
   -- VHDL events implementation
   procedure event_error_exceed_max_pending_reads     (bfm_id  : in integer) is
   begin
      wait until (ack_if(bfm_id).events(MM_SLV_EVENT_ERROR_EXCEED_MAX_PENDING_READS) = '1');
   end event_error_exceed_max_pending_reads;
   
   procedure event_command_received                (bfm_id  : in integer) is
   begin
      wait until (ack_if(bfm_id).events(MM_SLV_EVENT_COMMAND_RECEIVED) = '1');
   end event_command_received;
   
   procedure event_response_issued                 (bfm_id  : in integer) is
   begin
      wait until (ack_if(bfm_id).events(MM_SLV_EVENT_RESPONSE_ISSUED) = '1');
   end event_response_issued;
   
   procedure event_max_response_queue_size         (bfm_id  : in integer) is
   begin
      wait until (ack_if(bfm_id).events(MM_SLV_EVENT_MAX_RESPONSE_QUEUE_SIZE) = '1');
   end event_max_response_queue_size;
   
   procedure event_min_response_queue_size         (bfm_id  : in integer) is
   begin
      wait until (ack_if(bfm_id).events(MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE) = '1');
   end event_min_response_queue_size;
   
end altera_avalon_mm_slave_bfm_vhdl_pkg;
