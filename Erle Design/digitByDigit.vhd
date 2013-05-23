
Entity digitByDigit is
	port (a,b: in bit_vector (3 downto 0);
		p: out bit_vector (3 downto 0);
		p1:out bit_vector (2 downto 0));
End Entity;

Architecture con of digitByDigit is
	signal t,p3: bit;
begin
	p(0) <= not (not a(0) or not b(0));
	p(1) <= not (not (a(1) and not b(1) and not b(0)) and 
					not (b(1) and not a(1) and not a(0)));
	p(2) <= not (not (a(0) and b(2) and b(0)) and 
				not ((a(1) xor a(0)) and b(1) and b(0)) and 
				not (a(1) and b(1) and not b(0)) and 
				not (not a(1) and not a(0) and not b(1) and not b(0)));
	p(3) <= t xor p3;
	
	p3 <= not (not (not a(0) and not b(0) and not b(1)) and 
				not (a(1) and b(1) and b(0)) and 
				not (not (a(1) xor a(0)) and b(1) and not b(0)));
	
	p1(0) <= not (not (a(1) and b(2)) and 
				not ((a(2) or a(0))and b(1)) and 
				not (a(1) and b(0)));
	p1(1) <= not (not a(2) or not b(2));
	p1(2) <= t;
	t <= a(3) xor b(3);

End con;