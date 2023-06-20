library ieee;
use ieee.std_logic_1164.all;

entity example2FSMPedroni is
	port(
		-- control inputs
		clock, reset: in std_logic;
		-- data inputs
		inp: in std_logic;
		-- control outputs
		-- data outputs
		outp: out std_logic_vector(1 downto 0)
	);
end entity;

architecture archstudenttryPg195 of example2FSMPedroni is
	type State is (s1, s2, s3, s4);
	signal currentState, nextState: State;
begin

	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	process(inp, currentState) is
	begin
		nextState <= currentState;
		CASE currentState is
		
		 when s1 =>
		  if inp = '0' then
		  nextState <= s1;
		  else
		  nextState <= s2;
		  end if;
		  
		 when s2 => 
			if inp = '0' then
			nextState <= s3;
			else
			nextState <= s4;
			end if;
			
		 when s3 => 
			if inp = '0' then
			nextState <= s3;
			else
			nextState <= s4;
			end if;
			
		 when s4 => 
			if inp = '0' then
			nextState <= s2;
			else
			nextState <= s1;
			end if;
			
		end CASE;
	end process;		
	-- end-next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	process(clock, reset) is
	begin
		if reset = '1' then
		currentState <= s1;
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
    outp <= "00" when currentState = s1 else
				"01" when currentState = s2 else
				"10" when currentState = s3 else
				"11" when currentState = s4;
    -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
end architecture;
