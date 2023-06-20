library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binaryDecoder10x1024 is
	generic(inputWidth: positive := x); -- substitua x pelo valor que você quer
	port(   input: in std_logic_vector(inputWidth-1 downto 0);
	        output: out std_logic_vector(2**inputWidth-1 downto 0));
end entity;

architecture arch_binaryDecoder10x1024 of binaryDecoder10x1024 is
constant aux: unsigned(2**InputWidth-1 downto 0) := (0 => '1', others => '0');
begin

output <= std_logic_vector(shift_left(aux, to_integer(unsigned(input))));

end architecture;
