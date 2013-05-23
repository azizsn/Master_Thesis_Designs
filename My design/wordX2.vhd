
entity SbvdwordX2 is
	generic (d: positive := 3);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d+4 downto 0));
end entity;

architecture struct of sbvdwordX2 is
component svbdX2 is
	port ( X: in bit_vector(4 downto 0); -- input digits
		tpi,tni: in bit;
		Z: out bit_vector(4 downto 0); -- output digit
		tpo,tno: out bit);-- tpo = transfer positive bit (output), tno = transfer negative bit(output)
end component;
signal tp,tn: bit_vector (d downto 0) := (others => '0');
begin
	g:for k in 1 to d generate
		stage:svbdX2 port map (i(5*(k)-1 downto 5*(k-1)),tp(k-1),tn(k-1),o(5*k-1 downto 5*(k-1)),tp(k),tn(k));
	end generate;
	o(5*d) <= tp(d);
	o(5*d+1) <= tp(d);
	o(5*d+2) <= tn(d);
	o(5*d+3) <= tn(d);
	o(5*d+4) <= tn(d);
end architecture;