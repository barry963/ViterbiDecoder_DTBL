
-- Thanks for XHDL
--/////////////////////////////////////////////////////////////////
--////                                    //////
--/////////////////////////////////////////////////////////////////
--/                                                             ///
--/ This file is generated by Viterbi HDL Code Generator(VHCG)  ///
--/ which is written by Mike Johnson at OpenCores.org  and      ///
--/ distributed under GPL license.                              ///
--/                                                             ///
--/ If you have any advice,                                     ///
--/ please email to jhonson.zhu@gmail.com                       ///
--/                                                             ///
--/////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////
--////                                    //////
--/////////////////////////////////////////////////////////////////
--/                                                             ///
--/ This file is generated by Viterbi HDL Code Generator(VHCG)  ///
--/ which is written by Mike Johnson at OpenCores.org  and      ///
--/ distributed under GPL license.                              ///
--/                                                             ///
--/ If you have any advice,                                     ///
--/ please email to jhonson.zhu@gmail.com                       ///
--/                                                             ///
--/////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////

-- radix of output number of DECS of one traceback action.
-- It is equal U+OUT_STAGE_RADIX
-- output number of DECS in one traceback action.
-- It is equal 2^(U+OUT_STAGE_RADIX) and larger than TRACE_LEN.
-- trace back length. `LEN MUST smaller than `OUT_NUM
-- output decs one trace back action, 2^OUT_STAGE_RADIX, equal TRACE_LEN/n, 1<n<=2^u
-- the size of ram is 1024bits, letting it be pow of two makes address
-- generation work well.
-- equal to 2^(w+v)
-- DEC_NUM*`V
-- n=`LEN/`OUT
-- the width of count of dummy block
-- one byte includes 2^(w+v) decs, each dec is a v-bits vector
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
Use work.vhcg_pkg.all;
ENTITY traceback IS
   PORT (
      clk                     : IN std_logic;
      rst                     : IN std_logic;
      srst                    : IN std_logic;
      valid_in                : IN std_logic;
      dec0                    : IN std_logic;
      dec1                    : IN std_logic;
      dec2                    : IN std_logic;
      dec3                    : IN std_logic;
      dec4                    : IN std_logic;
      dec5                    : IN std_logic;
      dec6                    : IN std_logic;
      dec7                    : IN std_logic;
      dec8                    : IN std_logic;
      dec9                    : IN std_logic;
      dec10                   : IN std_logic;
      dec11                   : IN std_logic;
      dec12                   : IN std_logic;
      dec13                   : IN std_logic;
      dec14                   : IN std_logic;
      dec15                   : IN std_logic;
      dec16                   : IN std_logic;
      dec17                   : IN std_logic;
      dec18                   : IN std_logic;
      dec19                   : IN std_logic;
      dec20                   : IN std_logic;
      dec21                   : IN std_logic;
      dec22                   : IN std_logic;
      dec23                   : IN std_logic;
      dec24                   : IN std_logic;
      dec25                   : IN std_logic;
      dec26                   : IN std_logic;
      dec27                   : IN std_logic;
      dec28                   : IN std_logic;
      dec29                   : IN std_logic;
      dec30                   : IN std_logic;
      dec31                   : IN std_logic;
      wr_en                   : OUT std_logic;
      wr_data                 : OUT std_logic_vector(32 - 1 DOWNTO 0);
      wr_adr                  : OUT std_logic_vector(10 - 1 DOWNTO 0);
      rd_en                   : OUT std_logic;
      rd_data                 : IN std_logic_vector(32 - 1 DOWNTO 0);
      rd_adr                  : OUT std_logic_vector(10 - 1 DOWNTO 0);
      en_filo_in              : OUT std_logic;
      filo_in                 : OUT std_logic);
END traceback;

ARCHITECTURE translated OF traceback IS


   SIGNAL rd_adr_col               :  std_logic_vector(10 - 1 - 1 DOWNTO 0);
   SIGNAL dummy_cnt                :  std_logic_vector(2 - 1 DOWNTO 0);
   SIGNAL Is_not_first_3blocks     :  std_logic;
   SIGNAL During_traback           :  std_logic;
   SIGNAL During_send_data         :  std_logic;
   SIGNAL state                    :  std_logic_vector(4 + 1 + 1 - 1 DOWNTO 0);
   SIGNAL dec_rd_adr_col           :  std_logic_vector(10 - 1 - 1 DOWNTO 0);
   SIGNAL rd_dec0                  :  std_logic;
   SIGNAL rd_dec1                  :  std_logic;
   SIGNAL rd_dec2                  :  std_logic;
   SIGNAL rd_dec3                  :  std_logic;
   SIGNAL rd_dec4                  :  std_logic;
   SIGNAL rd_dec5                  :  std_logic;
   SIGNAL rd_dec6                  :  std_logic;
   SIGNAL rd_dec7                  :  std_logic;
   SIGNAL rd_dec8                  :  std_logic;
   SIGNAL rd_dec9                  :  std_logic;
   SIGNAL rd_dec10                 :  std_logic;
   SIGNAL rd_dec11                 :  std_logic;
   SIGNAL rd_dec12                 :  std_logic;
   SIGNAL rd_dec13                 :  std_logic;
   SIGNAL rd_dec14                 :  std_logic;
   SIGNAL rd_dec15                 :  std_logic;
   SIGNAL rd_dec16                 :  std_logic;
   SIGNAL rd_dec17                 :  std_logic;
   SIGNAL rd_dec18                 :  std_logic;
   SIGNAL rd_dec19                 :  std_logic;
   SIGNAL rd_dec20                 :  std_logic;
   SIGNAL rd_dec21                 :  std_logic;
   SIGNAL rd_dec22                 :  std_logic;
   SIGNAL rd_dec23                 :  std_logic;
   SIGNAL rd_dec24                 :  std_logic;
   SIGNAL rd_dec25                 :  std_logic;
   SIGNAL rd_dec26                 :  std_logic;
   SIGNAL rd_dec27                 :  std_logic;
   SIGNAL rd_dec28                 :  std_logic;
   SIGNAL rd_dec29                 :  std_logic;
   SIGNAL rd_dec30                 :  std_logic;
   SIGNAL rd_dec31                 :  std_logic;
   SIGNAL next_state               :  std_logic_vector(4 + 1 + 1 - 1 DOWNTO 0);
   SIGNAL dec                      :  std_logic;
   SIGNAL rd_adr_byte              :  std_logic;
   SIGNAL rd_bit                   :  std_logic_vector(4 + 1 - 1 DOWNTO 0);
   --!
   SIGNAL rd_en_dl                 :  std_logic;
   SIGNAL wr_rd_simu               :  std_logic;
   SIGNAL wr_data_dl               :  std_logic_vector(32 - 1 DOWNTO 0);
   SIGNAL wire_rd_adr_col          :  std_logic_vector(10 - 1 - 1 DOWNTO 0);
   SIGNAL next_rd_adr_byte         :  std_logic;
   SIGNAL temp_vhcg8               :  std_logic;
   SIGNAL temp_vhcg9               :  std_logic;
   SIGNAL temp_vhcg10              :  std_logic_vector(10 - 1 DOWNTO 1);
   SIGNAL temp_vhcg11              :  std_logic_vector(32 - 1 DOWNTO 0);
   SIGNAL temp_vhcg12              :  std_logic_vector(32 - 1 DOWNTO 0);
   SIGNAL rd_adr_vhcg1             :  std_logic_vector(10 - 1 DOWNTO 0);
   SIGNAL rd_en_vhcg2              :  std_logic;
   SIGNAL wr_en_vhcg3              :  std_logic;
   SIGNAL wr_data_vhcg4            :  std_logic_vector(32 - 1 DOWNTO 0);
   SIGNAL wr_adr_vhcg5             :  std_logic_vector(10 - 1 DOWNTO 0);
   SIGNAL en_filo_in_vhcg6         :  std_logic;
   SIGNAL filo_in_vhcg7            :  std_logic;

BEGIN
   rd_adr <= rd_adr_vhcg1;
   rd_en <= rd_en_vhcg2;
   wr_en <= wr_en_vhcg3;
   wr_data <= wr_data_vhcg4;
   wr_adr <= wr_adr_vhcg5;
   en_filo_in <= en_filo_in_vhcg6;
   filo_in <= filo_in_vhcg7;
   rd_adr_vhcg1 <= wire_rd_adr_col & next_rd_adr_byte ;
   temp_vhcg8 <= '0' WHEN (wr_adr_vhcg5(6 - 1 DOWNTO 0) = CONV_STD_LOGIC_VECTOR((64 - 1), 7)) ELSE During_traback;
   temp_vhcg9 <= '1' WHEN (dummy_cnt = "10" AND wr_adr_vhcg5(6 - 1 DOWNTO 0) = CONV_STD_LOGIC_VECTOR((64 - 1), 7)) ELSE temp_vhcg8;
   rd_en_vhcg2 <= temp_vhcg9 ;
   next_rd_adr_byte <= next_state(4) ;
   temp_vhcg10 <= wr_adr_vhcg5(10 - 1 DOWNTO 1) WHEN ((valid_in AND CONV_STD_LOGIC(wr_adr_vhcg5(6 - 1 DOWNTO 0) = CONV_STD_LOGIC_VECTOR((64 - 1), 7))) AND CONV_STD_LOGIC(dummy_cnt = "10")) = '1' ELSE rd_adr_col;
   wire_rd_adr_col <= temp_vhcg10 ;
   temp_vhcg11 <= rd_data WHEN rd_en_dl = '1' ELSE "00000000000000000000000000000000";
   temp_vhcg12 <= wr_data_dl WHEN wr_rd_simu = '1' ELSE temp_vhcg11;
   (rd_dec0, rd_dec1, rd_dec2, rd_dec3, rd_dec4, rd_dec5, rd_dec6, rd_dec7, rd_dec8, rd_dec9, rd_dec10, rd_dec11, rd_dec12, rd_dec13, rd_dec14, rd_dec15, rd_dec16, rd_dec17, rd_dec18, rd_dec19, rd_dec20, rd_dec21, rd_dec22, rd_dec23, rd_dec24, rd_dec25, rd_dec26, rd_dec27, rd_dec28, rd_dec29, rd_dec30, rd_dec31) <= temp_vhcg12 ;
   dec_rd_adr_col <= rd_adr_col - "000000001" ;
   rd_adr_byte <= state(5);
   rd_bit <= state(4 downto 0) ;
   next_state <= state(4 + 1 + 1 - 1 DOWNTO 1) & dec ;

   PROCESS (rd_bit, rd_dec0, rd_dec1, rd_dec2, rd_dec3, rd_dec4, rd_dec5, rd_dec6, rd_dec7, rd_dec8, rd_dec9, rd_dec10, rd_dec11, rd_dec12, rd_dec13, rd_dec14, rd_dec15, rd_dec16, rd_dec17, rd_dec18, rd_dec19, rd_dec20, rd_dec21, rd_dec22, rd_dec23, rd_dec24, rd_dec25, rd_dec26, rd_dec27, rd_dec28, rd_dec29, rd_dec30, rd_dec31)
      VARIABLE dec_vhcg13  : std_logic;
   BEGIN
      CASE rd_bit IS
         WHEN  "00000"=>
                  dec_vhcg13 := rd_dec0;
         WHEN "00001" =>
                  dec_vhcg13 := rd_dec1;
         WHEN "00010" =>
                  dec_vhcg13 := rd_dec2;
         WHEN "00011" =>
                  dec_vhcg13 := rd_dec3;
         WHEN "00100" =>
                  dec_vhcg13 := rd_dec4;
         WHEN "00101" =>
                  dec_vhcg13 := rd_dec5;
         WHEN "00110" =>
                  dec_vhcg13 := rd_dec6;
         WHEN "00111" =>
                  dec_vhcg13 := rd_dec7;
         WHEN "01000" =>
                  dec_vhcg13 := rd_dec8;
         WHEN "01001" =>
                  dec_vhcg13 := rd_dec9;
         WHEN "01010" =>
                  dec_vhcg13 := rd_dec10;
         WHEN "01011" =>
                  dec_vhcg13 := rd_dec11;
         WHEN "01100" =>
                  dec_vhcg13 := rd_dec12;
         WHEN "01101" =>
                  dec_vhcg13 := rd_dec13;
         WHEN "01110" =>
                  dec_vhcg13 := rd_dec14;
         WHEN "01111" =>
                  dec_vhcg13 := rd_dec15;
         WHEN "10000" =>
                  dec_vhcg13 := rd_dec16;
         WHEN "10001" =>
                  dec_vhcg13 := rd_dec17;
         WHEN "10010" =>
                  dec_vhcg13 := rd_dec18;
         WHEN "10011" =>
                  dec_vhcg13 := rd_dec19;
         WHEN "10100" =>
                  dec_vhcg13 := rd_dec20;
         WHEN "10101" =>
                  dec_vhcg13 := rd_dec21;
         WHEN "10110" =>
                  dec_vhcg13 := rd_dec22;
         WHEN "10111" =>
                  dec_vhcg13 := rd_dec23;
         WHEN "11000" =>
                  dec_vhcg13 := rd_dec24;
         WHEN "11001" =>
                  dec_vhcg13 := rd_dec25;
         WHEN "11010" =>
                  dec_vhcg13 := rd_dec26;
         WHEN "11011" =>
                  dec_vhcg13 := rd_dec27;
         WHEN "11100" =>
                  dec_vhcg13 := rd_dec28;
         WHEN "11101" =>
                  dec_vhcg13 := rd_dec29;
         WHEN "11110" =>
                  dec_vhcg13 := rd_dec30;
         WHEN "11111" =>
                  dec_vhcg13 := rd_dec31;
         WHEN OTHERS =>
                  NULL;

      END CASE;
      dec <= dec_vhcg13;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rd_en_dl <= '0';
         wr_data_dl <= "00000000000000000000000000000000";
         wr_rd_simu <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (srst = '1') THEN
            rd_en_dl <= '0';
            wr_data_dl <= "00000000000000000000000000000000";
            wr_rd_simu <= '0';
         ELSE
            rd_en_dl <= rd_en_vhcg2;
            IF (((wr_en_vhcg3 AND rd_en_vhcg2) AND CONV_STD_LOGIC(wr_adr_vhcg5 = rd_adr_vhcg1)) = '1') THEN
               wr_rd_simu <= '1';
               wr_data_dl <= wr_data_vhcg4;
            ELSE
               wr_rd_simu <= '0';
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         dummy_cnt <= "00";
         wr_data_vhcg4 <= "00000000000000000000000000000000";
         wr_adr_vhcg5 <= CONV_STD_LOGIC_VECTOR(64 - 1, 10);
         wr_en_vhcg3 <= '0';
         rd_adr_col <= "000000000";
         state <= "000000";
         en_filo_in_vhcg6 <= '0';
         filo_in_vhcg7 <= '0';
         Is_not_first_3blocks <= '0';
         During_traback <= '0';
         During_send_data <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (srst = '1') THEN
            dummy_cnt <= "00";
            wr_data_vhcg4 <= "00000000000000000000000000000000";
            wr_adr_vhcg5 <= CONV_STD_LOGIC_VECTOR(64 - 1, 10);
            wr_en_vhcg3 <= '0';
            rd_adr_col <= "000000000";
            state <= "000000";
            en_filo_in_vhcg6 <= '0';
            filo_in_vhcg7 <= '0';
            Is_not_first_3blocks <= '0';
            During_traback <= '0';
            During_send_data <= '0';
         ELSE
            IF (valid_in = '1') THEN
               wr_en_vhcg3 <= '1';
               wr_data_vhcg4 <= dec0 & dec1 & dec2 & dec3 & dec4 & dec5 & dec6 & dec7 & dec8 & dec9 & dec10 & dec11 & dec12 & dec13 & dec14 & dec15 & dec16 & dec17 & dec18 & dec19 & dec20 & dec21 & dec22 & dec23 & dec24 & dec25 & dec26 & dec27 & dec28 & dec29 & dec30 & dec31;
               wr_adr_vhcg5 <= wr_adr_vhcg5 + "0000000001";
               IF ((During_traback AND Is_not_first_3blocks) = '1') THEN
                  filo_in_vhcg7 <= rd_bit(0);
                  rd_adr_col <= dec_rd_adr_col;
                  state <= next_state(4 + 1 - 1 DOWNTO 0) & next_state(5);
               END IF;
               IF ((CONV_STD_LOGIC(wr_adr_vhcg5(6 - 1 DOWNTO 0) = CONV_STD_LOGIC_VECTOR(64 - 32, 7)) AND Is_not_first_3blocks) = '1') THEN
                  en_filo_in_vhcg6 <= '1';
                  During_send_data <= '1';
               ELSE
                  IF ((CONV_STD_LOGIC(wr_adr_vhcg5(6 - 1 DOWNTO 0) = CONV_STD_LOGIC_VECTOR(64 - 1, 7)) AND Is_not_first_3blocks) = '1') THEN
                     en_filo_in_vhcg6 <= '1';
                     During_send_data <= '0';
                  ELSE
                     en_filo_in_vhcg6 <= During_send_data;
                  END IF;
               END IF;
               IF (wr_adr_vhcg5(6 - 1 DOWNTO 0) = CONV_STD_LOGIC_VECTOR(64 - 1, 7)) THEN
                  IF (dummy_cnt = "10") THEN
                     Is_not_first_3blocks <= '1';
                     During_traback <= '1';
                     rd_adr_col <= wr_adr_vhcg5(10 - 1 DOWNTO 1) - "000000001";
                     state <= "000000";
                  ELSE
                     dummy_cnt <= dummy_cnt + "01";
                  END IF;
               ELSE
                  IF (wr_adr_vhcg5(6 - 1 DOWNTO 0) = CONV_STD_LOGIC_VECTOR(64 - 1, 7)) THEN
                     During_traback <= '0';
                  END IF;
               END IF;
            ELSE
               wr_en_vhcg3 <= '0';
               en_filo_in_vhcg6 <= '0';
            END IF;
         END IF;
      END IF;
   END PROCESS;

END translated;
