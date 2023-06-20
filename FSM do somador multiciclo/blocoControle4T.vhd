library ieee;
use ieee.std_logic_1164.all;
use work.BC_State.all;

entity blocoControle4T is
	port(
		-- control in
		clock, reset, iniciar: in std_logic;
		-- control in (status signals from BC)
		zero, ov: in std_logic;
		-- control out 
		erro, pronto: out std_logic;
		-- control out (command signals to BC)
		scont, ccont, zAC, cAC, cT: out std_logic;
		-- Tests
		stateBC: out State
	);
end entity;

architecture descricaoComportamental of blocoControle4T is
    -- não acrescente nada aqui. State está definido no package work.BC_State
    signal nextState, currentState: State;
begin
	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	process(currentState, zero, ov, iniciar)
	begin
	nextState <= currentState;
	CASE currentState is 	
		 when s0 =>
		  if iniciar = '0' then
				nextState <= s0;
		  else
				nextState <= s1;
		  end if;
	
		 when s1 => 
		  nextState <= s2;	  
		  
		 when s2 => 
		  if zero = '1' then
				nextState <= s0;
		  else
				nextState <= s3;
		  end if;
				
		 when s3 => 
		  if ov = '1' then
				nextState <= e;
		  else
				nextState <= s2;
		  end if;
		  
		 when e =>
		  if iniciar = '0' then
				nextState <= e;
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
		currentState <= s0;
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	
	-- output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
	stateBC <= currentState;
    erro <= '1' when currentState = e else '0';
	pronto <= '1' when (currentState = e or currentState = s0) else '0';
	scont <= '1' when currentState = s1 else '0';
	ccont <= '1' when (currentState = s1 or currentState = s3) else '0'; 
	zAC <= '1' when currentState = s1 else '0';
	cAC <= '1' when (currentState = s1 or currentState = s3) else '0';
	cT <= '1' when (currentState = s1 or currentState = s3) else '0';
    -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
end architecture;
