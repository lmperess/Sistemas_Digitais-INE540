library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity deslocador is
	generic(
		larguraDados: positive;
		numBitsDeslocar: integer;
		deslocaParaDireita: boolean;
		deslocaParaEsquerda: boolean
	);
	port(
		Entrada: in std_logic_vector(larguraDados-1 downto 0);
		direcao: in std_logic; --0: deslocaParaDireita, 1: deslocaParaEsquerda
		Saida: out std_logic_vector(larguraDados-1 downto 0)
	);
end entity;

architecture comportamento of Deslocador is

signal shifts: std_logic_vector(numBitsDeslocar-1 downto 0) := (numBitsDeslocar-1 downto 0 => '0');

begin

    shift_l: if (deslocaParaEsquerda and not deslocaParaDireita) generate 
        Saida <= Entrada(larguraDados-numBitsDeslocar-1 downto 0) & shifts;
    end generate;

    shift_r: if (deslocaParaDireita and not deslocaParaEsquerda) generate 
        Saida <= shifts & Entrada(larguraDados-1 downto numBitsDeslocar);
    end generate;

    shift_lr: if (deslocaParaEsquerda and  deslocaParaDireita) generate 
        Saida <= 
            Entrada(larguraDados-numBitsDeslocar-1 downto 0) & shifts when direcao = '1' else
            shifts & Entrada(larguraDados-1 downto numBitsDeslocar);
    end generate;

end architecture;
