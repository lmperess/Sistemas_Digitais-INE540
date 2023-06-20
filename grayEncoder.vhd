library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity grayEncoder is
	generic(width: natural);
	port(	binInput: in std_logic_vector(width-1 downto 0);
			grayOutput: out std_logic_vector(width-1 downto 0) );
end entity;

architecture concurrent_behav0 of grayEncoder is
signal b: std_logic_vector(width-1 downto 0);
begin

b <= binInput;

ff: for i in 0 to width-2 generate
        grayOutput(i) <= b(i) xor b(i+1);
    end generate;
    
    grayOutput(width-1) <= b(width-1) xor '0';

end architecture;
