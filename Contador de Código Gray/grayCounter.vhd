library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity grayCounter is
	generic(	width: positive := 16;
				generateLoad: boolean := true;
				generateEnb: boolean := true;
				generateInc: boolean := true;
				resetValue: integer := 0 );
	port(	-- control
			clock, reset, load: in std_logic;
			enb, inc: in std_logic;
			-- data
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0)	);
end entity;


architecture behav0 of grayCounter is
    -- Nao altere as duas linhas abaixo
    subtype state is signed(width-1 downto 0);
    signal nextState, currentState: state;
    -- COMPLETE AQUI, SE NECESSARIO
    signal grayOutput, converterInput: std_logic_vector(width-1 downto 0);
begin
	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	-- COMPLETE

	LT_ET_IT: if generateLoad and generateEnb and generateInc generate
	    converterToBinary: for i in width-2 downto 0 generate
	        grayOutput(i) <= grayOutput(i + 1) xor input(i);
	    end generate;
	
	    grayOutput(grayOutput'high) <= '0';
	    
	    nextState <= signed(grayOutput) when load='1' else
	                   currentState when enb='0' else
	               currentState + 1 when inc='1' else
	               currentState - 1;
	end generate;
	
	LT_ET_IF: if generateLoad and generateEnb and not generateInc generate
 
	    converterToBinary: for i in width-2 downto 0 generate
	        grayOutput(i) <= grayOutput(i + 1) xor input(i);
	    end generate;
	
	    grayOutput(grayOutput'high) <= '0';
	    
	    nextState <= signed(grayOutput) when load='1' else
	                   currentState when enb='0' else
	                   currentState + 1;
	end generate;
	
	LF_EF_IF: if not generateLoad and not generateEnb and not generateInc generate
	    nextState <= to_signed(to_integer(currentState) + 1, currentState'length);
	end generate;
	
	LF_EF_TF: if not generateLoad and not generateEnb and generateInc generate
	    nextState <= currentState + 1 when inc='1' else currentState - 1;
	end generate;

	LF_ET_IT: if not generateLoad and generateEnb and generateInc generate
	    nextState <= currentState when enb='0' else
	                 currentState + 1 when inc='1' else
	                 currentState - 1;
    end generate;
    
	LF_ET_IF: if not generateLoad and generateEnb and not generateInc generate
	    nextState <= currentState when enb='0' else
	                 currentState + 1;
    end generate;
    
	LT_EF_IT: if generateLoad and not generateEnb and generateInc generate
 
	    converterToBinary: for i in width-2 downto 0 generate
	        grayOutput(i) <= grayOutput(i + 1) xor input(i);
	    end generate;
	
	    grayOutput(grayOutput'high) <= '0';
	    
	    nextState <= signed(grayOutput) when load='1' else
	               currentState + 1 when inc='1' else
	               currentState - 1;
	end generate;
	
	LT_EF_IF: if generateLoad and not generateEnb and not generateInc generate
 
	    converterToBinary: for i in width-2 downto 0 generate
	        grayOutput(i) <= grayOutput(i + 1) xor input(i);
	    end generate;
	
	    grayOutput(grayOutput'high) <= '0';
	    
	    nextState <= signed(grayOutput) when load='1' else
	               currentState + 1;
	end generate;
	-- end-next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	process(clock, reset) is
	begin
		if reset='1' then
			currentState <= (to_signed(resetValue, currentState'length));
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
    converterInput <= std_logic_vector(currentState);
	
	converterToGray: for i in width-2 downto 0 generate
			output(i) <= converterInput(i) xor converterInput(i + 1);
	end generate;
	
	output(output'high) <= converterInput(converterInput'high);
	
    -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
end architecture;
