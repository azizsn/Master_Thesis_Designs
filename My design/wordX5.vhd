
entity SbvdwordX5 is
	generic (d: positive := 5);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end entity;

architecture struct of sbvdwordX5 is
component svbdX5 is
	port ( X,tf: in bit_vector(4 downto 0); -- input digit and transfered digit
		sgnb: in bit;-- sign of the previous digit (0 positive, 1 negative)
		sgnf: out bit; -- sign bit to the next digit
		Z,tb: out bit_vector(4 downto 0)); -- output digit, and the transfer-back digit 
		
end component;
signal sgn: bit_vector (d downto 0) := (others => '0');
signal trf:bit_vector(5*d+4 downto 0) := (others => '0');
begin
	g:for k in 1 to d generate
		stage:svbdX5 port map (i(5*(k)-1 downto 5*(k-1)),trf(5*(k)+4 downto 5*(k)),sgn(k-1),
					sgn(k),o(5*(k)+4 downto 5*(k)),trf(5*(k)-1 downto 5*(k-1)));
	end generate;
	o(4 downto 0) <= trf(4 downto 0);
end architecture;
