library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity moduleCounter is
	generic(	module: positive := 60;
				generateLoad: boolean := true;
				generateEnb: boolean := true;
				generateInc: boolean := true;
				resetValue: integer := 0 );
	port(	-- control
			clock, reset: in std_logic;
			load, enb, inc: in std_logic;
			-- data
			input: in std_logic_vector(integer(ceil(log2(real(module))))-1 downto 0);
			output: out std_logic_vector(integer(ceil(log2(real(module))))-1 downto 0)	);
end entity;


architecture behav0 of moduleCounter is
    -- Nao altere as duas linhas abaixo
    subtype state is unsigned(integer(ceil(log2(real(module))))-1 downto 0);
    signal nextState, currentState: state;
    -- COMPLETE AQUI, SE NECESSARIO
begin
	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)

	LF_EF_IF: if not generateLoad and not generateEnb and not generateInc generate
	    nextState <= currentState + 1 when currentState < module-1 else to_unsigned(0, nextState'length);
	end generate;
	
    LF_EF_IT: if not generateLoad and not generateEnb and generateInc generate
	    nextState <= (others=>'0') when currentState=to_unsigned(module-1, nextState'length) and inc='1' else 
	        currentState + 1 when currentState < to_unsigned(module -1, nextState'length) and inc='1' else 
	        currentState-1 when currentState /= 0 else to_unsigned(module-1, nextState'length);
	end generate;
	
    LF_ET_IT: if not generateLoad and generateEnb and generateInc generate
        nextState <= currentState when enb='0' else
            (others=>'0') when currentState=to_unsigned(module-1, nextState'length) and inc='1' else 
	        currentState + 1 when currentState < to_unsigned(module -1, nextState'length) and inc='1' else 
	        currentState-1 when currentState /= 0 else to_unsigned(module-1, nextState'length);
    end generate;
    
    LF_ET_IF: if not generateLoad and generateEnb and not generateInc generate
	     nextState <= currentState when enb='0' else
            (others=>'0') when currentState=to_unsigned(module-1, nextState'length) else 
	        currentState + 1 when currentState < to_unsigned(module -1, nextState'length);
    end generate;
    
    LT_EF_IT: if generateLoad and not generateEnb and generateInc generate
        nextState <= unsigned(input) when load='1' else
            (others=>'0') when currentState=to_unsigned(module-1, nextState'length) and inc='1' else 
	        currentState + 1 when currentState < to_unsigned(module -1, nextState'length) and inc='1' else 
	        currentState-1 when currentState /= 0 else to_unsigned(module-1, nextState'length);
	end generate;
	
	LT_EF_IF: if generateLoad and not generateEnb and not generateInc generate
        nextState <= unsigned(input) when load='1' else
            (others=>'0') when currentState=to_unsigned(module-1, nextState'length) else 
	        currentState + 1 when currentState < to_unsigned(module -1, nextState'length);
	end generate;
	
	LT_ET_IT: if generateLoad and generateEnb and generateInc generate
        nextState <= unsigned(input) when load='1' else currentState when enb='0' else
            (others=>'0') when currentState=to_unsigned(module-1, nextState'length) and inc='1' else 
	        currentState + 1 when currentState < to_unsigned(module -1, nextState'length) and inc='1' else 
	        currentState-1 when currentState /= 0 else to_unsigned(module-1, nextState'length);
	end generate;
	
	LT_ET_IF: if generateLoad and generateEnb and not generateInc generate
        nextState <= unsigned(input) when load='1' else currentState when enb='0' else
            (others=>'0') when currentState=to_unsigned(module-1, nextState'length) else 
	        currentState + 1 when currentState < to_unsigned(module -1, nextState'length);
	end generate;
	
	-- end-next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	process(clock, reset) is
	begin
		if reset='1' then
			currentState <= (to_unsigned(resetValue, currentState'length));
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
    output <= std_logic_vector(currentState);
    -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
end architecture;
