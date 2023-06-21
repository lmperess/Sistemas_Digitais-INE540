library ieee;
use ieee.std_logic_1164.all;

entity blocooperativo_sad is
	generic(
		datawidth: positive;
		addresswidth: positive);
	port(
		-- control in
		ck, reset, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : in std_logic;
		-- data in
		pA, pB: in std_logic_vector(datawidth-1 downto 0);
		-- controll out
		ender: out std_logic_vector(addresswidth-1 downto 0);
		menor: out std_logic;
		sad: out std_logic_vector(datawidth+addresswidth-1 downto 0)
	);
end entity;

architecture archstruct of blocooperativo_sad is

	component multiplexer2x1 is
		generic (	width: positive );
		port(	input0, input1: in std_logic_vector(width-1 downto 0) := (others => '0');
				sel: in std_logic;
				output: out std_logic_vector(width-1 downto 0) );
	end component;
	
	component addersubtractor is
		generic (	N: positive;
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
		port(	-- control
				clock, reset, load: in std_logic;
				-- data
				input: in std_logic_vector(width-1 downto 0);
				output: out std_logic_vector(width-1 downto 0));
	end component;
	
	component absN is
	generic(	width: positive );
	port(	input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0) );
	end component;
	
	
	-- COMPLETE COM EVENTUAIS SINAIS INTERNOS
	signal isomaOut, iMuxOut, iRegOut, iZeros: std_logic_vector(datawidth-2 downto 0);
	signal iIncr, iend, addresswidthUm, addresswidthZeros: std_logic_vector(addresswidth-1 downto 0);
	signal icout: std_logic;	
	signal pARegOut, pBRegOut, ABsubtrOut, ABabsOut: std_logic_vector(datawidth-1 downto 0);	
	signal absconcOut, somaRegOut, addrdatawidthZeros, absMuxOut, ABaddOut, SADregOut: std_logic_vector(datawidth+addresswidth-1 downto 0);
	
begin
    -- COMPLETE
	addresswidthUm(addresswidth-1 downto 0) <= (0=>'1', others=>'0');
	addresswidthZeros(addresswidth-1 downto 0) <= (others=>'0');
	addrdatawidthZeros(datawidth+addresswidth-1 downto 0) <= (others=>'0');
 	
	iZeros(datawidth-2 downto 0) <= (others=>'0');
	
	-- Lado esquerdo (incremente de i)
	
	muxi: multiplexer2x1 
			generic map(width=>datawidth-1)
			port map(input0=>isomaOut, input1=>iZeros, sel=>zi, output=>iMuxOut);
			
	i: registerN 
			generic map(width=>datawidth-1)
			port map(clock=>ck, reset=>reset, load=>ci, input=>iMuxOut, output=>iRegOut);
				
	
	iend <= iRegOut(addresswidth-1 downto 0);
	ender <= iend;
	menor <= not iRegOut(datawidth-2);
				
	adderi: addersubtractor 
			generic map(N=>addresswidth, isAdder=>true, isSubtractor=>false, generateOvf=>false)
			port map(op=>'0', a=>iend, b=>addresswidthUm, result=>iIncr, ovf=>open, cout=>icout);
			
			
	isomaOut(addresswidth-1 downto 0) <=  iIncr;
	isomaOut(datawidth-2) <=  icout;
						
	-- Lado direito (sum of abstract differences)
	
	A: registerN 
			generic map(width=>datawidth)
			port map(clock=>ck, reset=>reset, load=>cpA, input=>pA, output=>pARegOut);
				
	B: registerN 
			generic map(width=>datawidth)
			port map(clock=>ck, reset=>reset, load=>cpB, input=>pB, output=>pBRegOut);
				
	subtractor: addersubtractor 
			generic map(N=>datawidth, isAdder=>false, isSubtractor=>true, generateOvf=>false)
			port map(op=>'1', a=>pARegOut, b=>pBRegOut, result=>ABsubtrOut, ovf=>open, cout=>open);
			
	abstract: absN
			generic map	(width=>datawidth)
			port map(input=> ABsubtrOut, output=> ABabsOut);
			
			
	
	-- absconcOut <= addresswidthZeros & ABabsOut;
	absconcOut(datawidth+addresswidth-1 downto datawidth) <= addresswidthZeros;
	absconcOut(datawidth-1 downto 0) <= ABabsOut;
	
	adderabs: addersubtractor 
			generic map(N=>datawidth+addresswidth, isAdder=>true, isSubtractor=>false, generateOvf=>false)
			port map(op=>'0', a=>somaRegOut, b=>absconcOut, result=>ABaddOut, ovf=>open, cout=>open);
	
	muxabs: multiplexer2x1 
			generic map(width=>datawidth+addresswidth)
			port map(input0=>ABaddOut, input1=>addrdatawidthZeros, sel=>zsoma, output=>absMuxOut);
					
	soma: registerN 
			generic map(width=>datawidth+addresswidth)
			port map(clock=>ck, reset=>reset, load=>csoma, input=>absMuxOut,	output=>somaRegOut);
	
	SADreg: registerN 
			generic map(width=>datawidth+addresswidth)
			port map(clock=>ck, reset=>reset, load=>csad_reg, input=>somaRegOut, output=>SADregOut);
							
	sad <= SADregOut;
	
	
end architecture;
