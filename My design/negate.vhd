-- this component change the sign of the inputted number (sbovoda encoding)

Entity negate is
	generic (d: positive := 3);
	port ( X: in bit_vector(5*d-1 downto 0); -- input digits
		sgn: in bit;
		Z: out bit_vector(5*d-1 downto 0)); -- output digit
end entity;

architecture df of negate is
--variable tmp: bit_vector(5*d-1 downto 0);
begin
	process (X,sgn)
	begin
		if (sgn = '1') then
			Z <= Not X;
		else
			Z <= X;
		end if;
	end process;
end df;