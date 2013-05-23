-- the online multiplier
entity onlineMR is
	generic (dd: positive := 7); -- the number of digits that the multiplier can accomudate
	port (x,y: in bit_vector (4 downto 0);
			clock,rst: in bit;
			Zlow: out bit_vector (5*(dd+2)-1 downto 0);
			z: out bit_vector (4 downto 0));
end entity;

