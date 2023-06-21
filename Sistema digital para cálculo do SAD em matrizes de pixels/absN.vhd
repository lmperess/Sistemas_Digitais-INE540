library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity absN is
	generic(width: positive);
	port(	input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0));
end entity;

architecture behav0 of absN is
begin

output <= input when input(width-1) = '0' else std_logic_vector(signed(not input)+1);

end architecture;
