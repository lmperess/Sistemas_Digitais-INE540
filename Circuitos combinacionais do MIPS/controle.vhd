library ieee;
use ieee.std_logic_1164.all;

entity Controle is
	port(
		Opcode: in std_logic_vector(5 downto 0);
		RegDst, DvCeq, DvCne, DvI, LerMem, MemParaReg, EscMem, ULAFonte, EscReg: out std_logic;
		ULAOp: out std_logic_vector(1 downto 0)
	);
end entity;

architecture comportamento of Controle is

begin

    RegDst <= '1' when Opcode = "000000" else '0';
    DvCeq <= '1' when Opcode = "000100" else '0';
    DvCne <= '0';
    DvI <= '1' when Opcode = "000010" else '0';
    LerMem <= '1' when Opcode = "100011" else '0';
    MemParaReg <= '1' when Opcode = "100011" else '0';
    EscMem <= '1' when Opcode = "101011" else '0';
    ULAFonte <= '1' when Opcode = "100011" or Opcode = "101011" else '0';
    EscReg <= '1' when Opcode = "000000" or Opcode = "100011" or Opcode = "001000" else '0';
    ULAOp <= "00" when Opcode = "100011" or Opcode = "101011" else "01" when Opcode = "000100" else "10";
    
end architecture;
