library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rippleCounter is
	generic(	width: positive := 8;
				generateLoad: boolean := true;
				generateEnb: boolean := true;
				generateInc: boolean := true);
	port(	    -- control
		    	clock, reset: in std_logic;
		    	load, enb, inc: in std_logic;
		    	-- data
		    	input: in std_logic_vector(width-1 downto 0);
		    	output: out std_logic_vector(width-1 downto 0)	);
end entity;


architecture behav0 of rippleCounter is
    -- nao alterar as duas linhas abaixo
    subtype state is unsigned(width-1 downto 0);
    signal nextState, currentState: state;
    signal aux: unsigned(width-1 downto 0);
	 
begin
	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)

	process(clock, reset, load, enb, inc)
	begin	
	
		aux <= (others => '0');
		aux(width-1) <= '1';
		nextState <= currentState;
	   
		if reset = '0' then
			if to_integer(currentState) > to_integer(aux)/2 then
				nextState <= to_unsigned(1, nextState'length);
			else
				nextState <= shift_left(currentState, 1);
			end if;
		end if;
		
		genLoad: if generateLoad and reset = '0' and load = '1' then
			nextState <= unsigned(input);
			
			if to_integer(unsigned(input)) > to_integer(aux)/2 then
				nextState <= to_unsigned(1, nextState'length);
			end if;
			
			if to_integer(unsigned(input)) < 2 then
			    nextState <= aux;
			end if;
		end if;
			
		genEnb: if generateEnb and reset = '0' and enb = '0' then
			nextState <= currentState;
		end if;
		
		genInc: if generateInc and reset = '0' and inc = '0' and (not generateEnb or enb = '1') then
			if to_integer(currentState) < 2 then
				nextState <= aux;
			else
				nextState <= shift_right(currentState, 1);
			end if;
		end if;
		
	end process;
	
	-- end-next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	
                                 
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	process(clock, reset) is
	begin
		if reset='1' then
			currentState <= to_unsigned(1, currentState'length);
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
	
        output <= std_logic_vector(currentState);
		  
   -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
                                  
end architecture;
