
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

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
ENTITY encoder IS
   PORT (
      clock                   : IN std_logic;
      reset                   : IN std_logic;
      srst                    : IN std_logic;
      bit_in                  : IN std_logic;
      valid_in                : IN std_logic;
      symbol0                 : OUT std_logic;
      symbol1                 : OUT std_logic;
      valid_out               : OUT std_logic);
END encoder;

ARCHITECTURE translated OF encoder IS


   SIGNAL shift_reg                :  std_logic_vector(7 - 2 DOWNTO 0);
   SIGNAL cval                     :  std_logic_vector(7 - 1 DOWNTO 0);
   SIGNAL symbol0_vhcg1            :  std_logic;
   SIGNAL symbol1_vhcg2            :  std_logic;
   SIGNAL valid_out_vhcg3          :  std_logic;

BEGIN
   symbol0 <= symbol0_vhcg1;
   symbol1 <= symbol1_vhcg2;
   valid_out <= valid_out_vhcg3;

   PROCESS (reset, clock)
   BEGIN
      IF (reset = '1') THEN
         shift_reg <= '0' & '0' & '0' & '0' & '0' & '0';
      ELSIF (clock'EVENT AND clock = '1') THEN
         IF (srst = '1') THEN
            shift_reg <= '0' & '0' & '0' & '0' & '0' & '0';
         ELSE
            IF (valid_in = '1') THEN
               shift_reg <= bit_in & shift_reg(7 - 2 DOWNTO 1);
            END IF;
         END IF;
      END IF;
   END PROCESS;
   cval <= bit_in & shift_reg ;

   PROCESS (reset, clock)
   BEGIN
      IF (reset = '1') THEN
         symbol0_vhcg1 <= '0';
         symbol1_vhcg2 <= '0';
         valid_out_vhcg3 <= '0';
      ELSIF (clock'EVENT AND clock = '1') THEN
         IF (srst = '1') THEN
            symbol0_vhcg1 <= '0';
            symbol1_vhcg2 <= '0';
            valid_out_vhcg3 <= '0';
         ELSE
            IF (valid_in = '1') THEN
               symbol0_vhcg1 <= (((cval(6) XOR cval(4)) XOR cval(3)) XOR cval(1)) XOR cval(0);
               symbol1_vhcg2 <= (((cval(6) XOR cval(5)) XOR cval(4)) XOR cval(3)) XOR cval(0);
               valid_out_vhcg3 <= '1';
            ELSE
               valid_out_vhcg3 <= '0';
            END IF;
         END IF;
      END IF;
   END PROCESS;

END translated;
