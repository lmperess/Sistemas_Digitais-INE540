library ieee;
use ieee.std_logic_1164.all;

entity blocoOperativo is
	generic(
		largDividendo: integer;
      largDivisor: integer);
	port(
		-- entrada de controle
		ck, reset, quociente0, resto_igual_dividendo, resto_igual_restomenosdividendo, quociente_mais_um : in std_logic;
		-- entrada de dados
	   quocienteZero: in std_logic_vector(largDividendo-1 downto 0);
		dividendo: in std_logic_vector(largDividendo-1 downto 0);
      divisor: in std_logic_vector(largDivisor-1 downto 0);
		-- saída de controle
		quociente: out std_logic_vector(largDividendo-1 downto 0);
      resto: out std_logic_vector(largDivisor-1 downto 0);
      resto_maior_divisor : out std_logic		
	);
end entity;

architecture arch of blocoOperativo is

	signal mais_um,q_soma_um,registrador_resto,registrador_quociente : std_logic_vector(largDividendo-1 downto 0);
	signal ABsubtrOut : std_logic_vector(largDivisor-1 downto 0);

	component addersubtractor is
		generic (N: positive;
					isAdder: boolean;
					isSubtractor: boolean;
					generateOvf: boolean);
		port(	op: in std_logic;
				a, b: in std_logic_vector(N-1 downto 0);
				result: out std_logic_vector(N-1 downto 0);
				ovf, cout: out std_logic );
	end component;
	
	component registerN is
		generic(	width: natural;
					resetValue: integer := 0 );
		port(	-- controle
				clock, reset, load: in std_logic;
				-- dados
				input: in std_logic_vector(width-1 downto 0);
				output: out std_logic_vector(width-1 downto 0));
	end component;
	
begin
	
   mais_um(largDividendo-1 downto 0) <= (0=>'1', others=>'0');
   quocienteZero(largDividendo-1 downto 0) <= (0=>'0', others=>'0');
    
	quociente0: registerN 
			generic map(width=>largDividendo)
			port map(clock=>ck, reset=>reset, load=>quociente0, input=>quocienteZero, output=>registrador_quociente);
	restoValeDividendo:registerN 
			generic map(width=>largDividendo)
			port map(clock=>ck, reset=>reset, load=>resto_igual_dividendo, input=>dividendo, output=>registrador_resto);
	
	resto_maior_divisor <= '1' when registrador_resto >= dividendo else '0';
	
   subresto: addersubtractor 
			generic map(N=>largDivisor, isAdder=>false, isSubtractor=>true, generateOvf=>false)
			port map(op=>'1', a=>registrador_resto, b=>divisor, result=>ABsubtrOut, ovf=>open, cout=>open);
			
   adderQ: addersubtractor 
			generic map(N=>largDividendo, isAdder=>true, isSubtractor=>false, generateOvf=>false)
			port map(op=>'0', a=>registrador_quociente, b=>mais_um, result=>q_soma_um, ovf=>open, cout=>open);
			
	restomenosdivisor:registerN 
			generic map(width=>largDivisor)
			port map(clock=>ck, reset=>reset, load=>resto_igual_dividendo, input=>ABsubtrOut, output=>registrador_resto);
			
	quocientemaisUm:registerN 
			generic map(width=>largDividendo)
			port map(clock=>ck, reset=>reset, load=>quociente_mais_um, input=>q_soma_um, output=>registrador_quociente);
	
	quociente<=ReqQuociente;
	resto<=registrador_resto;
	
end architecture;
