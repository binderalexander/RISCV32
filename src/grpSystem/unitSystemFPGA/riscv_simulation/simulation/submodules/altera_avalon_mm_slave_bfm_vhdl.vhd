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

library work;
use work.all;
use work.altera_avalon_mm_slave_bfm_vhdl_pkg.all;

entity altera_avalon_mm_slave_bfm_vhdl is
   generic (
      AV_ADDRESS_W                  : integer := 16;
      AV_SYMBOL_W                   : integer := 8;
      AV_NUMSYMBOLS                 : integer := 4;
      AV_BURSTCOUNT_W               : integer := 3;
      AV_READRESPONSE_W             : integer := 8;
      AV_WRITERESPONSE_W            : integer := 8;
      USE_READ                      : integer := 1;
      USE_WRITE                     : integer := 1;
      USE_ADDRESS                   : integer := 1;
      USE_BYTE_ENABLE               : integer := 1;
      USE_BURSTCOUNT                : integer := 1;
      USE_READ_DATA                 : integer := 1;
      USE_READ_DATA_VALID           : integer := 1;
      USE_WRITE_DATA                : integer := 1;
      USE_BEGIN_TRANSFER            : integer := 1;
      USE_BEGIN_BURST_TRANSFER      : integer := 1;
      USE_WAIT_REQUEST              : integer := 1;
      USE_ARBITERLOCK               : integer := 0;
      USE_LOCK                      : integer := 0;
      USE_DEBUGACCESS               : integer := 0;
      USE_TRANSACTIONID             : integer := 0;
      USE_WRITERESPONSE             : integer := 0;
      USE_READRESPONSE              : integer := 0;
      USE_CLKEN                     : integer := 0;
      AV_FIX_READ_LATENCY           : integer := 0;
      AV_MAX_PENDING_READS          : integer := 1;
      AV_MAX_PENDING_WRITES         : integer := 0;
      AV_BURST_LINEWRAP             : integer := 0;
      AV_BURST_BNDR_ONLY            : integer := 0;
      AV_READ_WAIT_TIME             : integer := 0;
      AV_WRITE_WAIT_TIME            : integer := 0;
      REGISTER_WAITREQUEST          : integer := 0;
      AV_REGISTERINCOMINGSIGNALS    : integer := 0;
      VHDL_ID                       : integer := 0
   );
   port (
      clk                           : in std_logic;
      reset                         : in std_logic;
      avs_clken                     : in std_logic;
      avs_address                   : in std_logic_vector (AV_ADDRESS_W - 1 downto 0);
      avs_waitrequest               : out std_logic;
      avs_burstcount                : in std_logic_vector (AV_BURSTCOUNT_W - 1 downto 0);
      avs_byteenable                : in std_logic_vector (AV_NUMSYMBOLS - 1 downto 0);
      avs_begintransfer             : in std_logic;
      avs_beginbursttransfer        : in std_logic;
      avs_read                      : in std_logic;
      avs_readdatavalid             : out std_logic;
      avs_readdata                  : out std_logic_vector ((AV_SYMBOL_W*AV_NUMSYMBOLS) - 1 downto 0);
      avs_write                     : in std_logic;
      avs_writedata                 : in std_logic_vector ((AV_SYMBOL_W*AV_NUMSYMBOLS) - 1 downto 0);
      avs_transactionid             : in std_logic_vector (7 downto 0);
      avs_readid                    : out std_logic_vector (7 downto 0);
      avs_writeid                   : out std_logic_vector (7 downto 0);
      avs_readresponse              : out std_logic_vector (AV_READRESPONSE_W - 1 downto 0);
      avs_writeresponse             : out std_logic_vector (AV_READRESPONSE_W - 1 downto 0);
      avs_writeresponserequest      : in std_logic;
      avs_writeresponsevalid        : out std_logic;
      avs_arbiterlock               : in std_logic;
      avs_lock                      : in std_logic;
      avs_debugaccess               : in std_logic;
      avs_response                  : out std_logic_vector (1 downto 0)
   );
end altera_avalon_mm_slave_bfm_vhdl;

architecture mm_slave_bfm_vhdl_a of altera_avalon_mm_slave_bfm_vhdl is

   component altera_avalon_mm_slave_bfm_vhdl_wrapper
      generic (
      AV_ADDRESS_W                  : integer := 16;
      AV_SYMBOL_W                   : integer := 8;
      AV_NUMSYMBOLS                 : integer := 4;
      AV_BURSTCOUNT_W               : integer := 3;
      USE_READ                      : integer := 1;
      USE_WRITE                     : integer := 1;
      USE_ADDRESS                   : integer := 1;
      USE_BYTE_ENABLE               : integer := 1;
      USE_BURSTCOUNT                : integer := 1;
      USE_READ_DATA                 : integer := 1;
      USE_READ_DATA_VALID           : integer := 1;
      USE_WRITE_DATA                : integer := 1;
      USE_BEGIN_TRANSFER            : integer := 1;
      USE_BEGIN_BURST_TRANSFER      : integer := 1;
      USE_WAIT_REQUEST              : integer := 1;
      USE_ARBITERLOCK               : integer := 0;
      USE_LOCK                      : integer := 0;
      USE_DEBUGACCESS               : integer := 0;
      USE_TRANSACTIONID             : integer := 0;
      USE_WRITERESPONSE             : integer := 0;
      USE_READRESPONSE              : integer := 0;
      USE_CLKEN                     : integer := 0;
      AV_FIX_READ_LATENCY           : integer := 0;
      AV_MAX_PENDING_READS          : integer := 1;
      AV_MAX_PENDING_WRITES         : integer := 0;
      AV_BURST_LINEWRAP             : integer := 0;
      AV_BURST_BNDR_ONLY            : integer := 0;
      AV_READ_WAIT_TIME             : integer := 0;
      AV_WRITE_WAIT_TIME            : integer := 0;
      REGISTER_WAITREQUEST          : integer := 0;
      AV_REGISTERINCOMINGSIGNALS    : integer := 0;
      MM_MAX_BIT_W                  : integer := 1024
      );
      port (
         clk                        : in std_logic;
         reset                      : in std_logic;
         avs_clken                  : in std_logic;
         avs_address                : in std_logic_vector (AV_ADDRESS_W - 1 downto 0);
         avs_waitrequest            : out std_logic;
         avs_burstcount             : in std_logic_vector (AV_BURSTCOUNT_W - 1 downto 0);
         avs_byteenable             : in std_logic_vector (AV_NUMSYMBOLS - 1 downto 0);
         avs_begintransfer          : in std_logic;
         avs_beginbursttransfer     : in std_logic;
         avs_read                   : in std_logic;
         avs_readdatavalid          : out std_logic;
         avs_readdata               : out std_logic_vector ((AV_SYMBOL_W*AV_NUMSYMBOLS) - 1 downto 0);
         avs_write                  : in std_logic;
         avs_writedata              : in std_logic_vector ((AV_SYMBOL_W*AV_NUMSYMBOLS) - 1 downto 0);
         avs_transactionid          : in std_logic_vector (7 downto 0);
         avs_readid                 : out std_logic_vector (7 downto 0);
         avs_writeid                : out std_logic_vector (7 downto 0);
         avs_response               : out std_logic_vector (1 downto 0);
         avs_writeresponserequest   : in std_logic;
         avs_writeresponsevalid     : out std_logic;
         avs_arbiterlock            : in std_logic;
         avs_lock                   : in std_logic;
         avs_debugaccess            : in std_logic;
         -- VHDL request interface
         req                        : in std_logic_vector (MM_SLV_INIT downto 0);
         ack                        : out std_logic_vector (MM_SLV_INIT downto 0);
         data_in0                   : in integer;
         data_in1                   : in integer;
         data_in2                   : in std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
         data_out0                  : out integer;
         data_out1                  : out integer;
         data_out2                  : out std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
         events                     : out std_logic_vector (MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE downto 0)
      );
   end component;
   
   -- VHDL request interface
   signal req        : std_logic_vector (MM_SLV_INIT downto 0);
   signal ack        : std_logic_vector (MM_SLV_INIT downto 0);
   signal data_in0   : integer;
   signal data_in1   : integer;
   signal data_in2   : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
   signal data_out0  : integer;
   signal data_out1  : integer;
   signal data_out2  : std_logic_vector (MM_MAX_BIT_W - 1 downto 0);
   signal events     : std_logic_vector (MM_SLV_EVENT_MIN_RESPONSE_QUEUE_SIZE downto 0);
   
   begin
   
   req                                  <= req_if(VHDL_ID).req;
   data_in0                             <= req_if(VHDL_ID).data_in0;
   data_in1                             <= req_if(VHDL_ID).data_in1;
   data_in2                             <= req_if(VHDL_ID).data_in2;
   ack_if(VHDL_ID).ack                  <= ack;
   ack_if(VHDL_ID).data_out0            <= data_out0;
   ack_if(VHDL_ID).data_out1            <= data_out1;
   ack_if(VHDL_ID).data_out2            <= data_out2;
   ack_if(VHDL_ID).events               <= events;
   
   mm_slave_vhdl_wrapper : altera_avalon_mm_slave_bfm_vhdl_wrapper
      generic map (
         AV_ADDRESS_W                   => AV_ADDRESS_W,
         AV_SYMBOL_W                    => AV_SYMBOL_W,
         AV_NUMSYMBOLS                  => AV_NUMSYMBOLS,
         AV_BURSTCOUNT_W                => AV_BURSTCOUNT_W,
         USE_READ                       => USE_READ,
         USE_WRITE                      => USE_WRITE,
         USE_ADDRESS                    => USE_ADDRESS,
         USE_BYTE_ENABLE                => USE_BYTE_ENABLE,
         USE_BURSTCOUNT                 => USE_BURSTCOUNT,
         USE_READ_DATA                  => USE_READ_DATA,
         USE_READ_DATA_VALID            => USE_READ_DATA_VALID,
         USE_WRITE_DATA                 => USE_WRITE_DATA,
         USE_BEGIN_TRANSFER             => USE_BEGIN_TRANSFER,
         USE_BEGIN_BURST_TRANSFER       => USE_BEGIN_BURST_TRANSFER,
         USE_WAIT_REQUEST               => USE_WAIT_REQUEST,
         USE_ARBITERLOCK                => USE_ARBITERLOCK,
         USE_LOCK                       => USE_LOCK,
         USE_DEBUGACCESS                => USE_DEBUGACCESS,
         USE_TRANSACTIONID              => USE_TRANSACTIONID,
         USE_WRITERESPONSE              => USE_WRITERESPONSE,
         USE_READRESPONSE               => USE_READRESPONSE,
         USE_CLKEN                      => USE_CLKEN,
         AV_FIX_READ_LATENCY            => AV_FIX_READ_LATENCY,
         AV_MAX_PENDING_READS           => AV_MAX_PENDING_READS,
         AV_MAX_PENDING_WRITES          => AV_MAX_PENDING_WRITES,
         AV_BURST_LINEWRAP              => AV_BURST_LINEWRAP,
         AV_BURST_BNDR_ONLY             => AV_BURST_BNDR_ONLY,
         AV_READ_WAIT_TIME              => AV_READ_WAIT_TIME,
         AV_WRITE_WAIT_TIME             => AV_WRITE_WAIT_TIME,
         REGISTER_WAITREQUEST           => REGISTER_WAITREQUEST,
         AV_REGISTERINCOMINGSIGNALS     => AV_REGISTERINCOMINGSIGNALS,
         MM_MAX_BIT_W                   => MM_MAX_BIT_W
      )
      port map (
         clk                            => clk,
         reset                          => reset,
         avs_clken                      => avs_clken,
         avs_address                    => avs_address,
         avs_waitrequest                => avs_waitrequest,
         avs_burstcount                 => avs_burstcount,
         avs_byteenable                 => avs_byteenable,
         avs_begintransfer              => avs_begintransfer,
         avs_beginbursttransfer         => avs_beginbursttransfer,
         avs_read                       => avs_read,
         avs_readdatavalid              => avs_readdatavalid,
         avs_readdata                   => avs_readdata,
         avs_write                      => avs_write,
         avs_writedata                  => avs_writedata,
         avs_transactionid              => avs_transactionid,
         avs_readid                     => avs_readid,
         avs_writeid                    => avs_writeid,
         avs_response                   => avs_response,
         avs_writeresponserequest       => avs_writeresponserequest,
         avs_writeresponsevalid         => avs_writeresponsevalid,
         avs_arbiterlock                => avs_arbiterlock,
         avs_lock                       => avs_lock,
         avs_debugaccess                => avs_debugaccess,
         req                            => req,
         ack                            => ack,
         data_in0                       => data_in0,
         data_in1                       => data_in1,
         data_in2                       => data_in2,
         data_out0                      => data_out0,
         data_out1                      => data_out1,
         data_out2                      => data_out2,
         events                         => events
      );
   
end mm_slave_bfm_vhdl_a;
