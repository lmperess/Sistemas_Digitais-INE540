library ieee;
use ieee.std_logic_1164.all;

entity blocoControle is
	port(
		-- entrada de controle
		ck, reset, iniciar, 
		resto_maior_divisor : in std_logic;
		-- saída de controle
		quociente0, resto_igual_dividendo, resto_igual_restomenosdividendo, quociente_mais_um, retorno: out std_logic
	);
end entity;

architecture arch of blocoControle is

	type State is (L1, L2, L3, L4, L5,L6,L7);
	signal nextState, currentState: State;
	
begin

	 nextState <= L1 when currentState = L7 or (currentState = L1 and iniciar = '0') else
		           L2 when currentState = S0 and iniciar = '1'                        else
		           L3 when currentState = L2                                          else
					  L4 when currentState = L3 or currentState = L6                     else
					  L5 when currentState = L4 and resto_maior_divisor = '1'              else
					  L6 when currentState = L5                                          else
					  L7 when currentState = l4 and resto_maior_divisor = '0';

	process (ck, reset) is
	 begin
		if reset = '1' then
			currentState <= L1;
		elsif rising_edge(ck) then
			currentState <= nextState;
		end if;	
	end process;
	
	quociente0 <= '1' when currentState = L2 else '0';
	resto_igual_dividendo <= '1' when currentState = L3 else  '0';
	resto_igual_restomenosdividendo <= '1' when currentState = L5 else '0';
	quociente_mais_um <= '1' when currentState = L6 else '0';
	
	retorno <= '1' when currentState = L7 else '0';

end architecture;
