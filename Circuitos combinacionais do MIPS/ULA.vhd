library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
	generic(width: positive := 16);
	port(
		op: in std_logic_vector(2 downto 0);
		a, b: in std_logic_vector(width-1 downto 0);
		zero: out std_logic;
		res: out std_logic_vector(width-1 downto 0)
	);
end entity;

architecture Behavioral of ULA is

signal tmp: std_logic_vector(width-1 downto 0);

begin

tmp <= a and b when op = "000" else
       a or b when op = "001" else
       std_logic_vector(unsigned(a) + unsigned(b)) when op = "010" else
       std_logic_vector(unsigned(a) - unsigned(b)) when op = "110" else
       (0 => '1', others => '0') when a < b and op = "111" else (others => '0');

res <= tmp;

zero <= '1' when tmp = (width-1 downto 0 => '0') else '0';
    
end architecture;
