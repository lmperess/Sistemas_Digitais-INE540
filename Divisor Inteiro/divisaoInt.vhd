library ieee;
use ieee.std_logic_1164.all;

entity divisaoInt is
    generic(largDividendo: integer;
            largDivisor: integer);
    port (  -- entrada de controle
            ck, iniciar,reset: in std_logic;
            -- entrada de dados
            dividendo: in std_logic_vector(largDividendo-1 downto 0);
            divisor: in std_logic_vector(largDivisor-1 downto 0);
            -- saída de controle
            quociente: out std_logic_vector(largDividendo-1 downto 0);
            resto: out std_logic_vector(largDivisor-1 downto 0);
            retorno: out std_logic);
end entity;

architecture SD of divisaoInt is

	signal quociente0, resto_igual_dividendo, resto_igual_restomenosdividendo, quociente_mais_um,resto_maior_divisor : std_logic;

	component blocooperativo is
	generic(
		  largDividendo: integer;
        largDivisor: integer);
	port(
		-- entrada de controle
		ck, reset, quociente0, resto_igual_dividendo, resto_igual_restomenosdividendo, quociente_mais_um : in std_logic;
		-- entrada de dados
		dividendo: in std_logic_vector(largDividendo-1 downto 0);
        divisor: in std_logic_vector(largDivisor-1 downto 0);
		-- saida de controle
		quociente: out std_logic_vector(largDividendo-1 downto 0);
      resto: out std_logic_vector(largDivisor-1 downto 0);
      resto_maior_divisor : out std_logic
		);
	end component;
	
	component blococontrole is
		port(
		-- entrada de controle
		ck, reset, iniciar, 
		resto_maior_divisor : in std_logic;
		-- saida de controle
		quociente0, resto_igual_dividendo, resto_igual_restomenosdividendo, quociente_mais_um, retorno: out std_logic
		);
	end component;

begin
    
    BO: blocooperativo
			generic map(largDividendo=>largDividendo, largDivisor=>largDivisor)
			port map(ck=>ck, reset=>reset, quociente0=>quociente0, resto_igual_dividendo=>resto_igual_dividendo, resto_igual_restomenosdividendo=>resto_igual_restomenosdividendo, quociente_mais_um=>quociente_mais_um, dividendo=>dividendo, divisor=>divisor, quociente=>quociente, resto=>resto, resto_maior_divisor=>resto_maior_divisor);
			
	BC: blococontrole
			port map(ck=>ck, reset=>reset, iniciar=>iniciar, resto_maior_divisor=>resto_maior_divisor, quociente0=>quociente0, resto_igual_dividendo=>resto_igual_dividendo, resto_igual_restomenosdividendo=>resto_igual_restomenosdividendo, quociente_mais_um=>quociente_mais_um, retorno=>retorno);

end architecture;
