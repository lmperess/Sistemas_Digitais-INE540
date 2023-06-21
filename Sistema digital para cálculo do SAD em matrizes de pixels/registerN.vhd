library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerN is
	generic(width: natural;
			resetValue: integer := 0 );
	port(	-- control
			clock, reset, load: in std_logic;
			-- data
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0));
end entity;

architecture behav0 of registerN is

subtype state is std_logic_vector(width-1 downto 0);
signal currentState, nextState: state;

begin

    -- next-state logic  (nao exclua e nem mude esta linha)
    nextState <= input when load='1' else currentState;

	-- memory element --state register-- (nao exclua e nem mude esta linha)
	process(clock, reset) is
	begin
		if reset='1' then
			currentState <= std_logic_vector(to_signed(resetValue, currentState'length));
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- output logic  (nao exclua e nem mude esta linha)
	output <= currentState;
	
end architecture;
