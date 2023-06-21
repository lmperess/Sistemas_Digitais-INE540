library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity arbitraryCounter is
	generic(min: natural;
	        max: natural;
	        step: natural;
			generateLoad: boolean;
			generateEnb: boolean;
			generateInc: boolean);
	port(	-- control
			clock, reset, load: in std_logic;
			enb, inc: in std_logic;
			-- data
			input: in std_logic_vector(integer(ceil(log2(real(max))))-1 downto 0);
			output: out std_logic_vector(integer(ceil(log2(real(max))))-1 downto 0)	);
	begin
		assert min<max report "Min should be smaller than max" severity error;
		assert step<(max-min) report "Step should be smaller than the max-min interval" severity error;
end entity;


architecture behav0 of arbitraryCounter is
    -- Nao altere as duas linhas abaixo
    subtype state is unsigned(integer(ceil(log2(real(max))))-1 downto 0);
    signal nextState, currentState: state;
    -- COMPLETE AQUI, SE NECESSARIO
    signal test: std_logic_vector(integer(ceil(log2(real(max))))-1 downto 0) := (others=>'0');
    signal result: state;

begin
  
	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
    LF_EF_IF: if not generateLoad and not generateEnb and not generateInc generate
        result <= currentState + to_unsigned(step, currentState'length);
	    nextState <= 
			result when result <= to_unsigned(max, result'length) else 
				to_unsigned(min, result'length);
	end generate;
	
    LF_EF_IT: if not generateLoad and not generateEnb and generateInc generate
        result <= 
			(currentState + to_unsigned(step, currentState'length)) when inc = '1' else 
                (currentState - to_unsigned(step, currentState'length));
                  
	    nextState <= 
			result when inc = '1' and result <= to_unsigned(max, result'length) else 
	        	to_unsigned(min, result'length) when inc = '1' else
	        		result when inc = '0' and result >= to_unsigned(min, result'length) else 
						to_unsigned(max, result'length);
	end generate;
	
    LF_ET_IF: if not generateLoad and generateEnb and not generateInc generate
        result <= currentState + to_unsigned(step, currentState'length);
	    nextState <= 
			currentState when enb = '0' else 
	            result when result <= to_unsigned(max, result'length) 
					else to_unsigned(min, result'length);
	end generate;
	
    LF_ET_IT: if not generateLoad and generateEnb and generateInc generate
        result <= 
			(currentState + to_unsigned(step, currentState'length)) when inc = '1' else 
                (currentState - to_unsigned(step, currentState'length));
                  
	    nextState <= currentState when enb = '0' else 
	    	result when inc = '1' and result <= to_unsigned(max, result'length) else 
	        	to_unsigned(min, result'length) when inc = '1' else
	        		result when inc = '0' and result >= to_unsigned(min, result'length) else to_unsigned(max, result'length);
	end generate;
	
    LT_EF_IT: if generateLoad and not generateEnb and generateInc generate
        result <= 
			(currentState + to_unsigned(step, currentState'length)) when inc = '1' else 
                (currentState - to_unsigned(step, currentState'length));
                  
	    nextState <= 
			unsigned(input) when load = '1' else 
	        	result when inc = '1' and result <= to_unsigned(max, result'length) else 
	         		to_unsigned(min, result'length) when inc = '1' else
	         			result when inc = '0' and result >= to_unsigned(min, result'length) else 
							to_unsigned(max, result'length);
	end generate;
	
    LT_ET_IT: if generateLoad and generateEnb and generateInc generate
        result <= 
			(currentState + to_unsigned(step, currentState'length)) when inc = '1' else 
                (currentState - to_unsigned(step, currentState'length));
                  
	    nextState <= unsigned(input) when load = '1' else 
			currentState when enb = '0' else 
				result when inc = '1' and result <= to_unsigned(max, result'length) else 
	         		to_unsigned(min, result'length) when inc = '1' else
	         			result when inc = '0' and result >= to_unsigned(min, result'length) else 
							to_unsigned(max, result'length);
	end generate;
	
    LT_EF_IF: if generateLoad and not generateEnb and not generateInc generate
        result <= currentState + to_unsigned(step, currentState'length);
	    nextState <= 
			unsigned(input) when load = '1' else 
	            result when result <= to_unsigned(max, result'length) 
					else to_unsigned(min, result'length);
	end generate;
	
    LT_ET_IF: if generateLoad and generateEnb and not generateInc generate
        result <= currentState + to_unsigned(step, currentState'length);
	    nextState <= 
			unsigned(input) when load = '1' else 
	            currentState when enb = '0' else 
	                result when result <= to_unsigned(max, result'length) else to_unsigned(min, result'length);
	end generate;

	-- end-next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	process(clock, reset) is
	begin
		if reset='1' then
			currentState <= to_unsigned(min, currentState'length); --COMPLETE
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
    output <= std_logic_vector(currentState);
    -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
                                  
end architecture;
