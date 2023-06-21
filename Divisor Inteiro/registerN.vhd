library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerN is
	generic(	width: natural;
				resetValue: integer := 0 );
	port(	-- controle
			clock, reset, load: in std_logic;
			-- dados
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0));
end entity;

architecture arch of registerN is

subtype state is std_logic_vector(width-1 downto 0);

	signal currentState, nextState: state;
	
begin
    
   nextState <= input when load='1' else currentState;

	process(clock, reset) is
	begin
		if reset='1' then
			currentState <= std_logic_vector(to_signed(resetValue, currentState'length));
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	
	output <= currentState;
	
end architecture;
