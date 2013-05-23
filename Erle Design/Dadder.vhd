-- decimal adder accepts d-digit inputs in svoboda encoding
entity dadder is
	generic (d: positive := 6);
	port (i1,i2:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end entity;

architecture struct of dadder is
component DFA is
	port ( X,Y: in bit_vector(4 downto 0);
		tpi,tni: in bit;
		Z: out bit_vector(4 downto 0);
		tpo,tno: out bit);
end component;
signal tp,tn: bit_vector (d downto 0) := (others => '0');

begin
	g:for k in 1 to d generate
		stage:dfa port map (i1(5*(k)-1 downto 5*(k-1)),i2(5*(k)-1 downto 5*(k-1)),
								tp(k-1),tn(k-1),o(5*k-1 downto 5*(k-1)),tp(k),tn(k));
	end generate;
	o(5*d) <= tp(d);
	o(5*d+1) <= tp(d);
	o(5*d+2) <= tn(d);
	o(5*d+3) <= tn(d);
	o(5*d+4) <= tn(d);
end architecture;
