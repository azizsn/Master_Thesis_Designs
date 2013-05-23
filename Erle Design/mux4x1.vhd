entity mux4X1 is
	generic (n: positive :=8);
	port ( I0,I1,I2,I3: in bit_vector (n-1 downto 0);
			s: in bit_vector(1 downto 0);
			o: out bit_vector (n-1 downto 0));
end mux4x1;

architecture behave of mux4x1 is
begin
	process (I0,I1,I2,I3,s)
	begin
		case s is
			when "00" => o <= I0;
			when "01" => o <= I1;
			when "10" => o <= I2;
			when "11" => o <= I3;
		end case;
	end process;
end behave;
