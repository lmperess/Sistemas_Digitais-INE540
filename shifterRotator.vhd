library ieee;
use ieee.std_logic_1164.all;

entity shifterRotator is
    generic(
        width: positive;
        isShifter: boolean; -- true para operação de deslocamento, false para operação de rotação
        isLogical: boolean;  -- true para deslocamento lógico, false para deslocamento aritmético
        toLeft: boolean;  -- true para deslocar/rotacionar para a esquerda, false para direita
        bitsToShift: positive -- quantidade de bits a serem deslocados/rotacionados
    );
    port(
        input: in std_logic_vector(width-1 downto 0);
        output: out std_logic_vector(width-1 downto 0)
    );
    begin
        assert (bitsToShift < width) severity error;
end entity;

architecture behav of shifterRotator is

signal concat0: std_logic_vector(bitsToShift-1 downto 0); 
signal concat1: std_logic_vector(bitsToShift-1 downto 0); 

begin
concat0 <= (others => '0');
concat1 <= (others => '1');

 genShift: if isShifter generate  -- deslocador
    genLogic: if isLogical generate  -- deslocamento lógico
        output <= input(width-1-bitsToShift downto 0) & concat0 when toLeft else  -- para esquerda
                  concat0 & input(width-1 downto bitsToShift);  -- para direita
    end generate genLogic;
    
    genArith: if not isLogical generate -- Deslocamento Aritmético
        output <= input(width-1-bitsToShift downto 0) & concat0 when toLeft else -- para esquerda
                  concat1 & input(width-1 downto BitsToShift) when input(width-1) = '1' else -- concatena 1 à esquerda
                  concat0 & input(width-1 downto BitsToShift); -- concatena 0 à esquerda
                   
    end generate genArith;
 end generate genShift;
 

 genRotate: if not isShifter generate -- Rotacionador
        genRotateLeft: if toLeft generate -- Rotação para a esquerda
            output <= input(width-1-bitsToShift downto 0) & input(width-1 downto width-bitsToShift);
        end generate genRotateLeft;
        genRotateRight: if not toLeft generate -- Rotação para a direita
            output <= input(bitsToShift-1 downto 0) & input(width-1 downto bitsToShift);
        end generate genRotateRight;
    end generate genRotate;
    
end architecture;
