entity FA is
	port ( a,b,c: in bit;
			sum,carry: out bit);
end FA;

architecture con of FA is
begin
	sum <= a xor b xor c;
	carry <= (a and b) or (a and c) or (b and c);
end con;