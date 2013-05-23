-- this adder accepts two decimal digits coded in Svoboda encoding and two transfer bits and generates a
-- digit coded in Svoboda encoding and also two transfer bits

entity DFA is
	port ( X,Y: in bit_vector(4 downto 0); -- input digits
		tpi,tni: in bit; -- tpi = transfer positive bit (input), tni = transfer negative bit(input)
		Z: out bit_vector(4 downto 0); -- output digit
		tpo,tno: out bit);-- tpo = transfer positive bit (output), tno = transfer negative bit(output)
end DFA;

architecture mixed of DFA is

component FA
	port (a,b,c: in bit;
		sum,carry: out bit);
end component;
signal intr,carry2,carry1: bit_vector (4 downto 0);
signal a1,a2,cn1,r1,r2,q1,q2,cn2,ttp,ttn: bit;
begin
--	process (X,Y)
--		variable q1,q2,r1,r2,a1,a2: bit ;
--		variable carry1: bit_vector (4 downto 0);
--	begin
		
--		intr(0) <= a1 XOR a2 XOR carry1(3);
--		carry1(0) := (a1 and a2) or (a1 and carry1(3)) or (carry1(3) and a2);
		
--		intr(1) <= X(1) XOR Y(1) XOR carry1(0);
--		carry1(1) := (X(1) and Y(1)) or (X(1) and carry1(0)) or (carry1(0) and X(1));
		
--		intr(2) <= X(2) XOR Y(2) XOR carry1(1);
--		carry1(2) := (X(2) and Y(2)) or (X(2) and carry1(1)) or (carry1(1) and X(2));
		
--		intr(3) <= X(3) XOR Y(3) XOR carry1(2);
--		carry1(3) := (X(3) and Y(3)) or (X(3) and carry1(2)) or (carry1(2) and X(3));
		
--		intr(4) <= X(4) XOR Y(4) XOR carry1(3);
--		carry1(4) := (X(2) and Y(4)) or (X(4) and carry1(3)) or (carry1(3) and X(4));
		
--		c3 <= carry1(3);
--		c4 <= carry1(4);
--		rr1 <= r1;
--		qq1 <= q1;
--		rr2 <= r2;
--		qq2 <= q2;
		
--	end process;

	q1 <= (not X(0)) and X(1) and (not X(2));
	r1 <= (not X(0)) or X(1) or (not X(2));
	q2 <= (not Y(0)) and Y(1) and (not Y(2));
	r2 <= (not Y(0)) or Y(1) or (not Y(2));
	a1 <= (X(0) or q1) and r1;
	a2 <= (Y(0) or q2) and r2;
	cn1<= (X(1) and Y(2) and Y(1) and Y(0)) or (X(2) and Y(3) and Y(2)) 
		or (X(3) and Y(3)) or (X(3) and X(1) and Y(1)) or (X(3) and X(2) and Y(2));
	cn2<= (tpi and tni) or (intr(1) and  (not intr(0)) and tni) or  (intr(3) and tni)
		 or (intr(4) and tni) or (intr(4) and intr(3) and intr(1) and tpi);


	Stage10: FA port map (a1,a2,cn1,intr(0),carry1(0));
	g1:for i in 1 to 4 generate
		stage1:FA port map (X(i),Y(i),carry1(i-1),intr(i),carry1(i));
	end generate;	
	
	Stage20: FA port map (intr(0),tpi,cn2,Z(0),carry2(0));
	Stage21: FA port map (intr(1),tpi,carry2(0),Z(1),carry2(1));
	Stage22: FA port map (intr(2),tni,carry2(1),Z(2),carry2(2));
	Stage23: FA port map (intr(3),tni,carry2(2),Z(3),carry2(3));
	Stage24: FA port map (intr(4),tni,carry2(3),Z(4),carry2(4));
	
	ttp <= carry1(3);
	ttn <= Not (carry1(4));
	tpo <= (r1 and ttp and ttn) or (r2 and ttp and ttn) or (r1 and r2 and ttp) or q1 or q2;
	tno <= NOT ((r1 and r2 and ttn) or (q1 and q2) or (r1 and q2 and ttp) or (q1 and r2 and ttp));	
end mixed;
